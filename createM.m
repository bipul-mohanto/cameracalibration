function M=createM(B,C)
% Compute calibration matrix M from B and C (see createBC.m)

D1=inv(B'*B)*B'*C;
D=C'*C-C'*B*D1;

[vect,valprop]=eig(D)
V=diag(valprop,0);
[minval,I]=min(V);
x3=[vect(1,I);vect(2,I);vect(3,I)];
x9=-D1*x3;
s=(x9(9)>=0)-1*(x9(9)<0);

Mt(:,1)=x9(1:4);
Mt(:,2)=x9(5:8);
Mt(4,3)=x9(9);
Mt(1:3,3)=x3;
M=s*Mt';


