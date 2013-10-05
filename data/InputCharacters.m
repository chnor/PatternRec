function [data, chars] = InputCharacters(chars_to_sample, n)

if nargin < 3
    save = 0;
end
if isa(chars_to_sample, 'char')
    chars_to_sample = {chars_to_sample};
end
if size(chars_to_sample, 1) > 1
    chars_to_sample = chars_to_sample';
end

data = cell(1, n*length(chars_to_sample));
chars = reshape(repmat(chars_to_sample, n, 1), [1, length(chars_to_sample)*n]);

for i = 1:length(chars_to_sample)
    char = chars_to_sample{i};
    disp(['Please write ', char, ' in each window']);
    for j = 1:n
        data{(i-1)*n + j} = DrawCharacter;
    end
end

end