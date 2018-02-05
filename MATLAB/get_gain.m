function [ gain ] = get_gain(p_1,n_1,p_0,n_0)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
    N_0 = p_0 + n_0;
    N_1 = p_1 + n_1;
    total = N_0 + N_1;
    I = get_I(N_0,N_1);
    rem = (N_0/total) * get_I(p_0,n_0) + (N_1/total)*get_I(p_1,n_1);
    gain = I-rem;
end

