function userInput(Classifier)

    HMMs        = Classifier.HMMs;
    classes     = Classifier.classes;
    features    = Classifier.features;
    
    character = DrawCharacter();
    character = ExtractFeatures(character);
    proba = logprob([HMMs{1,:}], character(features,:));
    [~, index] = max(proba);

    disp(['Written letter: ', classes(index)]);

end

