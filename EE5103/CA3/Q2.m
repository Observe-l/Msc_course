syms z s0 s1
Phi=[0.5,1;0.5,0.8];
Gamma=[0.2;0.1];
Phiv=[1;0];
C=[1,0];
H1=C/(z*[1,0;0,1]-Phi)*Gamma;
H2=C/(z*[1,0;0,1]-Phi)*Phiv;
Acl=(z^2-1.3*z)*(z-1)+(0.2*z-0.06)*(s0*z+s1);