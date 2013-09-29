function dataBase(A)
%Create the special structure for the special Character A.
%You can then have more sample for a given Character using the
%addToDb() function.
%The existing characters are given by the displayDb() function.
N = 0;

savefile = 'database.mat';

if exist(savefile) == 2
    load(savefile);
    N = length(dbMat(:,1));

else
    dbMat(1).length = 1;
    dbMat(1).name = A;
    dbMat(1).CharacterMat = DrawCharacter;
    dbMat(1).ExFeature = ExtractFeatures(dbMat(1).CharacterMat);
    save(savefile, 'dbMat');
    return
    
end

a = N + 1;

for i=1:N
    if (dbMat(i,1).name == A)
        a = i;
    end
end

    if (a == N+1)
        size = 1;
    else size = dbMat(a,1).length + 1;
    end
    dbMat(a,1).length = size;
    dbMat(a, size).name = A;
    dbMat(a, size).num = size;
    dbMat(a, size).CharacterMat = DrawCharacter;
    dbMat(a, size).ExFeature = ExtractFeatures(dbMat(a, size).CharacterMat);
 
    save(savefile, 'dbMat');
