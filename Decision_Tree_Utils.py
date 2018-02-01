import math
import numpy as np
from tree import Tree

def return_binary_targets(attributes, value):
    length = len(attributes)
    arr = np.zeros(length)
    for i in range(length):
        if attributes[i][0] == value:
            arr[i] = 1
        else:
            arr[i] = 0
    return arr

def get_I(p, n):
    N = p + n
    A = (p/N)*math.log(p/N, 2) if p > 0 else 0
    B = (n/N)*math.log(n/N, 2) if n > 0 else 0
    return -1*(A+B)

def get_gain(p_1, n_1, p_0, n_0):
    N_0 = p_0 + n_0
    N_1 = p_1 + n_1
    total = N_0 + N_1
    gain = get_I(N_0, N_1)
    rem = (N_0/total)*get_I(p_0, n_0) + (N_1/total)*get_I(p_1, n_1)
    return gain - rem

def get_best_attribute(examples, attributes, binary_targets):
    (max_gain, best_attrib) = (0, 0)

    for att in attributes:
        (p_1, n_1, p_0, n_0) = (0,0,0,0)

        for ex,b in zip(examples[:,att],binary_targets):
            if ex == 1 and b == 0:
                n_1 += 1
            elif ex == 1 and b == 1:
                p_1 += 1
            elif ex == 0 and b == 0:
                n_0 += 1
            elif ex == 0 and b == 1:
                p_0 += 1

        gain = get_gain(p_1, n_1, p_0, n_0)
        if gain > max_gain:
            max_gain = gain
            best_attrib = att

    return best_attrib


def DECISION_TREE_LEARNING(examples, attributes, binary_targets):
    # If all examples have the same value of binary targets
    if len(np.unique(binary_targets)) == 1:
        # Return a leaf node with this value
        return Tree(value = None, class_ = binary_targets[0])

    # If 'attributes' is empty
    if len(attributes) == 0:
        # Return a leaf not with the majority value
        majority_value = sistat.mode(binary_targets)[0][0]
        return Tree(value = None, class_ = majority_value)

    # Otherwise choose the best attribute to branch on
    best_attribute = get_best_attribute(examples, attributes, binary_targets)
    # Make a new tree with the best attribute as the root
    tree = Tree(value = best_attribute, class_ = None)

    # Add a branch for each of the two cases
    for attribute_value in (0,1):
        # Select the subset of values consistent with the attribute value
        consistent_examples = examples[examples[:, best_attribute] == attribute_value]
        consistent_targets = binary_targets[examples[:, best_attribute] == attribute_value]
        remaining_attributes = attributes[attributes != best_attribute]

        if len(consistent_examples) == 0:
            majority_value = sistat.mode(binary_targets)[0][0]
            branch = Tree(value = None, class_= majority_value)

        else:
            branch = DECISION_TREE_LEARNING(consistent_examples, remaining_attributes, consistent_targets)

        tree.kids.append(branch)

    return tree


# Give the expected binary labels for a vector of examples
def predict_example(example, tree):
    # Base where it is a leaf node
    if tree.class_ != None:
        return tree.class_
    # Get the deciding attribute
    case = example[tree.op]
    subtree = tree.kids[case]

    # Recurse
    return predict_example(example, subtree)

# Apply prediction to all in a vector examples
def predict_set(examples, tree):
    length = len(examples)
    predictions = np.zeros(length)
    for i in range(length):
        predictions[i] = predict_example(examples[i], tree)

    return predictions

def accuracy(predictions, binary_targets):
    (t_p, f_p) = (0,0)
    for p, b in zip(predictions, binary_targets):
        if p == 1 and b == 1: t_p+=1
        if p == 1 and b == 0: f_p+=1

    p = sum(binary_targets)
    recall = t_p / p
    precision = t_p / (t_p + f_p)
    accuracy = sum(predictions == binary_targets)/len(predictions)
    f_1 =  2*(recall * precision) / (precision + recall)

    results = {'Accuracy' : accuracy,
               'Recall' : recall,
               'Precision' : precision,
               'F_1' : f_1}
    return results

# Returns a set of trees for each unique label
def tree_set(examples, attributes, labels):
    classes = np.unique(labels)
    trees = []
    for c in classes:
        t = DECISION_TREE_LEARNING(examples, attributes, return_binary_targets(labels, c))
        trees.append(t)

    return trees