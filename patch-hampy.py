import os, sys, argparse
parser = argparse.ArgumentParser()
parser.add_argument("detect_path",
                    help="path of the file hampy.detect.py in the (pyenv) environnement")
args = parser.parse_args()

file_path = args.detect_path

target = "from matplotlib.mlab import find"
patch = \
"""#raspoppyfication-python3.7:
from numpy import nonzero, ravel
def find(condition):
   res, = nonzero(ravel(condition))
   return res
"""      

if not os.path.exists(file_path):
    print("Error: cannot find file <{}>".format(file_path))
    sys.exit()
else:
    print("patching file <{}> ...".format(os.path.basename(file_path)), end="")

    with open(file_path, 'r') as F:
        code = F.read()

    code = code.replace(target, patch)
    code = code.replace("_, contours, _ = cv2.findContours(edges.copy(),", "contours, _ = cv2.findContours(edges.copy(),")
    with open(file_path, 'w') as F:
        F.write(code)

print(" done")
