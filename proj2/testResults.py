def file_to_dict_sentence_category(file):
    dict_sentence_category_results = {}
    for line in file:
        sentence = line.split()
        if len(sentence) > 0 :
            category = sentence[0]
            text = ' '.join(sentence[1:])
            dict_sentence_category_results[text] = category
    return dict_sentence_category_results.copy()

x = open("results.txt", "r")
results_file = x.read().splitlines()
y = open("dev.txt", "r")
dev_file = y.read().splitlines()

dict_results = file_to_dict_sentence_category(results_file)
dict_dev_file = file_to_dict_sentence_category(dev_file)
right = 0
total = len(dict_dev_file.keys())
for key in dict_results.keys():
    if dict_dev_file[key] == dict_results[key]:
        right+=1

accuracy = (right / total) * 100
print(accuracy)




