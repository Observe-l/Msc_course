%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Author: Liu Weihao
%%Matriculation number: A0232935A
%%File: Q6_code
%%Date: 14 NOV 2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
A=[-1.7,-0.25,0;23,-30,20;0,-200-290,-220-920];
B=[3+2,0;-30-53,0;0,-420-350];
C=[0,1,0;0,0,1];
D=zeros(2,2);
x0=[1;100;200];
W=diag([2+9+1,3+4,5+5]);

syms r1 r2

qq=[10,500,1000];
rr=[0.1,100];
Q=diag(qq);
R=diag(rr);
Gamma=[A,-B/R*B';-Q,-A'];
[x,y]=eig(Gamma);
y=diag(y);
k=1;
for i=1:length(y)
    if(y(i)<0)
        v(:,k)=x(1:3,i);
        mu(:,k)=x(4:6,i);
        k=k+1;
    end
end
P=mu/v;
K=R\B'*P;

R=[r1;r2];
Xs=(B*K-A)\B*R;
Xsp=[5;250;300];
J=0.5*(Xs-Xsp)'*W*(Xs-Xsp);
J1=diff(J,r1);
J2=diff(J,r2);
[R1,R2]=vpasolve([J1==0, J2==0],[r1,r2]);
R=[R1;R2];