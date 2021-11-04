import sys
import nltk
nltk.download('stopwords')
nltk.download('punkt')

# args form python qc.py –test dev.txt –train trainWithoutDev.txt > results.txt
# reads file to string
from nltk import word_tokenize
from nltk.corpus import stopwords

# #removing the stopwords
# def remove_stopwords(text, is_lower_case=False):
#     tokens = tokenizer.tokenize(text)
#     tokens = [token.strip() for token in tokens]
#     if is_lower_case:
#         filtered_tokens = [token for token in tokens if token not in stopword_list]
#     else:
#         filtered_tokens = [token for token in tokens if token.lower() not in stopword_list]
#     filtered_text = ' '.join(filtered_tokens)
#     return filtered_text

# # Bag of words without words that arent stop words in english
# def create_bag_of_words_for_each_category(file_text):
#     file_by_lines = file_text.splitlines()
#     stop_words = set(stopwords.words('english'))
#     bag_of_words_category = {}
#     for line in file_by_lines:
#         tokens = nltk.word_tokenize(line)
#         category = tokens[0]
#         filtered_tokens = [token for token in tokens[1:] if token.lower() not in stop_words]
#         try:
#             new_list = bag_of_words_category[category] + filtered_tokens
#             bag_of_words_category[category] = new_list
#         except KeyError:
#             lista = [] + filtered_tokens
#             bag_of_words_category[category] = lista
#     return bag_of_words_category



# Splits file in string in dict {category - sentence }
# Removes stop words https://www.kaggle.com/lakshmi25npathi/sentiment-analysis-of-imdb-movie-reviews 
# Removes punctuation https://www.kite.com/python/answers/how-to-remove-all-punctuation-marks-with-nltk-in-python  token.isalnum() 
# Lower cases the text  .lower()

# compounds handler TODO NGRAMS MODULE, maybe do it before tokenization, or after with the join " " command
# normalizes TODO
# stemming and lemmatization TODO

#Report The problem with this method is that it doesn’t capture the meaning of the text, or the context in which words appear, even when using n-grams.

def preprocessing(file_name):

    f = open(file_name, "r")
    file_lines = f.read().splitlines() 
    dict_cat_phrase = dict()
    stop_words = set(stopwords.words('english'))
    for line in file_lines:
        sentence = line.split()
        category = sentence[0]
        text = ' '.join(sentence[1:])
        tokens = nltk.word_tokenize(text)
        filtered_tokens = [token.lower() for token in tokens if token.lower() not in stop_words and token.isalnum()]
        try:
            dict_cat_phrase[category].append(filtered_tokens)
        except KeyError:
            lista = [] + filtered_tokens
            dict_cat_phrase[category] = lista
    f.close()
    return dict_cat_phrase

# def trainingBayes(dataSet, algorithm):


if __name__ == "__main__":

    args = sys.argv
    if len(args) != 5 or args[1] != "–test" or args [3] != "–train":
        raise Exception
    test_file = args[2]
    train_file = args[4]
    dict_category_sentence = preprocessing(train_file)
    print(dict_category_sentence["LITERATURE"])
   
   
    #print(create_bag_of_words_for_each_category(train_file))
    # classifier_f = open ("naivebayes.pickle","rb")
    #classifier = nltk.classify.NaiveBayesClassifier.train(create_bag_of_words_for_each_category(train_file))
    #print(classifier.classify_many(create_bag_of_words_for_each_category(test_file)))



















