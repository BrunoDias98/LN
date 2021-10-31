import sys
import nltk
nltk.download('stopwords')
nltk.download('punkt')

# args form python qc.py –test dev.txt –train trainWithouDev.txt > results.txt
# reads file to string
from nltk import word_tokenize
from nltk.corpus import stopwords


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

#removing the stopwords
def remove_stopwords(text, is_lower_case=False):
    tokens = tokenizer.tokenize(text)
    tokens = [token.strip() for token in tokens]
    if is_lower_case:
        filtered_tokens = [token for token in tokens if token not in stopword_list]
    else:
        filtered_tokens = [token for token in tokens if token.lower() not in stopword_list]
    filtered_text = ' '.join(filtered_tokens)
    return filtered_text

# Bag of words without words that arent stop words in english
def create_bag_of_words_for_each_category(file_text):
    file_by_lines = file_text.splitlines()
    stop_words = set(stopwords.words('english'))
    bag_of_words_category = {}
    for line in file_by_lines:
        tokens = nltk.word_tokenize(line)
        category = tokens[0]
        filtered_tokens = [token for token in tokens[1:] if token.lower() not in stop_words]
        try:
            new_list = bag_of_words_category[category] + filtered_tokens
            bag_of_words_category[category] = new_list
        except KeyError:
            lista = [] + filtered_tokens
            bag_of_words_category[category] = lista
    return bag_of_words_category


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
    print(create_bag_of_words_for_each_category(train_file_string))
    classifier_f = open ("naivebayes.pickle","rb")
    

    #classifier = nltk.classify.NaiveBayesClassifier.train(create_bag_of_words_for_each_category(train_file))
    #print(classifier.classify_many(create_bag_of_words_for_each_category(test_file)))



   # print(read_file_to_string(test_file))


















