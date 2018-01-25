import numpy as np
import scipy.io as sio
import scipy.stats as sistat
import os
import math

data = sio.loadmat(os.path.join("Data","cleandata_students.mat"))
y = np.array(data['y'])
x = np.array(data['x'])

class Tree:
    def __init__(self,value,class_):
        self.name = "Tree"
        self.op = value
        self.kids = []
        self.class_ = class_
    def add_children(self,value):
        self.kids.append(value)

def return_binary_targets(arr,value):
    for i in range(len(arr)):
        if arr[i] == value:
            arr[i] = 1
        else:
            arr[i] = 0
    return arr

def get_I(pos_, neg_):
    posneg = pos_+neg_
    if pos_ == 0 and neg_ == 0:
        return 0
    if pos_==0:
        return -(neg_/posneg)*math.log((neg_/posneg),2)
    if neg_==0:
        return -(pos_/posneg)*math.log((pos_/posneg),2)
    return -(pos_/posneg)*math.log((pos_/posneg),2) -(neg_/posneg)*math.log((neg_/posneg),2)

def get_gain(pos,neg,poso,nego):
    gain = get_I(pos+poso,neg+nego)
    total = pos+poso+neg+nego
    rem = ((poso+nego)/total)*get_I(poso,nego) + ((pos+neg)/total)*get_I(pos,neg)
    return gain - rem

def get_best_attribute(examples,attributes,binary_targets):
    attribute_count = []
    print(attributes)
    for att in attributes:
        poso = 0
        nego = 0
        pos = 0
        neg = 0
        #print(len(examples[:,att]))
        #print(binary_targets.shape)
        for ex,b in zip(examples[:,att],binary_targets[:,0]):
            #print(" ex is " + str(ex) + " b is " + str(b))
            if ex == 1 and b==1:
                pos += 1
            elif ex == 1 and b==0:
                neg += 1
            elif ex == 0 and b == 0:
                nego += 1
            elif ex == 0 and b == 1:
                poso += 1
        #print("Attributes :" + str(att) + " pos : " + str(pos) + " neg " + str (neg) + " poso " + str(poso) + " nego " + str(nego))
        gain = get_gain(pos,neg,poso,nego)
        #print(gain)
        attribute_count.append(gain)
    return(attributes[np.argmax(attribute_count)])



def DECISION_TREE_LEARNING(examples,attributes,binary_targets):
    if np.sum(binary_targets) == len(binary_targets):
        return Tree(None,1)
    elif np.sum(binary_targets) == 0:
        return Tree(None,0)
    elif len(attributes) == 0:
        return Tree(None,sistat.mode(binary_targets)[0][0])
    else:
        best_attribute = get_best_attribute(examples,attributes,binary_targets)
        tree = Tree(best_attribute,0)
        for state in range(2):
            examples_new,binary_targets_new = examples[examples[:,best_attribute]==state,:],binary_targets[examples[:,best_attribute]==state]
            if examples_new.shape[0] == 0:
                return Tree(None,sistat.mode(binary_targets)[0][0])
            else:
                print(attributes[np.argwhere(attributes==best_attribute)])
                print(attributes)
                attributes = np.delete(attributes,np.argwhere(attributes==best_attribute))
                print(attributes)
                tree.add_children(DECISION_TREE_LEARNING(examples_new,attributes,binary_targets_new))
        return tree

tree = DECISION_TREE_LEARNING(x,np.arange(x.shape[1]),return_binary_targets(y,2))



'''
tree = DECISION_TREE_LEARNING([],[],[1,1,0,1,1,1,1,1])
print(tree.class_)'''
'''
examples_new = x[x[:,3]==0,:]
print(x)
print(examples_new)
print(np.sum(examples_new[:,3]))'''

'''
# QUESTION 2 CHECKS ***********************************************************************
print(get_gain(2,0,0,3))
print(get_I(4, 1))
examples_test = np.array([[1,0,1],[1,1,1],[0,1,0],[0,0,0],[1,0,0]])
print(examples_test)
print([1,1,0,0,0])
print(get_best_attribute(examples_test,[0,1,2],[1,1,0,0,0]))
'''
