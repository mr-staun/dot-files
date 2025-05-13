import argparse
import logging
from pathlib import Path
import shutil
import sys


def create_logger(log_level: str):

    # Convert the log level to a number to check it is valid
    numeric_level = getattr(logging, log_level.upper(), None)
    if not isinstance(numeric_level, int):
        raise ValueError(f"Invalid log level: {log_level}")

    # Create and configure the logger
    logger = logging.getLogger(__name__)
    logger.setLevel(numeric_level)

    # Set up handler to output to stdout
    handler = logging.StreamHandler(sys.stdout)
    handler.setLevel(numeric_level)
    # Only have more logging data when debug is set
    if numeric_level == logging.DEBUG:
        formatter = logging.Formatter('%(asctime)s [%(filename)s:%(funcName)s] - %(levelname)s: %(message)s')
    else:
        formatter = logging.Formatter('%(message)s')
    handler.setFormatter(formatter)

    if not logger.hasHandlers():
        logger.addHandler(handler)

    return logger

def get_overlay_file(host: str, overlay_path: Path, logger) -> Path | None:
    for overlay_file in overlay_path.rglob("*"):
        if overlay_file.is_file():
            stripped_file_name = overlay_file.stem.lstrip("config_")
            if stripped_file_name == host:
                logger.debug(f"Overlay file '{overlay_file}' matches host '{host}'")
                return overlay_file
            else:
                logger.debug(f"Overlay file '{overlay_file}' does not match host '{host}'")
    
    return None


def parse_arguments(args):

    parser = argparse.ArgumentParser(prog="build-config", description="CLI tool that builds and copies dot-files to the right locations")

    parser.add_argument("-o", "--output-dir", type=str, required=False, dest="output_dir", metavar="OUTPUT_DIR", help="Directory where configuration will be copied to. " \
    "Defaults to home directory if not set.")

    parser.add_argument("--host", type=str, required=False, help="Build configuration using an overlay for a specific host.")

    parser.add_argument("--dry-run", action="store_true", default=False, help="Flag to specify a dry-run. No changes are written, only shows changes to be made.")

    default_log_level = "DEBUG"
    parser.add_argument("--log-level", dest="log_level", type=str, required=False, default=default_log_level,
                        help=f"Set the log level. Default level is '{default_log_level}'")

    return parser.parse_args(args)


def main(args):
    parsed_args = parse_arguments(args)
    logger = create_logger(parsed_args.log_level)

    if parsed_args.output_dir is None:
        output_dir = Path.home()
    else:
        output_dir = Path(parsed_args.output_dir).resolve()

    logger.debug(f"Output directory was set to {str(output_dir)}")

    # Validate output directory
    if not output_dir.is_dir():
        logger.error(f"Output directory '{output_dir}' is not valid or does not exist!")
        sys.exit(1)

    # Get the Python script's directory and root directory
    python_script_dir = Path(__file__).resolve().parent
    logger.debug(f"Script directory is {python_script_dir}")
    dot_files_root_dir = python_script_dir.parent
    logger.debug(f"Root directory of dot-files is {dot_files_root_dir}")

    # Confirm that common config directory exists
    dot_files_config_dir = dot_files_root_dir / "config" / "common"
    if not dot_files_config_dir.is_dir():
        logger.error(f"Error! Common config directory does not exist! Expected '{dot_files_config_dir}'")
        return 1
    logger.debug(f"Config directory is {dot_files_config_dir}")

    # Confirm that overlays directory exists
    dot_files_overlays_dir = dot_files_root_dir / "config" / "overlays"
    if not dot_files_overlays_dir.is_dir():
        logger.error(f"Error! Overlays directory does not exist! Expected '{dot_files_overlays_dir}'")
        return 1
    logger.debug(f"Overlays directory is {dot_files_overlays_dir}")

    # Confirm that target home directory exists
    dot_files_home_config_dir = dot_files_root_dir / "home"
    if not dot_files_home_config_dir.is_dir():
        logger.error(f"Error! Dot files directory does not exist! Expected '{dot_files_home_config_dir}'")
        return 1
    logger.debug(f"Home config directory is {dot_files_home_config_dir}")

    logger.info("Copying home dot files")

    # Copy dot files to Home/Destination directory
    for dot_file in dot_files_home_config_dir.rglob("*"):
        if dot_file.is_dir():
            logger.error(f"Error! Found directory '{dot_file}' in home dot files. Directories belong inside '.config'")
            return 1
        if dot_file.is_file():
            dest_path = output_dir / ("." + dot_file.name)
            if parsed_args.dry_run:
                logger.info(f"Dry run of copying dot file '{dot_file}' to '{dest_path}'")
            else:
                logger.debug(f"Copying dot file '{dot_file}' to '{dest_path}'")
                shutil.copy(str(dot_file), str(dest_path))
    
    # Create config directory
    output_config_dir = output_dir / ".config"
    if not parsed_args.dry_run:
        output_config_dir.mkdir(parents=False, exist_ok=True)

    # Copy config to config directory
    if parsed_args.dry_run:
        logger.info(f"Dry run - Copying config directory '{dot_files_config_dir}' to '{output_config_dir}'")
    else:
        logger.debug(f"Copying config directory '{dot_files_config_dir}' to '{output_config_dir}'")
        shutil.copytree(dot_files_config_dir, output_config_dir, dirs_exist_ok=True)
        logger.info(f"Copied config directory to '{output_config_dir}'")

    # ------- Overlay files -------
    logger.info(f"Building configuration overlays for host '{parsed_args.host}'")

    overlay_name = "sway"

    # Get sway overlay file
    sway_overlay_file = get_overlay_file(parsed_args.host, dot_files_overlays_dir / overlay_name, logger)

    if sway_overlay_file is None:
        logger.warning(f"Warning: Overlay file for '{overlay_name}' do not exist for host '{parsed_args.host}'")

    else:
        # Copy sway overlay file to dest and add "includes"
        output_sway_config_dir = output_dir / ".config" / "sway"
        if parsed_args.dry_run:
            logger.info(f"Dry run - Copying sway overlay file '{sway_overlay_file}' to '{output_sway_config_dir}'")
            logger.info(f"Dry run - Include sway overlay file ('{sway_overlay_file.name}') in sway config ('{output_sway_config_dir}')")
        else:
            logger.debug(f"Copying sway overlay file '{sway_overlay_file}' to '{output_sway_config_dir}'")
            shutil.copy2(sway_overlay_file, output_sway_config_dir)
            logger.info(f"Copied sway overlay file to '{output_sway_config_dir}'")
            # Include overlay file in sway config
            with open(output_sway_config_dir / "config", "a") as f_open:
                f_open.write(f"include {sway_overlay_file.name}\n")
            logger.info(f"Add 'include' for sway overlay file in sway config")

if __name__ == "__main__":
    main(sys.argv[1:])
