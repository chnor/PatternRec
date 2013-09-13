function test_A_1_2_6_b()
    A = ones(5, 6);
    % Let self transitions be more likely than non-self
    % transitions
    for i = 1:5
        A(i, i) = 5;
    end
    % Let exits be less likely
    A(:, 6) = 0.5;
    % Make stochastic
    A = bsxfun(@rdivide, A, sum(A, 2));
    
    q = rand(1, 5);
    % Make stochastic
    q = q / sum(q);
    mc = MarkovChain(q, A);
    
    S = rand(mc, 50);
    PlotStateJumps(S);
    
end