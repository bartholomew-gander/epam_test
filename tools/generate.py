#!/usr/bin/env python3
from common import *
import argparse

parser = argparse.ArgumentParser(
    prog="generate.py",
    description="Generate a .tfvars file with all variables and their default values"
)
parser.add_argument("root", help="Root directory to search for .tf files")
parser.add_argument("-v", "--verbose",
                    action="store_true",
                    help="Print verbose output to stderr")
parser.add_argument("-o", "--output",
                    nargs="?",
                    help="Output file to write the .tfvars content to (default: stdout)")

if __name__ == "__main__":
    args = parser.parse_args()
    set_verbose(args.verbose)
    vars = get_variables(sys.argv[1])
    output = ""
    for f in vars.keys():
        default = vars[f]['default'] if 'default' in vars[f] else ""
        output += f"{f}={default}\n"
    if args.output:
        with open(args.output, 'w') as f:
            f.write(output)
    else:
        print(output)
    