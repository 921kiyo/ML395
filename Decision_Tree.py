import numpy as np
import scipy.io as sio
import scipy.stats as sistat
import os

# Decision tree object
from tree import Tree
# Helper functions
from Decision_Tree_Utils import *

# Load data
data = sio.loadmat(os.path.join("Data","cleandata_students.mat"))
(x_full,y_full) = (np.array(data['x']), np.array(data['y']))

p = 600
x = x_full[0:p]
y = y_full[0:p]

x_val, y_val = x_full[p:], y_full[p:]

# Train for expression (1-6)
expression = 3
attributes = np.arange(x.shape[1])
bins = return_binary_targets(y, expression)
tree = DECISION_TREE_LEARNING(x, attributes, bins)

preds = predict_set(x_val, tree)
bins_val = return_binary_targets(y_val, expression)

ts = tree_set(x, attributes, y)

acc = accuracy(preds, bins_val)
print(acc)




