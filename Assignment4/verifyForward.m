function result = verifyForward()

%[alphaHat, c]=verifyForward()
%Testing the forward function using the results of our school exercises on
%the book.
%Result:
%We have as a result a vector of 2 boolean.
%If the vector value of a boolean is 1 --> correct result.
%To validate our test, we want result = [1 1]
%
%Thus, we will try to solve the (5.1) exercice on page 121
%
%--------------------------------------------------------
%Code Authors:
% Pierre Laurent
% Christopher Norman
%--------------------------------------------------------

% (5.1)
    q = [1 0 0];
    A = [.3 .7 0; 0 .5 .5; 0 0 1];
    mc = MarkovChain(q,A);
    %The state sequence to test is z = [1 2 4 4 1]
    %We can therefore create the pX Matrix as:
    %pX = [B(1) B(2) B(4) B(4) B(1)]
    pX = [1 0 0 0 1; 0 .5 .1 .1 0; .1 .1 .6 .6 .1];
    [alphaHat, c] = forward (mc, pX);
    
    %The solution are given online
    alphaHatSol = [1 0 0 0 0; 0 1 1/7 1/79 0; 0 0 6/7 78/79 1];
    cSol = [1 .35 .35 0.5643 .0994];
    
    %We need to make an approximation to the 4th decimal (as given in the book)
    sol_c = isequaln(fix(10^4*(c-cSol))*10^-4, zeros(1,5));
    sol_alpha = isequaln(fix(10^4*(alphaHat-alphaHatSol))*10^-4, zeros(3,5));
    result = [sol_alpha sol_c];

end

