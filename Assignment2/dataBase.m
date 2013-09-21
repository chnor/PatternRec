function dataBase(A)

N = 0;

savefile = 'database.mat';

if exist(savefile) == 2
    load(savefile);
    N = length(dbMat);
end

dbMat(N+1).name = A;
dbMat(N+1).CharacterMat = DrawCharacter;
dbMat(N+1).ExFeature = ExtractFeatures(dbMat(N+1).CharacterMat);

save(savefile, 'dbMat');
