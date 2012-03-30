#
# Broken pipe problem is fixed in Python 3.
#
from subprocess import Popen, PIPE
p1 = Popen(["cat", "fred.db"], stdout=PIPE)
p2 = Popen(["head", "-c10"], stdin=p1.stdout, stdout=PIPE)
output = p2.communicate()[0]
