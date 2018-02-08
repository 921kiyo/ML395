% clean_data = load('Data/cleandata_students.mat');
% x_clean = clean_data.x;
% y_clean = clean_data.y;
% pruning_example(x_clean, y_clean);

noisy_data = load('MATLAB/Data/noisydata_students.mat');
x_noisy = noisy_data.x;
y_noisy = noisy_data.y;
pruning_example(x_noisy, y_noisy);