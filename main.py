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
    for v in vector:
        if v != emotion:
            v = 0
            # print(v)
        else:
            v = 1
            # print(v)
transform_emotion(mat_y, 4)

class Tree:
    def __init__(self):
        self.op = decision_tree_learning(mat_x, mat_x, mat_y)
        self.kids = []
        # 1 or 0
        self.leaf = []

    def decision_tree_learning(examples, attributes, binary_target):
        if(is_same_binary(binary_target)):
            leaf = binary_target[0]
            return leaf

        elif(np.binary_target([])):
            leaf =  majority_value(binary_target)
            return leaf

        else:
            leaf = choose_best_decision_attribute(examples, attributes, binary_target)
            return leaf

    def is_same_binary(binary_target):
         first_value = binary_target[0]
         for i in binary_target:
             if binary_target[i] == first_value:
                 continue
             else:
                 return False
         return True

    def majority_value(binary_target):
        return sio.stats.mode(binary_target)

    def choose_best_decision_attribute(examples, attributes, binary_target):
        
