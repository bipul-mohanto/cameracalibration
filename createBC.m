function[B,C]=createBC(P)
% Creates matrices B and C from matrix P. P has on its firsts columns the coordinates Xi, Yi, Zi (in meter) of the scene points 
% and in the following columns the coordinates ui, vi (in pixel) of the projected points the image plane.
[nl,nc]=size(P);
B=zeros(2*nl,9);
for k=1:nl
	X=P(k,1);
	Y=P(k,2);
	Z=P(k,3);
	u=P(k,4);
	v=P(k,5);
	
	m=2*k-1;%lignes impaires
	B(m,1)=X;
	B(m,2)=Y;
	B(m,3)=Z;
	B(m,4)=1;
	B(m,9)=-u;
	C(m,1)=-u*X;
	C(m,2)=-u*Y;
	C(m,3)=-u*Z;
	

	l=2*k;%lignes paires
	B(l,5)=X;
	B(l,6)=Y;
	B(l,7)=Z;
	B(l,8)=1;
	B(l,9)=-v;
	C(l,1)=-v*X;
	C(l,2)=-v*Y;
	C(l,3)=-v*Z;
end