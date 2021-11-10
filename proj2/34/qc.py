import sys
import nltk

nltk.download('stopwords')
nltk.download('punkt')
nltk.download('wordnet')
from nltk import word_tokenize
from nltk.corpus import stopwords
from nltk.stem import WordNetLemmatizer
from nltk.stem import PorterStemmer
from sklearn.metrics import f1_score
# Do the same as manuel for my imports so they configure the work enviromnent through the script
from nltk.test.classify_fixt import setup_module
import pandas as pd
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn import svm
import sklearn.metrics as metrics

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
               word = ps.stem(token.lower())
               filtered_tokens += [lemmatizer.lemmatize(word)]  # stem may lose accuracy
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
def word2vec(sentences, vectorizer):
    # Tokens vectorization according to the tf idfs scores
    vectors = vectorizer.fit_transform(sentences)

    return vectors

def word2vec_Test(sentences,vectorizer):
    # Tokens vectorization according to the tf idfs scores
    vectors = vectorizer.transform(sentences)
 
    return vectors


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
    vectorizer = TfidfVectorizer(max_features = 8000)
    # Word2Vec problem since some sentences might be larger thus the shape is not the same for all
    train = word2vec(dict_category_sentence_train[0], vectorizer)
    test = word2vec_Test(dict_category_sentence_test[0], vectorizer)

    # Classifier - Algorithm - SVM
    # fit the training dataset on the classifier
    SVM = svm.SVC(kernel='rbf')
    SVM.fit(train,dict_category_sentence_train[1])
    # predict the labels on validation dataset
    predictions_SVM = SVM.predict(test)
    
    for prediction in predictions_SVM:
        print(prediction)
    
