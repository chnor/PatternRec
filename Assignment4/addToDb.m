function  addToDb(Mat, nam, func)

Character.Matrix = Mat;
Character.name = nam;
Character.function = func;

fid = fopen('CharacterDb.txt', 'a+');
fprintf(fid,'%s %s %s',Character.Matrix, Character.name, Character.function);
fclose(fid);

end

