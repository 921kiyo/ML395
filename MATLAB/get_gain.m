function [ gain ] = get_gain(p_1,n_1,p_0,n_0)
% Function to comput information gain
    N_0 = p_0 + n_0;
    N_1 = p_1 + n_1;
    total = N_0 + N_1;
    I = get_I(N_0,N_1);
    rem = (N_0/total) * get_I(p_0,n_0) + (N_1/total)*get_I(p_1,n_1);
    gain = I-rem;
end

function [ I ] = get_I( p,n )
% Helper function to compute all possible values for attribute:
% Remainder(attribute)
    N = p+n;
    A = 0;
    B=0;
    if p>0; A = (p/N)*log2(p/N); end
    if n>0; B = (n/N)*log2(n/N); end
    I = -1*(A+B);
end


