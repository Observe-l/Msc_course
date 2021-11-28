clear
N=10000;
Nrun=1; 
T=1;       
sw=0.1;
sv=1;

A=1;
C=1;
R1=sw^2;
R2=sv^2;
Pm(:,:,1)=1e5*eye(1);

for k=1:N
    Kf(:,k)=Pm(:,:,k)*C'*(C*Pm(:,:,k)*C'+R2)^(-1);
    K(:,k)=(A*Pm(:,:,k)*C')*(C*Pm(:,:,k)*C'+R2)^(-1);
    P(:,:,k)=Pm(:,:,k)-(Pm(:,:,k)*C')*(C*Pm(:,:,k)*C'+R2)^(-1)*C*Pm(:,:,k);
    Pm(:,:,k+1)=A*Pm(:,:,k)*A'+R1-K(:,k)*(C*Pm(:,:,k)*C'+R2)*K(:,k)';
end

w=random('normal',0,sw,Nrun,N);
v=random('normal',0,sv,Nrun,N);

xhm(:,1)=0;
x(:,1)=5;

for k=1:N
    x(:,k+1)=A*x(:,k)+w(1,k);
    y(k)=C*x(:,k)+v(1,k);
        
    xh(:,k)=xhm(:,k)+Kf(:,k)*(y(k)-C*xhm(:,k));
    xhm(:,k+1)=A*xhm(:,k)+K(:,k)*(y(k)-C*xhm(:,k));
end

Pf=squeeze(P);
S=x(:,[1:N])-xh;
Bias=1/(N+1)*sum(S);
Var=1/(N+1)*sum(S.^2);


figure(1)
plot(0,0)
hold on
plot([0:N-1],x(1,1:N),'-*g');
plot([0:N-1],xh(1,1:N),'.');
xs(:,1)=x(:,N);
xhs(:,1)=xh(:,N);
hold off
grid
xlabel('k');

figure(2)
plot([0:N-1],Pf,'x');
xlabel('P(k|k)');
grid

figure(3)
plot([0:N-1],Kf,'x');
xlabel('Kf(k)');
grid


