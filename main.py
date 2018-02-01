from __future__ import division
import numpy as np
from scipy import stats
import scipy.io as sio


clean_mat = sio.loadmat('Data/cleandata_students.mat')
clean_mat_x = clean_mat['x']
clean_mat_y = clean_mat['y']

dirty_mat = sio.loadmat('Data/noisydata_students.mat')
dirty_mat_x = dirty_mat['x']
dirty_mat_y = dirty_mat['y']

counter = 1
folds = 10

attributes2 = np.arange(1,46)

for i in range(0,45):
    attributes2[i] = counter
    counter = counter + 1


def transform_emotion(vector, emotion):
    transform_vector = np.empty(shape=vector.shape, dtype=int)
    for v in range(len(vector)):
        if vector[v] != emotion:
            transform_vector[v] = 0
        else:
            transform_vector[v] = 1
    return transform_vector

class Tree:
    def __init__(self, mat_x, mat_y, attributes):
        self.op = []
        self.kids = []
        self.leaf = []
        self.attr = attributes
        self.decision_tree_learning(mat_x, attributes, mat_y)

    def majority_value(self, binary_target):
        return stats.mode(binary_target)[0][0]

    def decision_tree_learning(self, examples, attributes, binary_target):
        if(examples.shape[0] == 0):
            self.leaf = self.majority_value(binary_target)
            # print("1: ", self.leaf)
            return 0

        if(self.is_same_binary(binary_target)):
            self.leaf = binary_target[0]
            # print("2: ", self.leaf)
            return 0

        elif(attributes is None):
            self.leaf = self.majority_value(binary_target)
            # print("3: ", self.leaf)
            return 0


        self.op = self.choose_best_decision_attribute(examples, attributes, binary_target)

        examples_trim_1, binary_target_trim_1 = self.split_data(examples, binary_target, 1)
        examples_trim_0, binary_target_trim_0 = self.split_data(examples, binary_target, 0)

        new_attributes = self.update_attribute(attributes)

        if (examples_trim_0.shape[0] == 0):
            # print("0_no examples left")
            self.kids.append(Tree(examples_trim_0, binary_target, attributes))
        else:
            self.kids.append(Tree(examples_trim_0, binary_target_trim_0, new_attributes))


        if (examples_trim_1.shape[0] == 0):
            # print("1_no examples left")
            self.kids.append(Tree(examples_trim_1, binary_target, attributes))

        else:
            self.kids.append(Tree(examples_trim_1, binary_target_trim_1, new_attributes))

        return 0

    def update_attribute(self, attributes):
        for idx, val in enumerate(attributes):
            if val == self.op:
                return np.delete(attributes, idx)


    def split_data(self, examples, binary_target, binary):
        binary_target_trim = np.empty((0, 1), int)
        examples_trim = np.empty((0, 45), int)
        i = 0
        counter = 0
        for row in examples:
            if examples[i][self.op-1] == binary:
                examples_trim = np.append(examples_trim, np.array([row]), axis=0)
                binary_target_trim = np.append(binary_target_trim, [binary_target[i]], axis=0)
                counter += 1
            i += 1
        return examples_trim, binary_target_trim


    def is_same_binary(self, binary_target):
         first_value = binary_target[0]
         for i in binary_target:
             if i == first_value:
                 continue
             else:
                 return False
         return True

    def choose_best_decision_attribute(self, examples, attributes, binary_target):
        counter_0 = 0
        counter_1 = 0
        for x in binary_target:
            if x == 0:
                counter_0 += 1
            else:
                counter_1 +=1
        initial_entropy = -(counter_0/len(binary_target))*np.log2(counter_0/len(binary_target))-(counter_1/len(binary_target))*np.log2(counter_1/len(binary_target))

        largest_info_gain = 0
        best_attribute = 0
        for idx, val in enumerate(attributes):
            info_gain = self.get_info_gain(binary_target, examples, initial_entropy, val)
            if(largest_info_gain < info_gain):
                best_attribute = val
                largest_info_gain = info_gain
        return best_attribute

    def get_info_gain(self, binary_target, examples, initial_entropy, column):
        c_p = 0
        c_n = 0
        c_p_0_p = 0
        c_n_0_n = 0
        c_p_0_n = 0
        c_n_0_p = 0

        column2 = examples[:, column-1]

        i = 0
        for r in column2:
            if r == 1:
                c_p += 1
                if binary_target[i] == 1:
                    c_p_0_p += 1
            if r == 0:
                if binary_target[i] == 1:
                    c_n_0_p += 1
            i += 1

        c_n = len(binary_target) - c_p

        c_p_0_n = c_p - c_p_0_p
        c_n_0_n = c_n - c_n_0_p

        # if all the examples either have the attribute or all the examples do not have the attribute, then no entropy gain
        after_entropy = initial_entropy
        if (c_p_0_p + c_p_0_n) != 0 and (c_n_0_p + c_n_0_n) != 0:
            # Entropy is 0 if it contains only positive or only negative examples
            if (c_p_0_p) == 0 or (c_p_0_n == 0):
                i1 = 0
            else:
                i1 = - (c_p_0_p /(c_p_0_p + c_p_0_n))*np.log2(c_p_0_p/(c_p_0_p + c_p_0_n)) - (c_p_0_n /(c_p_0_p + c_p_0_n))*np.log2(c_p_0_n/(c_p_0_p + c_p_0_n))

            # Entropy is 0 if it contains only positive or only negative examples
            if (c_n_0_p == 0) or (c_n_0_n == 0):
                i0 = 0
            else:
                i0 = - (c_n_0_p /(c_n_0_p + c_n_0_n))*np.log2(c_n_0_p/(c_n_0_p + c_n_0_n)) - (c_n_0_n /(c_n_0_p + c_n_0_n))*np.log2(c_n_0_n/(c_n_0_p + c_n_0_n))

            after_entropy = ((c_n)/len(binary_target))*i0 +  ((c_p)/len(binary_target))* i1

        info_gain = initial_entropy - after_entropy
        return info_gain

    def visualise_tree(self, attr_num):
        print(self.op)

# returns a list of predictions
def prediction(tree, examples):
    root = tree
    i=0
    example = np.array(examples)
    predictions = np.empty((0, 1), int)
    for row in examples:
        tree = root
        # while we still have subtrees
        while len(tree.leaf) == 0:
            # if the example is negative for the root attribute the choose the first subtree
            if example.item((i, tree.op -1)) == 0:
                tree = tree.kids[0]
            else:
                tree = tree.kids[1]
        predictions = np.append(predictions, np.array(tree.leaf.item(0)))
        predictions = np.reshape(predictions, (len(predictions),1))
        i += 1
    return predictions

def validate_tree(tree, examples, results):
    count = 0
    root = tree
    i=0
    example = np.array(examples)
    for row in examples:
        tree = root
        while len(tree.leaf) == 0:
            if example.item((i, tree.op -1)) == 0:
                tree = tree.kids[0]
            else:
                tree = tree.kids[1]
        if tree.leaf.item(0) != results.item(i):
            count += 1
        i += 1
    print(count)



trees = np.empty(shape=(folds,6), dtype=object)

# Split all the data into 10 folds
splitted_training_data_tmp = np.array_split(clean_mat_x, folds)
splitted_training_data = np.array(splitted_training_data_tmp)

# Split binary targets into 10 folds
splitted_mat_y_tmp = np.array_split(clean_mat_y, folds)
splitted_mat_y = np.array(splitted_mat_y_tmp)

# creates a matrix of decision trees (one per fold)
for i in range(0, folds):
    print("Fold: ", i)
    for it in range(1, 7):
        # training_9_folds = np.zeros(shape=(0,45))
        # binary_9_folds = np.zeros(shape=(0,1))
        training_9_folds = np.empty((0,45), int)
        binary_9_folds = np.empty((0,1), int)
        # Use 10% of data for testing
        examples_test = splitted_training_data[i]
        binary_test = transform_emotion(splitted_mat_y[i], it)

        # The rest (90%) of the data is for training
        for index in range(len(splitted_training_data)):
            if index != i:
                transform_splitted_clean_mat_y_index = transform_emotion(splitted_mat_y[index], it)
                training_9_folds = np.concatenate((training_9_folds, splitted_training_data[index]))
                binary_9_folds = np.concatenate((binary_9_folds, transform_splitted_clean_mat_y_index))
        # Training
        a = Tree(training_9_folds, binary_9_folds, attributes2)
        # trees is a folds * 6 matrix
        trees[i][it-1] = a

# prints confusion matrix
confusion_matrix = np.empty((6, 6), int)
for fold in range(0, folds):
    #confusion_matrix = np.empty((6, 6), int)
    for it in range(1, 7):
        prediction_results = prediction(trees[fold][it-1], splitted_training_data[fold])
        binary_test = transform_emotion(splitted_mat_y[fold], it)
        iterator = 0
        for example in splitted_mat_y[fold]:
            if prediction_results[iterator] == 1:
                confusion_matrix[example[0]-1][it-1] += 1
            iterator += 1
print(confusion_matrix)
print(np.sum(confusion_matrix))


# create decision trees using clean data set
# test decision trees (against clean data set!)
for it in range(1, 7):
    binary_targets = transform_emotion(clean_mat_y, it)
    a = Tree(clean_mat_x, binary_targets, attributes2)
    binary_targets = transform_emotion(dirty_mat_y, it)
    validate_tree(a, dirty_mat_x, binary_targets)

# for it in range(1, 7):
#     for fold in range(0,folds):
#         binary_test = transform_emotion(splitted_mat_y[fold], it)
#         validate_tree(trees[fold][it-1], splitted_training_data[fold], binary_test)