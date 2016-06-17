function [I]=ChargementSeqIm(NomG,exte,N,E)
% chargement d'une séquence d'images dans un tableau 3D
% NomG : nom générique de la séquence 
% ext : extension des images
% N :   si size(N)=[1 1] -> nombre d'images à charger dans la séquence 
%       si size(N)=[1 2]    N=[N0,N1] :     N0=indice de la première image
%                                           N1=indice de la dernière image
%                                           N1-N0+1 images
% E : vecteur fenetre permettant d'extraire une partie d el'iamage

if size(N,2)==1
    N0=1;N1=N;
else
    N0=N(1);N1=N(2);
end

I=[];
for c=N0:N1
    NomS=[NomG,sprintf('%1.0f',c),exte];
    img=double(imread(NomS));
    if E==0
        I(:,:,c-N0+1)=img;
    else
        I(:,:,c-N0+1)=img(E(1):E(2),E(3):E(4));
    end
end


    