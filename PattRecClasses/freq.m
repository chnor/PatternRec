function result = freq(ech)
%This function returns a N*2 matrix with the given sources i and there
%associated frequencies.
taille=length(ech);
v=[ech(1)]; 
for k = 2:taille 
if ech(k)~=v 
v = [v,ech(k)]; 
end;
end;
v = sort(v); 
nbval=length(v); 
effectifs = []; 
for k = 1:nbval 
e = length(find(ech==v(k)));
effectifs = [effectifs,e]; 
end
f=effectifs/sum(effectifs) 

result = [v;f];
end

