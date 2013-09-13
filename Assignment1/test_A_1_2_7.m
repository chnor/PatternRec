function test_A_1_2_7()
    
    A = [0.99 0.01; 0.03 0.97];
    q = [0.75 0.25]';
    
    mc = MarkovChain(q, A);
    
    mu_1 = [-1 0]';
    mu_2 = [2 1]';
    C_1 = [0.3 0.5; 0.5, 1];
    C_2 = [1 -1; -1, 0.5];
    g1 = GaussD('Mean', mu_1, 'Covariance', C_1);
    g2 = GaussD('Mean', mu_2, 'Covariance', C_2);
    
    h = HMM(mc, [g1, g2]);
    
    [X, S] = rand(h, 500);
    c_1 = X(:, S == 1);
    c_2 = X(:, S == 2);
    
    plot(c_1(1, :), c_1(2, :), 'r+', c_2(1, :), c_2(2, :), 'b.');
    hold on;
    
    % Take principal components of covariances
    [e_1, lambda_1] = eig(C_1);
    [e_2, lambda_2] = eig(C_2);
    % Make PCs proportional to their corresponding
    % standard deviations
    e_1 = normc(e_1);
    e_2 = normc(e_2);
    pc_1_1 = mu_1 + lambda_1(1, 1)*e_1(:, 1);
    pc_1_2 = mu_1 + lambda_1(2, 2)*e_1(:, 2);
    pc_2_1 = mu_2 + lambda_2(1, 1)*e_2(:, 1);
    pc_2_2 = mu_2 + lambda_2(2, 2)*e_2(:, 2);
    % Plot the PCs
    plot([mu_1(1) pc_1_1(1)], [mu_1(2) pc_1_1(2)], '.-k');
    plot([mu_1(1) pc_1_2(1)], [mu_1(2) pc_1_2(2)], '.-k');
    plot([mu_2(1) pc_2_1(1)], [mu_2(2) pc_2_1(2)], '.-k');
    plot([mu_2(1) pc_2_2(1)], [mu_2(2) pc_2_2(2)], '.-k');
    
    axis equal;
    title('Multivariate HMM output');
    xlabel('x_1');
    ylabel('x_2');
    
    hold off
    
end