function test_A_1_2_6(start)
    Q = [0.7 0.1; 0.1 0.2];
    R = ones(2, 1) - sum(Q, 2);
    A = [Q R];
    q = [0, 0]';
    q(start) = 1;
    mc = MarkovChain(q, A);
    
    ITER = 1000;
    
    res = zeros(1, ITER);
    for i = 1:ITER
        S = rand(mc, 50);
        res(i) = length(S);
    end
%     plot(1:numel(res), sort(res));
    hist(res, 50);
    
    disp(num2str(mean(res)));
    
end