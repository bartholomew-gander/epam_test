import hcl2
import os
import sys

verbose = False

def set_verbose(value):
    global verbose
    verbose = value

def eprint(*args, **kwargs):
    global verbose
    if verbose:
        print("verbose:", *args, file=sys.stderr, **kwargs)

def iterate_tf_files(root):
    for path, subdirs, files in os.walk(root):
        for name in files:
            if name.endswith(".tf"):
                yield os.path.join(path, name)
def parse_tf_file(file):
    with open(file, 'r') as handle:
        dict = hcl2.load(handle)
    return dict

def get_variables(root):
    all_variables = {}
    for file in iterate_tf_files(root):
        dict = parse_tf_file(file)
        eprint(f"Parsed {file}:")
        variables = dict["variable"] if "variable" in dict else []
        for var in variables:
            for var_name in var.keys():
                all_variables[var_name] = var[var_name]


    eprint("\nAll variables found:")
    for var_name in all_variables.keys():
        eprint(f"{var_name}: {all_variables[var_name]}")
    
    return all_variables
