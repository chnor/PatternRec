function count = test_A_1_2_2()
    A = [0.99 0.01; 0.03 0.97];
    q = [0.75 0.25]';
    mc = MarkovChain(q, A);
    R = rand(mc, 10000);
    count = zeros (2,1);
    for i = 1:2
        count(i) = sum(R == i) / length(R);
    end
end