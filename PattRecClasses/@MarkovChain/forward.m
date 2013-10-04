function [alphaHat, c] = forward(mc, pX)%[alphaHat, c]=forward(mc,pX)%calculates state and observation probabilities for one single data sequence,%using the forward algorithm, for a given single MarkovChain object,%to be used when the MarkovChain is included in a HMM object.%%Input:%mc= single MarkovChain object%pX= matrix with state-conditional likelihood values,%   without considering the Markov depencence between sequence samples.%	pX(j,t)= myScale(t)* P( X(t)= observed x(t) | S(t)= j ); j=1..N; t=1..T%	(must be pre-calculated externally)%NOTE: pX may be arbitrarily scaled, as defined externally,%   i.e., pX may not be a properly normalized probability density or mass.%%NOTE: If the HMM has Finite Duration, it is assumed to have reached the end%after the last data element in the given sequence, i.e. S(T+1)=END=N+1.%%Result:%alphaHat=matrix with normalized state probabilities, given the observations:%	alphaHat(j,t)=P[S(t)=j|x(1)...x(t), HMM]; t=1..T%c=row vector with observation probabilities, given the HMM:%	c(t)=P[x(t) | x(1)...x(t-1),HMM]; t=1..T%	c(1)*c(2)*..c(t)=P[x(1)..x(t)| HMM]%   If the HMM has Finite Duration, the last element includes%   the probability that the HMM ended at exactly the given sequence length, i.e.%   c(T+1)= P( S(T+1)=N+1| x(1)...x(T-1), x(T)  )%Thus, for an infinite-duration HMM:%   length(c)=%   prod(c)=P( x(1)..x(T) )%and, for a finite-duration HMM:%   length(c)=T+1%   prod(c)= P( x(1)..x(T), S(T+1)=END )%%NOTE: IF pX was scaled externally, the values in c are%   correspondingly scaled versions of the true probabilities.%%--------------------------------------------------------%Code Authors:% Pierre Laurent% Christopher Norman%--------------------------------------------------------T=size(pX,2); % Number of observations% Preallocatec           = zeros(1, T);alphaTemp   = zeros(mc.nStates, T);alphaHat    = zeros(mc.nStates, T);if (T == 0)    % Special case: return degenerate matrices of    % size 1 x 0 and n x 0    % We return after preallocating to avoid the matlab error    % messages due to unallocated output    return;end%Init:alphaTemp(:, 1) = pX(:, 1) .* mc.InitialProb; % q_j*b_j(x_1) (5.42)c(1) = mc.InitialProb' * pX(:, 1);            % c(1) = sum(j) q_j*b_j(x_1) (5.43)alphaHat(:, 1) = alphaTemp(:, 1) / c(1);      % alphaHat_j = alphaTemp_j/c(1) (5.44)%Forward Step:n = size(mc.TransitionProb, 1);for i = 2:T    a = alphaHat(:, i-1)' * mc.TransitionProb(:, 1:n);    alphaTemp(:, i) = pX(:,i) .* a';                    % (5.50)    c(i) = sum(alphaTemp(:, i));                        % (5.51)    if isnan(c(i))        c(i) = 0;        return;    end    alphaHat(:, i) = alphaTemp(:, i)/c(i);              % (5.52)end% Termination:if finiteDuration(mc)    c(T+1) = alphaHat(:, T)' * mc.TransitionProb(:, end); % (5.53)endend