function dataBase(A)
%Create the special structure for the special Character A.
%You can then have more sample for a given Character using the
%addToDb() function.
%The existing characters are given by the displayDb() function.
%Using this function will allow you to create a N*M struc matrix with in
%column the different special characters and in row, the value of such a
%character.

N = 0;

savefile = 'database.mat';

if exist(savefile) == 2
    load(savefile);
    N = length(dbMat(:,1));

else
    x.length = 1;
    x.name = A;
    x.CharacterMat = DrawCharacter;
    x.ExFeature = PreprocessData(x.CharacterMat);
    dbMat(1) = {x};
    save(savefile, 'dbMat');
    return
    
end

a = N + 1;

for i=1:N
    if (dbMat{i,1}.name == A)
        a = i;
    end
end

    if (a == N+1)
        size = 1;
    else
        size = dbMat{a,1}.length + 1;   
        dbMat{a,1}.length = size;
    end
    x.length = size;
    x.name = A;
    x.num = size;
    x.CharacterMat = DrawCharacter;
    x.ExFeature = PreprocessData(x.CharacterMat);
    dbMat{a, size} = x;
 
    save(savefile, 'dbMat');
 end