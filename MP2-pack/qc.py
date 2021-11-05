import sys
import nltk
nltk.download('stopwords')
nltk.download('punkt')

# args form python qc.py –test dev.txt –train trainWithoutDev.txt > results.txt
# reads file to string
from nltk import word_tokenize
from nltk.corpus import stopwords


import pandas as pd
from sklearn.feature_extraction.text import TfidfVectorizer

# Splits file in string in dict {category - sentence }
# Removes stop words https://www.kaggle.com/lakshmi25npathi/sentiment-analysis-of-imdb-movie-reviews 
# Removes punctuation https://www.kite.com/python/answers/how-to-remove-all-punctuation-marks-with-nltk-in-python  token.isalnum() 
# Lower cases the text  .lower()

# compounds handler TODO if necessary
# normalizes TODO if necessary
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
            lista = [filtered_tokens]
            dict_cat_phrase[category] = lista
    f.close()
    return dict_cat_phrase

#Converte o dicionario em lista de tuplos em que o 1º elemento 
#+é um dic em que os elementos sao o a lista anterior com a sua frequencia idtf e o 2º elemento é 
# 1A Estrategia 
# Contar todas as palavras do dicionario (unique)
# Cada categoria é um "documento" do tf-idf https://medium.com/@paritosh_30025/natural-language-processing-text-data-vectorization-af2520529cf7
# Usar os scores the ITDF  https://towardsdatascience.com/natural-language-processing-feature-engineering-using-tf-idf-e8b9d00e7e76
# train = [ ( dict(unique_word1=tf_idf_score,...), sentence[key] ), () ... ]

def word2vec(sentence):
    vectorizer = TfidfVectorizer()

    print("\n\n")
    print(sentence.keys())

    all_sentences = []
    i = 0
    indexes = dict()
    for key in sentence.keys():
        for elem in sentence[key]:
            all_sentences.append(' '.join(elem))
            i+=1
        indexes[key] = i
    
    #Index for knowing when each category starts
    print("\n\n")
    print(indexes)
    print("\n\n")


    #Tokens vectorization according to the tf idfs scores
    vectors = vectorizer.fit_transform(all_sentences)
    feature_names = vectorizer.get_feature_names_out()
    dense = vectors.todense()
    #BUGS HERE
    print(len(dense))
    ### 3000 sentences works
    denselist = dense[0:3000].tolist()
    # print("\nndone\n")
    df = pd.DataFrame(denselist, columns=feature_names)
    print("\nndone\n")
    # Conversion to file, not needed, just for visualization
    # compression_opts = dict(method='zip',archive_name='out.csv')  
    print("\nndone\n")
    # df.to_csv('out.zip', index=False,compression=compression_opts)  

    #IT-DFs scores
    # vectorizer = TfidfVectorizer()
    # vectors = vectorizer.fit_transform([documentA, documentB])
    # feature_names = vectorizer.get_feature_names()
    # dense = vectors.todense()
    # denselist = dense.tolist()
    # df = pd.DataFrame(denselist, columns=feature_names)
    # print(sentence.values())
    # print(sentence.keys())
    # print(sentence.keys())
    # print(sentence.keys())
    # uniqueWords = set(sentence.values())
    # table = []
    # for label in sentence.keys():
    #     numOfWords = dict.fromkeys(uniqueWords, 0)
    #     for word in sentence[label]:
    #         numOfWords[word] += 1
    #     sentence[label]append[numOfWords]
    # print(sentence["LITERATURE"][0:5])

if __name__ == "__main__":

    args = sys.argv
    if len(args) != 5 or args[1] != "–test" or args [3] != "–train":
        raise Exception
    test_file = args[2]
    train_file = args[4]
    
    #Preprocess
    dict_category_sentence_train = preprocessing(train_file)
    #dict_category_sentence_test  = preprocessing(test_file)
    # print(dict_category_sentence_train["LITERATURE"])
    
    #Word2Vec problem since some sentences might be larger thus the shape is not the same for all
    train_vec = word2vec(dict_category_sentence_train)
    #test  = word2vec(dict_category_sentence_test)
    
    #Train

    #Classify

   
    #print(create_bag_of_words_for_each_category(train_file))
    # classifier_f = open ("naivebayes.pickle","rb")
    #classifier = nltk.classify.NaiveBayesClassifier.train(create_bag_of_words_for_each_category(train_file))
    #print(classifier.classify_many(create_bag_of_words_for_each_category(test_file)))



















