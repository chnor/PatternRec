% Test that the logprob function can be called with arrays
% containing multiple HMMs and that the logprob function
% gives the same log probability for the example sequence
% in A.3.1 when the two states in the markov chain are
% exchanged with each other (and their output distributions).
% Should yield [9.1877, 9.1877] when called.
%--------------------------------------------------------
%Code Authors:
% Pierre Laurent
% Christopher Norman
%--------------------------------------------------------

function P = TestLogProb2()

    q1 = [1 0];
    A1 = [.9 .1 0; 0 .9 .1];
    mc1 = MarkovChain(q1, A1);
    
    % mc2 is the same as mc1 with states reversed:
    % it should give the same log probability for
    % the sequence X as mc1
    q2 = [0 1];
    A2 = [.9 0 .1; .1 .9 0];
    mc2 = MarkovChain(q2, A2);

    X = [-.2 2.6 1.3];
    g1 = GaussD('Mean', 0, 'Variance', 1);
    g2 = GaussD('Mean', 3, 'Variance', 4);

    h1 = HMM ([g1, g2], mc1);
    h2 = HMM ([g2, g1], mc2);

    P = logprob([h1, h2], X);

end
