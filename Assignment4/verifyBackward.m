function result = verifyBackward()

%Testing the backward function using the results of the book (p.240)
%Result:
%We have as a result betaHat that we need to compare to the results in the
%book.
%
%--------------------------------------------------------
%Code Authors:
% Pierre Laurent
% Christopher Norman
%--------------------------------------------------------

q = [1 0];
A = [.9 .1 0; 0 .9 .1];
mc = MarkovChain(q,A);

B(1) = GaussD ('Mean', 0, 'Variance', 1);
B(2) = GaussD ('Mean', 3, 'Variance', 4);

B = [B(1); B(2)];

X = [-.2, 2.6, 1.3];
c = [1, .1625, .8266, .0581];

pX = prob(B, X);

result = backward (mc, pX, c);

end

