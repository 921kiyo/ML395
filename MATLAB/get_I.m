function [ I ] = get_I( p,n )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
    N = p+n;
    A = 0;
    B=0;
    if p>0; A = (p/N)*log2(p/N); end
    if n>0; B = (n/N)*log2(n/N); end
    I = -1*(A+B);
end

