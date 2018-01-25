from __future__ import division
import numpy as np

import scipy.io as sio

mat = sio.loadmat('Data/cleandata_students.mat')


print(mat)

mat_x = mat['x']
print(mat_x)

print(mat_x[1])

mat_y = mat['y']
print(mat_y)


counter = 1
attributes = [None] * 45
for i in range(0,45):
    attributes[i] = counter
    counter = counter + 1

print("Attributes")
print(attributes)

# print(mat_y.shape)
# vector = np.arrange(10)
# vector.shape(10,)
print(sio.whosmat('Data/cleandata_students.mat'))

# In training function

def transform_emotion(vector, emotion):
    for v in range(len(vector)):
        if vector[v] != emotion:
            vector[v] = 0
        else:
            vector[v] = 1
    return vector

transform_emotion(mat_y, 4)
print(mat_y)

class Tree:
    def __init__(self, mat_x, mat_y):
        # self.op = 0
        self.op = self.decision_tree_learning(mat_x, attributes, mat_y)
        self.kids = []
        # 1 or 0
        self.leaf = []

    def decision_tree_learning(self, examples, attributes, binary_target):
        # if(self.is_same_binary(binary_target)):
        #     leaf = binary_target[0]
        #     return leaf
        #
        # elif(np.binary_target([])):
        #     leaf =  majority_value(binary_target)
        #     return leaf

        # else:
        # best_attribute = choose_best_decision_attribute(examples, attributes, binary_target)
        print("attributes length ", len(attributes))

        self.op = self.choose_best_decision_attribute(examples, attributes, binary_target)
        # for i in range(0,1):
        examples_trim_0 = []
        binary_target_trim_0 = []
        examples_trim_1 = []
        binary_target_trim_1 = []
        self.split_data(examples, binary_target, 0, examples_trim_0, binary_target_trim_0)
        self.split_data(examples, binary_target, 1, examples_trim_1, binary_target_trim_1)
        print(len(examples_trim_0))
        print(len(examples_trim_1))
        if len(examples_trim_0) == 0:
            # self.leaf =


        return 0

    def split_data(self, examples, binary_target, binary, examples_trim, binary_target_trim):
        i = 0
        counter = 0
        for row in examples:
            if examples[i][self.op] == binary:
                # foo = examples[:, row]
                examples_trim.append(row)
                binary_target_trim.append(binary_target[i])
                counter += 1
                # binary_target_trim.append(binary_target[i])
            i += 1



    def is_same_binary(self, binary_target):
         first_value = binary_target[0]
         for i in binary_target:
             if binary_target[i] == first_value:
                 continue
             else:
                 return False
         return True

    def majority_value(self, binary_target):
        return sio.stats.mode(binary_target)

    def choose_best_decision_attribute(self, examples, attributes, binary_target):
        counter_0 = 0
        counter_1 = 0
        print("binary target", binary_target)
        for x in binary_target:
            if x == 0:
                counter_0 += 1
            else:
                counter_1 +=1

        print(counter_0)
        print(counter_1)
        print(counter_0/len(binary_target))
        initial_entropy = -(counter_0/len(binary_target))*np.log2(counter_0/len(binary_target))-(counter_1/len(binary_target))*np.log2(counter_1/len(binary_target))
        print(initial_entropy)

        largest_info_gain = 0
        best_attribute = 0
        # TODO fix indx

        for idx in range(len(attributes)):
            info_gain = self.get_info_gain(binary_target, examples, initial_entropy, idx)
            if(largest_info_gain < info_gain):
                best_attribute = idx
                largest_info_gain = info_gain

        return best_attribute

    def get_info_gain(self, binary_target, examples, initial_entropy, column):
        c_p = 0
        c_n = 0
        c_p_0_p = 0
        c_n_0_n = 0
        c_p_0_n = 0
        c_n_0_p = 0

        column = examples[:, column]

        i=0
        for r in column:
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

        # print(c_n) # negative attribute examples
        # print(c_p) # postive attribute examples
        # print(c_p_0_n) # positive attribute, negative  examples
        # print(c_n_0_n) # negative attribute, negative target
        # print(c_p_0_p) # positive attibute, positive target
        # print(c_n_0_p) # negative attribute, positive target

        i1 = - (c_p_0_p /(c_p_0_p + c_p_0_n))*np.log2(c_p_0_p/(c_p_0_p + c_p_0_n)) - (c_p_0_n /(c_p_0_p + c_p_0_n))*np.log2(c_p_0_n/(c_p_0_p + c_p_0_n))
        i0 = - (c_n_0_p /(c_n_0_p + c_n_0_n))*np.log2(c_n_0_p/(c_n_0_p + c_n_0_n)) - (c_n_0_n /(c_n_0_p + c_n_0_n))*np.log2(c_n_0_n/(c_n_0_p + c_n_0_n))

        after_entropy = ((c_n)/len(binary_target))*i0 +  ((c_p)/len(binary_target))* i1

        info_gain = initial_entropy - after_entropy
        return info_gain

a  = Tree(mat_x, mat_y)
# a.choose_best_decision_attribute(mat_x, attributes, mat_y)
