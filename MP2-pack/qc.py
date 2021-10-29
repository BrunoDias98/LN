import sys
import nltk
# args form python qc.py –test NAMEOFTESTFILE –train NAMEOFTHETRAINFILE > results.txt
# reads file to string
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

if __name__ == "__main__":
    # atencao as barras diferentes -(minha) != –(stor)
    # print('–' == '-')
    args = sys.argv
    if len(args) != 5 or args[1] != "–test" or args [3] != "–train":
        raise Exception
    test_file = args[2]
    train_file = args[4]
    train_file_string = read_file_to_string(train_file)
    dict_category_sentence = split_file_by_category_sentence(train_file_string)
    print(read_file_to_string(test_file))


















