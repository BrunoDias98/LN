import sys
# args form python qc.py –test NAMEOFTESTFILE –train NAMEOFTHETRAINFILE > results.txt
if __name__ == "__main__":
    # atencao as barras diferentes -(minha) != –(stor)
    print('–' == '-')
    args = sys.argv
    if (len(args) != 5):
        raise Exception
    if args[1] != "–test":
        raise Exception
    test_file = args[2]
    if args [3] != "–train":
        print("–train")
       # raise Exception
    train_file = args[4]









#  reads file to string
def read_file_to_string(name):
    x = open(name, "r")
    file_text = x.read()
    return file_text

# splits file in string in dict {category - sentence }
def split_file_by_category_sentence(file_text):
    file_by_lines = file_text.splitlines()
    dict_cat_phrase = dict()
    for line in file_by_lines:
        sentence = line.split()
        category = sentence[0]
        text = ' '.join(sentence[1:])
        try:
            dict_cat_phrase[category].append(text)
        except KeyError:
            lista = list()
            lista.append(text)
            dict_cat_phrase[category] = lista
    return dict_cat_phrase








