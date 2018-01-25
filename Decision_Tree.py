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




def return_attribute(x,y,value):
    pos =[]
    neg = []
    for example,label in zip(x,y):
        if label == value:
            pos.append(example)
        else:
            neg.append(example)
    return np.array(pos),np.array(neg)

def return_binary_targets(arr,value):
    for i in range(len(arr)):
        if arr[i] == value:
            arr[i] = 1
        else:
            arr[i] = 0
    return arr

def get_I(pos, neg):
    posneg = pos+neg
    return -(pos/posneg)*math.log((pos/posneg),2) -(neg/posneg)*math.log((neg/posneg),2)

def get_gain(pos,neg,poso,nego):
    gain = get_I(pos+poso,neg+nego)
    total = pos+poso+neg+nego
    rem = ((poso+nego)/total)*get_I(poso,nego) + ((pos+neg)/total)*get_I(pos,neg)
    return gain - rem

def get_best_attribute(examples,attributes,binary_targets):
    attribute_count = []
    for att in attributes:
        poso = 0
        nego = 0
        pos = 0
        neg = 0
        for ex,b in zip(examples[:,att],binary_targets):
            if ex == 1 and b==0:
                neg += 1
            elif ex == 1 and b==1:
                pos += 1
            elif ex == 0 and b == 0:
                nego += 1
            elif ex == 0 and b == 1:
                poso += 1
        gain = get_gain(pos,neg,poso,nego)
        attribute_count.app



def DECISION_TREE_LEARNING(examples,attributes,binary_targets):
    if np.sum(binary_targets) == len(binary_targets):
        return Tree(None,1)
    elif np.sum(binary_targets) == 0:
        return Tree(None,0)
    elif len(attributes) == 0:
        return Tree(None,sistat.mode(binary_targets)[0][0])
    else:
        best_attribute = get_best_attribute(examples,attributes,binary_targets)
tree = DECISION_TREE_LEARNING([],[],[1,1,0,1,1,1,1,1])
print(tree.class_)




pos,neg = return_attribute(x,y,4)

'''
print(x.shape)
print(pos.shape)
print(neg.shape)
print(pos[1,:])'''
