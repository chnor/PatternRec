% Test that the backward function yields the correct value for
% for the example in A.3.2
%--------------------------------------------------------
%Code Authors:
% Pierre Laurent
% Christopher Norman
%--------------------------------------------------------

function [betaHat_modified betaHat_original] = TestBackward1()
    
    X = [-.2 2.6 1.3];
    
    q = [1 0];
    A = [.9 .1 0;0 .9 .1];
    mc = MarkovChain(q, A);
    
    Gauss1 = GaussD('Mean', 0, 'StDev', 1);
    Gauss2 = GaussD('Mean', 3, 'StDev', 2);
    Gauss = [Gauss1; Gauss2];
    
    pX = prob(Gauss, X);
    % We can calculate c via forward but then we would check
    % the correctness of forward as well. Make tests as separate
    % as possible.
    c = [1, 0.1625, 0.8266, 0.0581];
    betaHat_original = backward_original(mc, pX, c);
    betaHat_modified = backward(mc, pX, c);
    
end

