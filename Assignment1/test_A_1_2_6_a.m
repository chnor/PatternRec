function avg = test_A_1_2_6_a(start)
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
    hist(res, unique(res));
    
    title('Occurences of each length for finite Markov chain');
    % Matlab 'helpfully' also plots the bin centers as '*'...
    % XXX Remove these manually (kludgy!)
    delete(findall(gcf, 'marker', '*'));
    xlabel('length(S)');
    ylabel('number of occurences');
    
    avg = mean(res);
    
end