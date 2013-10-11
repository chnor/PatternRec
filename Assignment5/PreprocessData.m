% Simple convenience function to transform input data
% (pen traces) into feature sequences.
% Rationale: While such things as which features to use
% shouldn't be hardcoded into ExtractFeatures we must still
% have some way to ensure that all functions that need to
% extract feature sequences do this in the same way. This also
% means that tweaking the settings can be done in one place and
% doesn't need any changes to the core functions.

function features = PreprocessData(data)
    
%     data = Resample(data);
    features = ExtractFeatures(data);
    features = features(1:6, :);
    
end