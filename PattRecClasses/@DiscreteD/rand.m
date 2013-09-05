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

res = bsxfun(@gt, cumsum(double(pD)), rand(nData, 1));
% Find first in each row
[R, ~] = find(res' == 1 & cumsum(res, 2)' == 1);

%R = zeros(nData, 1);
% We can of course use parfor here since the loop has
% perfect parallelism but this is probably not a major
% bottleneck...
%for i = 1:nData
%    R(i) = find(rand() <= cumsum(double(pD)), 1, 'first');
%end
