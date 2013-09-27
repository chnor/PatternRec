% Test that the logprob function yields the correct value for
% for the example in A.3.1
% Should return approximately -9.1877
%--------------------------------------------------------
%Code Authors:
% Pierre Laurent
% Christopher Norman
%--------------------------------------------------------

function P = TestLogProb1()

    q = [1 0];
    A = [.9 .1 0; 0 .9 .1];
    mc = MarkovChain(q, A);

    X = [-.2 2.6 1.3];
    Gauss(1) = GaussD('Mean', 0, 'Variance', 1);
    Gauss(2) = GaussD('Mean', 3, 'Variance', 4);

    Hmm = HMM (Gauss, mc);

    P = logprob(Hmm, X);

end

