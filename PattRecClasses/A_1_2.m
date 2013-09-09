% This script answers the question A.1.2 using 
% the rand and freq functions.
A = [0.99 0.01; 0.03 0.97];
q = [0.75 0.25]';
mc = MarkovChain(q, A);
R = rand(mc, 10000);
B = freq(R);