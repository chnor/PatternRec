function result = userInput(trainingSet)

HMMs = trainingSet.HMMs;
classes = trainingSet.classes;
A = [HMMs{1,:}];

character = DrawCharacter();
character = ExtractFeatures(character);
proba = logprob(A, character(1:6,:));
[value index] = max(proba);

disp(['Written letter: ', classes(index)]);


end

