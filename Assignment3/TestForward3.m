% Test that the forward function yields the correct value for
% for the infinite duration HMM in problem 5.1
%--------------------------------------------------------
%Code Authors:
% Pierre Laurent
% Christopher Norman
%--------------------------------------------------------

function [alphaHat, c] = TestForward3()

    z = [1, 2, 4, 4, 1];

    q = [1 0 0];
    A = [0.3    0.7     0;
         0      0.5     0.5;
         0      0       1];
    mc = MarkovChain(q, A);

    b1 = DiscreteD([1   0   0   0]);
    b2 = DiscreteD([0   0.5 0.4 0.1]);
    b3 = DiscreteD([0.1 0.1 0.2 0.6]);

    pX = prob([b1, b2, b3], z);

    [alphaHat, c] = forward(mc, pX);

end
