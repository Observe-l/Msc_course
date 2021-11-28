%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Author: Liu Weihao
%%Matriculation number: A0232935A
%%File: Q3_code
%%Date: 14 NOV 2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
A=[-1.7,-0.25,0;23,-30,20;0,-200-290,-220-920];
B=[3+2,0;-30-53,0;0,-420-350];
C=[0,1,0;0,0,1];
D=zeros(2,2);
C1=eye(3);
D1=zeros(3,2);
x0=[1;100;200];

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

d=-3;
G=[10,20];
left=A-d*eye(3);
right=G*C;
T=right/left;
E=T*B;
zeta=inv([C;T]);