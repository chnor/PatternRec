function Result = test_A_1_2_3()
    q = [.75 .25];
    A = [0.99 0.01; 0.03 0.97];
    mc = MarkovChain (q, A);
    mu_1 = 0;
    mu_2 = 3;
    V_1 = 1;
    V_2 = 4;
    gD(1) = GaussD('Mean', mu_1, 'Variance', V_1);
    gD(2) = GaussD('Mean', mu_2, 'Variance', V_2);
    h = HMM (mc, gD);
    T = rand(h, 10000);
    Result = [mean(T); var(T)];
end