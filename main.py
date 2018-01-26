from __future__ import division
import numpy as np

from scipy import stats
import scipy.io as sio

mat = sio.loadmat('Data/cleandata_students.mat')

mat_x = mat['x']
mat_y = mat['y']

counter = 1

attributes2 = np.arange(1,46)

for i in range(0,45):
    attributes2[i] = counter
    counter = counter + 1


def transform_emotion(vector, emotion):
    for v in range(len(vector)):
        if vector[v] != emotion:
            vector[v] = 0
        else:
            vector[v] = 1
    return vector

transform_emotion(mat_y, 5)

class Tree:
    def __init__(self, mat_x, mat_y, attributes):
        self.op = []
        self.kids = []
        self.leaf = []
        self.attr = attributes

        self.decision_tree_learning(mat_x, attributes, mat_y)

    def decision_tree_learning(self, examples, attributes, binary_target):
        if(self.is_same_binary(binary_target)):
            print("is same binary")
            self.leaf = binary_target[0]
            return 0

        elif(attributes.size == 0):
            self.leaf =  majority_value(binary_target)
            return 0


        self.op = self.choose_best_decision_attribute(examples, attributes, binary_target)

        # for i in range(0,1):
        examples_trim_0 = np.empty((0, 45), int)
        binary_target_trim_0 =  np.empty((0, 1), int)
        examples_trim_1 =  np.empty((0, 45), int)
        binary_target_trim_1 = np.empty((0, 1), int)

        examples_trim_1, binary_target_trim_1 = self.split_data(examples, binary_target, 1)
        examples_trim_0, binary_target_trim_0 = self.split_data(examples, binary_target, 0)
        if (examples_trim_1.shape[0] == 0) or (examples_trim_0.shape[0] == 0) :
            print("kjfdsaj;fja;")
            self.leaf = stats.mode(binary_target)
        else:
            new_attributes = self.update_attribute(attributes)
            self.kids.append(Tree(examples_trim_0, binary_target_trim_0, new_attributes))
            self.kids.append(Tree(examples_trim_1, binary_target_trim_1, new_attributes))
        return 0

    def update_attribute(self, attributes):
        for idx, val in enumerate(attributes2):
            if val == self.op:
                return np.delete(attributes, idx)

    # def split_data(self, examples, binary_target, binary, examples_trim, binary_target_trim):
    def split_data(self, examples, binary_target, binary):
        binary_target_trim =  np.empty((0, 1), int)
        examples_trim =  np.empty((0, 45), int)
        i = 0
        counter = 0
        for row in examples:
            if examples[i][self.op] == binary:
                examples_trim = np.append(examples_trim, np.array([row]), axis=0)
                binary_target_trim = np.append(binary_target_trim, [binary_target[i]], axis=0)
                #examples_trim.append(row)
                #binary_target_trim.append(binary_target[i])
                counter += 1
                # binary_target_trim.append(binary_target[i])
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

    def majority_value(self, binary_target):
        return stats.mode(binary_target)

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
        # for idx in range(len(attributes)):
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

        i=0
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

        after_entropy = 0
        if  (c_p_0_p + c_p_0_n) != 0 and (c_n_0_p + c_n_0_n) != 0:
            i1 = - (c_p_0_p /(c_p_0_p + c_p_0_n))*np.log2(c_p_0_p/(c_p_0_p + c_p_0_n)) - (c_p_0_n /(c_p_0_p + c_p_0_n))*np.log2(c_p_0_n/(c_p_0_p + c_p_0_n))
            i0 = - (c_n_0_p /(c_n_0_p + c_n_0_n))*np.log2(c_n_0_p/(c_n_0_p + c_n_0_n)) - (c_n_0_n /(c_n_0_p + c_n_0_n))*np.log2(c_n_0_n/(c_n_0_p + c_n_0_n))
            after_entropy = ((c_n)/len(binary_target))*i0 +  ((c_p)/len(binary_target))* i1

        info_gain = initial_entropy - after_entropy
        return info_gain

a  = Tree(mat_x, mat_y, attributes2)
