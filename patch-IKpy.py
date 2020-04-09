import os, sys, argparse
parser = argparse.ArgumentParser()
parser.add_argument("URDF_utils_path",
                    help="path of file URF_utils.py in the (pyenv) environnement")
args = parser.parse_args()

file_path = args.URDF_utils_path

target = "    chain = list(next(it) for it in itertools.cycle(iters))"
patch = \
"""\n    chain = []
    for it in itertools.cycle(iters):
        try:
            item = next(it)
        except:
            break
        chain.append(item)
"""      

if not os.path.exists(file_path):
    print("Error: cannot find file <{}>".format(file_path))
    sys.exit()
else:
    print("patching file <{}> ...".format(os.path.basename(file_path)), end="")

    with open(file_path, 'r') as F:
        code = F.read()

    code = code.replace(target, patch)
    with open(file_path, 'w') as F:
        F.write(code)

print(" done")
