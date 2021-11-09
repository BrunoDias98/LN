import sys
import nltk

nltk.download('stopwords')
nltk.download('punkt')
nltk.download('wordnet')
# args form python qc.py –test dev.txt –train trainWithoutDev.txt > results.txt
# reads file to string
from nltk import word_tokenize
from nltk.corpus import stopwords
from nltk.stem import WordNetLemmatizer
from nltk.stem import PorterStemmer
from sklearn.metrics import f1_score
from sklearn.metrics import accuracy_score
# Do the same as manuel for my imports so they configure the work enviromnent through the script
from nltk.test.classify_fixt import setup_module
import pandas as pd
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.naive_bayes import MultinomialNB


# Removes stop words https://www.kaggle.com/lakshmi25npathi/sentiment-analysis-of-imdb-movie-reviews
# Removes punctuation https://www.kite.com/python/answers/how-to-remove-all-punctuation-marks-with-nltk-in-python  token.isalnum() 
# Lower cases the text  .lower()
# compounds handler TODO if necessary
# normalizes TODO if necessary
# stemming and lemmatization TODO 
# Report The problem with this method is that it doesn’t capture the meaning of the text, or the context in which words appear.


def preprocessing(file_name):
    f = open(file_name, "r")
    file_lines = f.read().splitlines()
    # dict_cat_phrase = []
    list_sentence_tokenized = []
    stop_words = set(stopwords.words('english'))
    lemmatizer = WordNetLemmatizer()
    ps = PorterStemmer()
    category_sentence = []
    for line in file_lines:
        sentence = line.split()
        category = sentence[0]
        text = ' '.join(sentence[1:])
        tokens = nltk.word_tokenize(text)
        filtered_tokens = []
        for token in tokens:
            if token.lower() not in stop_words and token.isalnum():
                word = lemmatizer.lemmatize(token.lower())
                filtered_tokens += [ps.stem(word)]  # stem may lose accuracy
        sentence = ""
        for word in filtered_tokens:
            sentence += word + " "
        sentence = sentence[:-1]
        list_sentence_tokenized += [sentence]
        category_sentence += [category]

    f.close()
    return list_sentence_tokenized, category_sentence


# Converte o dicionario em lista de tuplos em que o 1º elemento
# +é um dic em que os elementos sao o a lista anterior com a sua frequencia idtf e o 2º elemento é
# 1A Estrategia 
# Contar todas as palavras do dicionario (unique)
# Cada frase é um documento do tf-idf https://medium.com/@paritosh_30025/natural-language-processing-text-data-vectorization-af2520529cf7
# Usar os scores the ITDF  https://towardsdatascience.com/natural-language-processing-feature-engineering-using-tf-idf-e8b9d00e7e76
# train = [ ( dict(unique_word1=tf_idf_score,...), sentence[key] ), () ... ]
def word2vec(sentences):
    # Tokens vectorization according to the tf idfs scores
    # https://towardsdatascience.com/natural-language-processing-feature-engineering-using-tf-idf-e8b9d00e7e76
    vectorizer = TfidfVectorizer(max_features = 8000)  # max_features=8000  tokenizer=false
    vectors = vectorizer.fit_transform(sentences)
    feature_names = vectorizer.get_feature_names_out()
    dense = vectors.todense()
    denselist = dense.tolist()

    return denselist, feature_names.tolist()


if __name__ == "__main__":

    args = sys.argv
    if len(args) != 5 or args[1] != "–test" or args[3] != "–train":
        raise Exception
    test_file = args[2]
    train_file = args[4]

    # Preprocess
    dict_category_sentence_train = preprocessing(train_file)
    dict_category_sentence_test = preprocessing(test_file)
    # print("\n\n  ''''''    Ready to Vectorize  ''''  \n\n")

    # Word2Vec problem since some sentences might be larger thus the shape is not the same for all
    train, f_names     = word2vec(dict_category_sentence_train[0])
    test, f_names_test = word2vec(dict_category_sentence_test[0])
    new_test = []
    # print(len(f_names))
    # print(len(f_names_test))

    for row in test:
        listt = []
        for el in f_names:
            if el in f_names_test:
                listt.append(row[f_names_test.index(el)])
                
            else:
                listt.append(0)
        new_test.append(listt)
    
    clf = MultinomialNB()
    clf.fit(train, dict_category_sentence_train[1])
    y_pred_new_bayes = clf.predict(new_test)
    
    for prediction in y_pred_new_bayes:
        print(prediction)
    

    print("\nAccuracy\n")
    print(accuracy_score(dict_category_sentence_test[1], y_pred_new_bayes))
    print("\nF1 Scores:")
    print(f1_score(dict_category_sentence_test[1], y_pred_new_bayes, average='micro'))
    
    #print(y_pred_new_bayes)
    #print(dict_category_sentence_test)
    # classifierBayes = nltk.classify.NaiveBayesClassifier.train(train)
    # sorted(classifierBayes.labels())
    # # classifierDT = nltk.classify.DecisionTreeClassifier.train(train[:-1], entropy_cutoff=0,support_cutoff=0)
    # # sorted(classifierDT.labels())
    # print("\n\n  ''' Ready to Test '''\n\n")
    # print("\n\n  ''' TestResultsBayes  '''\n\n")

    # Classify
    # y_pred_bayes = classifierBayes.classify_many([t[0] for t in test])
    # y_true = [t[1] for t in test]
    # print(y_pred_bayes)
    # print(y_true)
    # print("\n\n  ''' TestResultsDT    '''\n\n")
    # y_pred_dt = classifierDT.classify_many([t[0] for t in test])

    # f1_score(y_true, y_pred_dt, average='micro')

    # print(f1_score(y_true, y_pred_dt, average='micro'))
    # print(y_pred_dt)
    # print(y_true)

    # Accuracy

    # print(f1_score(y_true, y_pred_bayes, average='micro'))





















