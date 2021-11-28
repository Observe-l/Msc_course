%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Author: Liu Weihao
%%Matriculation number: A0232935A
%%File: Q4_code
%%Date: 14 NOV 2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
syms s
A=[-1.7,-0.25,0;23,-30,20;0,-200-290,-220-920];
B=[3+2,0;-30-53,0;0,-420-350];
C=[0,1,0;0,0,1];
D=zeros(2,2);
C1=eye(3);
D1=zeros(3,2);
x0=[1;100;200];

C1T=C(1,:);
C2T=C(2,:);

s0=-3;
s1=-10;

B_s=[C1T*B;C2T*B];
C_s=[C1T*A;C2T*A];
C_ss=[C1T*(A-s0*eye(3));C2T*(A-s1*eye(3))];
K=B_s\C_ss;
F=inv(B_s);
H=C*(s*eye(3)-(A-B*K))^(-1)*B*F;

[x,y]=eig(A-B*K)