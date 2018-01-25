import numpy as np

import scipy.io as sio

mat = sio.loadmat('Data/cleandata_students.mat')

print(mat)

mat_y = mat['y']
print(mat_y)

print(mat_y.shape)

# vector = np.arrange(10)
# vector.shape(10,)

print(sio.whosmat('Data/cleandata_students.mat'))
