function w=ProduitVectoriel(u,v);

u1=u(1);u2=u(2);u3=u(3);
v1=v(1);v2=v(2);v3=v(3);
w(1)=(u2*v3)-(u3*v2);
w(2)=(u3*v1)-(u1*v3);
w(3)=(u1*v2)-(u2*v1);
w=w';