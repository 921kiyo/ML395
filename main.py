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

attributes2 = np.arange(1,46)

for i in range(0,45):
    attributes2[i] = counter
    counter = counter + 1


def transform_emotion(vector, emotion):
    transform_vector = np.empty(shape=vector.shape)
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
            # print(self.leaf)
            # print(len(examples))
            return 0

        if(self.is_same_binary(binary_target)):
            self.leaf = binary_target[0]
            # print(self.leaf)
            # print(len(examples))
            return 0

        elif(attributes is None):
            self.leaf = self.majority_value(binary_target)
            # print(self.leaf)
            # print(len(examples))
            return 0


        self.op = self.choose_best_decision_attribute(examples, attributes, binary_target)
        # print("No. Attributes: ", len(attributes), "Best Attr: ", self.op, "No. Examples: ", len(examples))

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
        # print("Initial Entropy: ", initial_entropy)
        for idx, val in enumerate(attributes):
            info_gain = self.get_info_gain(binary_target, examples, initial_entropy, val)
            # print("Info gain: ", info_gain)
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

        #after_entropy = 0
        after_entropy = initial_entropy
        if (c_p_0_p + c_p_0_n) != 0 and (c_n_0_p + c_n_0_n) != 0:
            if (c_p_0_p) == 0 or (c_p_0_n == 0):
                i1 = 0
            else:
                i1 = - (c_p_0_p /(c_p_0_p + c_p_0_n))*np.log2(c_p_0_p/(c_p_0_p + c_p_0_n)) - (c_p_0_n /(c_p_0_p + c_p_0_n))*np.log2(c_p_0_n/(c_p_0_p + c_p_0_n))

            if (c_n_0_p) == 0 or (c_n_0_n == 0):
                i0 = 0
            else:
                i0 = - (c_n_0_p /(c_n_0_p + c_n_0_n))*np.log2(c_n_0_p/(c_n_0_p + c_n_0_n)) - (c_n_0_n /(c_n_0_p + c_n_0_n))*np.log2(c_n_0_n/(c_n_0_p + c_n_0_n))

            after_entropy = ((c_n)/len(binary_target))*i0 +  ((c_p)/len(binary_target))* i1

        info_gain = initial_entropy - after_entropy
        return info_gain

    def visualise_tree(self, attr_num):
        print(self.op)


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
        # print(i, " LEAF: ", tree.leaf, "Results: ", results.item(i))
        if tree.leaf.item(0) != results.item(i):
            count += 1
            #print(i, " LEAF: ", tree.leaf, "Results: ", results.item(i))
        i += 1
    print(count)


for it in range(1,7):
    transform_clean_mat_y = transform_emotion(clean_mat_y, it)
    transform_dirty_mat_y = transform_emotion(dirty_mat_y, it)

    a  = Tree(clean_mat_x, transform_clean_mat_y, attributes2)

    #validate_tree(a, clean_mat_x, transform_clean_mat_y)
    validate_tree(a, dirty_mat_x, transform_dirty_mat_y)