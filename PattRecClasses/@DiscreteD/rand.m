function R=rand(pD,nData)
%R=rand(pD,nData) returns random scalars drawn from given Discrete Distribution.
%
%Input:
%pD=    DiscreteD object
%nData= scalar defining number of wanted random data elements
%
%Result:
%R= row vector with integer random data drawn from the DiscreteD object pD
%   (size(R)= [1, nData]
%
%----------------------------------------------------
%Code Authors:
%----------------------------------------------------

if numel(pD)>1
    error('Method works only for a single DiscreteD object');
end;

% Theory:
% For any distribution D with cumulative probability density
% function cdf(x) we can draw random numbers from the distribution
% by sampling a (pseudo)random number t uniformly from [0, 1]
% and returning cdf_inv(t) [see e.g. Knuth vol 2].
% In the case of discrete distributions this amount to finding
% the first index where the cumulative probability exceeds t.

% Solution 1: loop
R = zeros(nData, 1);
% We can of course use parfor here since the loop has
% perfect parallelism but this is probably not a major
% bottleneck...
d = cumsum(double(pD));
for i = 1:nData
   R(i) = find(rand() <= d, 1, 'first');
end

% Solution 2: The same as the loop except it uses matrix
% operations.
% res = bsxfun(@gt, cumsum(double(pD)), rand(nData, 1));
% % Find first in each row
% [R, ~] = find(res' == 1 & cumsum(res, 2)' == 1);

% Solution 3: builtin
% mass = double(pD);
% R = randsample(1:length(mass), nData, 'true', mass);
