%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Author: Liu Weihao
%%Matriculation number: A0232935A
%%File: Q5_code
%%Date: 14 NOV 2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
A=[-1.7,-0.25,0;23,-30,20;0,-200-290,-220-920];
B=[3+2,0;-30-53,0;0,-420-350];
C=[0,1,0;0,0,1];
BB=[B,B];
x0=[1;100;200];

Abar=[A,zeros(3,2);-C,zeros(2,2)];
Bbar=[B;zeros(2,2)];

qq=[10,10,10,15,15];
rr=[10,10];
Q=diag(qq);
R=diag(rr);
Gamma=[Abar,-Bbar/R*Bbar';-Q,-Abar'];
[x,y]=eig(Gamma);
y=diag(y);
k=1;
for i=1:length(y)
    if(y(i)<0)
        v(:,k)=x(1:5,i);
        mu(:,k)=x(6:10,i);
        k=k+1;
    end
end
P=mu/v;
K=R\Bbar'*P;

s0=-5;
s1=-10;
s2=-10;

At=A';
Ct=C';

b1=Ct(:,1);
b2=Ct(:,2);
Wc=[Ct,At*Ct,At^2*Ct];
%choose b1,A*b1,b2
C_1=[b1,At*b1,b2];
C_t=inv(C_1);
%d1=2,d2=1,T=[q2;q2*A;q3]
q2=C_t(2,:);
q3=C_t(3,:);
T=[q2;q2*At;q3];
Aba=T*At/T;
Bba=T*Ct;
Ad=[0,1,0;0,0,1;s0*s1*s2,-(s0*s1+s0*s2+s1*s2),s0+s1+s2];
Lba=Bba\(Aba-Ad);
Lt=Lba*T;
L=Lt';