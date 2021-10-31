import sys

# atencao as barras diferentes -(minha) != –(stor)
# print('–' == '-')
args = sys.argv
if len(args) != 5 or args[1] != "–test" or args [3] != "–train":
    raise Exception
test_file = args[2]
train_file = args[4]
lines = []
while open(train_file) as file:
    lines = file.readLines()
    lines = [lines.rstrip() for line in lines]


x = open(train_file, "r")
file_text = x.read()


print(lines)