%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Author: Liu Weihao
%%Matriculation number: A0232935A
%%File: Q1_code
%%Date: 14 NOV 2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
A=[-1.7,-0.25,0;23,-30,20;0,-200-290,-220-920];
B=[3+2,0;-30-53,0;0,-420-350];
C=[0,1,0;0,0,1];
D=zeros(2,2);
C1=eye(3);
D1=zeros(3,2);
x0=[1;100;200];
omega_n=0.24;
zeta=0.6;
s0=-zeta*omega_n-omega_n*sqrt(zeta^2-1);
s1=-zeta*omega_n+omega_n*sqrt(zeta^2-1);
s2=-0.64;
s=[s0,s1,s2];

b1=B(:,1);
b2=B(:,2);
Wc=[B,A*B,A^2*B];
%choose b1,A*b1,b2
C_1=[b1,A*b1,b2];
C_t=inv(C_1);
%d1=2,d2=1,T=[q2;q2*A;q3]
q2=C_t(2,:);
q3=C_t(3,:);
T=[q2;q2*A;q3];
Aba=T*A/T;
Bba=T*B;
Ad=[0,1,0;0,0,1;s0*s1*s2,-(s0*s1+s0*s2+s1*s2),s0+s1+s2];
% Ad=[s2,0,0;0,0,1;0,-(s0*s1),s0+s1];
Kba=Bba\(Aba-Ad);
K=Kba*T;