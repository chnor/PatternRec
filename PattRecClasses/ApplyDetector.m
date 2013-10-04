function score = ApplyDetector(Cparams, HMM, feature)
    
    alpha = Cparams.alphas;
    j = Cparams.Thetas(:, 1);
    theta = Cparams.Thetas(:, 2);
    p = Cparams.Thetas(:, 3);
    
    f = -cellfun(@(h) logprob(h, feature), HMM(j))';
    
    score = sum(alpha .* (p .* f < p .* theta));
end