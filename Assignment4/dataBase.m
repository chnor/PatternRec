function dataBase(A)
%Create the special structure for the special Character A.
%You can then have more sample for a given Character using the
%addToDb() function.
%The existing characters are given by the displayDb() function.
N = 0;

savefile = 'database.mat';

if exist(savefile) == 2
    load(savefile);
    N = length(dbMat);
end

a = N + 1;

for i=1:N
    if (dbMat(i).name == A)
        a = i;
    end
    
    
    dbMat(a).length = dbMat(i).length + 1;
    size = dbMat(a).length;
    dbMat(a).CharacterMat(size) = DrawCharacter;
    dbMat(a).ExFeature(size) = ExtractFeatures(dbMat(N+1).CharacterMat);
    
    %     else
    % dbMat(N+1).name = A;
    % dbMat(N+1).length = 1;
    % dbMat(N+1).CharacterMat = DrawCharacter;
    % dbMat(N+1).ExFeature = ExtractFeatures(dbMat(N+1).CharacterMat);
    %     end
    save(savefile, 'dbMat');
