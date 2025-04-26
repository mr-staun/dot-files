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
    if numeric_level == 10:
        formatter = logging.Formatter('%(asctime)s [%(filename)s:%(funcName)s] - %(levelname)s: %(message)s')
    else:
        formatter = logging.Formatter('%(message)s')
    handler.setFormatter(formatter)
    logger.addHandler(handler)

    return logger

def parse_arguments(args):

    parser = argparse.ArgumentParser(prog="build-config", description="CLI tool that builds and copies dot-files to the right locations")

    parser.add_argument("-o", "--output-dir", type=str, required=False, dest="output_dir", metavar="OUTPUT_DIR", help="Specify a directory to scan for images.")

    parser.add_argument("--host", type=str, required=False, help="Build configuration using an overlay for a specific host.")


    parser.add_argument("--dry-run", action="store_true", default=False, help="Flag to specify a dry-run. No changes are written, only shows changes to be made.")

    default_log_level = "DEBUG"
    parser.add_argument("--log-level", dest="log_level", type=str, required=False, default=default_log_level,
                        help=f"Set the log level. Default level is '{default_log_level}'")

    return parser.parse_args(args)


def main(args):
    parsed_args = parse_arguments(args)
    logger = create_logger(parsed_args.log_level)

    output_dir = Path(parsed_args.output_dir)
    logger.debug(f"Output directory was set to {str(output_dir)}")

    # Validate output directory
    if not output_dir.is_dir():
        logger.error(f"Output directory '{output_dir} is not valid!")
        sys.exit(1)
    
    if not output_dir.exists():
        logger.error(f"Output directory '{output_dir} does not exist!")
        sys.exit(1)

    # Get the scipt and root directory
    script_dir = Path(__file__).resolve().parent
    logger.debug(f"Script directory is {script_dir}")
    root_dir = script_dir.parent
    logger.debug(f"Root directory of dot-files is {root_dir}")

    # Get necessary dirs to copy and build config
    config_dir = root_dir / "config"
    logger.debug(f"Config directory is {config_dir}")
    overlays_dir = config_dir / "overlays"
    logger.debug(f"Overlays directory is {overlays_dir}")
    home_config_dir = root_dir / "home"
    logger.debug(f"Home config directory is {home_config_dir}")

    logger.info("Copying home dot files")

    # Copy dot files to Home/Destination directory
    for dot_file in home_config_dir.rglob("*"):
        if dot_file.is_file():
            dest_path = output_dir / ("." + dot_file.name)
            if parsed_args.dry_run:
                logger.info(f"Dry run of copying dot file '{dot_file}' to '{dest_path}'")
            else:
                logger.debug(f"Copying dot file '{dot_file}' to '{dest_path}'")
                shutil.copy(str(dot_file), str(dest_path))


if __name__ == "__main__":
    main(sys.argv[1:])
