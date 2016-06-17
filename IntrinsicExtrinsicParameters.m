% Computation of intrinsic and extrinsic parameters using a calibration matrix

fprintf('******************************************************\n')
m1=M(1,1:3)
m2=M(2,1:3)
m3=M(3,1:3)
m14=M(1,4)
m24=M(2,4)
m34=M(3,4)
%%
fprintf('Principal point coordinates :\n')
u0=sum(m1.*m3)
v0=sum(m2.*m3)

%% 
fprintf('... to complete ');
m1vm3=ProduitVectoriel(m1,m3);
alphau=-sqrt(sum(m1vm3.*m1vm3))%=- ku.f
%%
fprintf('... to complete\n')
m2vm3=ProduitVectoriel(m2,m3);
alphav=sqrt(sum(m2vm3.*m2vm3))%= kv.f

%% 
fprintf('... to complete\n')
r1=(m1-(u0*m3))/alphau
r2=(m2-(v0*m3))/alphav
r3=m3

fprintf('... to complete\n')
tx=(m14-(u0*m34))/alphau
ty=(m24-(v0*m34))/alphav
tz=m34

