function test_A_1_2_5()
    q = [.75 .25];
    A = [0.99 0.01; 0.03 0.97];
    mc = MarkovChain (q, A);
    mu_1 = 0;
    mu_2 = 0;
    V_1 = 1;
    V_2 = 4;
    B(1) = GaussD('Mean', mu_1, 'Variance', V_1);
    B(2) = GaussD('Mean', mu_2, 'Variance', V_2);
    h = HMM (mc, B);
    
    Y = rand(h, 500);
    plot(Y);
    title('500 contiguous samples from \{q, A, \{N(0, 1), N(0, 2)\}\}')
    xlabel('t')
    ylabel('x_t')
end