import argparse
import logging
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
    formatter = logging.Formatter('%(asctime)s [%(filename)s:%(funcName)s] - %(levelname)s: %(message)s')
    handler.setFormatter(formatter)
    logger.addHandler(handler)

    return logger

def parse_arguments(args):

    parser = argparse.ArgumentParser(prog="build-config", description="CLI tool that builds and copies dot-files to the right locations")

    parser.add_argument("-o", "--output-dir", type=str, required=False, metavar="OUTPUT_DIR", help="Specify a directory to scan for images.")

    parser.add_argument("--host", type=str, required=False, help="Build configuration using an overlay for a specific host.")


    parser.add_argument("--dry-run", action="store_true", default=False, help="Flag to specify a dry-run. No changes are written, only shows changes to be made.")

    default_log_level = "DEBUG"
    parser.add_argument("--log-level", dest="log_level", type=str, required=False, default=default_log_level,
                        help=f"Set the log level. Default level is '{default_log_level}'")

    return parser.parse_args(args)


def main(args):
    parsed_args = parse_arguments(args)
    logger = create_logger(parsed_args.log_level)

if __name__ == "__main__":
    main(sys.argv[1:])
