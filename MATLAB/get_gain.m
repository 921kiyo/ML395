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

function [ I ] = get_I( p,n )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
    N = p+n;
    %N=3
    A = 0;
    B=0;
    if p>0; A = (p/N)*log2(p/N); end
    if n>0; B = (n/N)*log2(n/N); end
    I = -1*(A+B);
end


