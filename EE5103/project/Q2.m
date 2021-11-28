clear
N=10000;
Nrun=1; 
T=1;       
sw=0.1;
sv=1;

A=[1 T;0 1];
C=[1 0];
R1=sw^2*[T^4/4 T^3/2; T^3/2 T^2];
R2=sv^2;
Pm(:,:,1)=1e5*eye(2);

for k=1:N
    Kf(:,k)=Pm(:,:,k)*C'*(C*Pm(:,:,k)*C'+R2)^(-1);
    K(:,k)=(A*Pm(:,:,k)*C')*(C*Pm(:,:,k)*C'+R2)^(-1);
    P(:,:,k)=Pm(:,:,k)-(Pm(:,:,k)*C')*(C*Pm(:,:,k)*C'+R2)^(-1)*C*Pm(:,:,k);
    Pm(:,:,k+1)=A*Pm(:,:,k)*A'+R1-K(:,k)*(C*Pm(:,:,k)*C'+R2)*K(:,k)';
end


w=random('normal',0,sw,Nrun,N);
v=random('normal',0,sv,Nrun,N);

for run=1:Nrun
    xhm(:,1)=[0 0]';
    x(:,1)=[0 30]';
    for k=1:N
        x(:,k+1)=A*x(:,k)+[T^2/2 T]'*w(run,k);
        y(k)=C*x(:,k)+v(run,k);
        
        xh(:,k)=xhm(:,k)+Kf(:,k)*(y(k)-C*xhm(:,k));
        xhm(:,k+1)=A*xhm(:,k)+K(:,k)*(y(k)-C*xhm(:,k));
    end
end

figure(4)
plot(0,0)
hold on
plot([0:N-1],x(1,1:N),'-*g');
plot([0:N-1],xh(1,1:N),'.');
xs(:,1)=x(:,N);
xhs(:,1)=xh(:,N);
hold off
grid
xlabel('k');
ylabel('x1');

figure(5)
plot(0,0)
hold on
plot([0:N-1],x(2,1:N),'-*g');
plot([0:N-1],xh(2,1:N),'.');
hold off
grid
xlabel('k');
ylabel('x2');

figure(6)
P11=squeeze(P(1,1,:));
plot(0,0)
hold on
plot([0:N-1],P11,'o');
hold off
grid
xlabel('k');
ylabel('P11');

figure(7)
P22=squeeze(P(2,2,:));
plot(0,0)
hold on
plot([0:N-1],P22,'o');
hold off
grid
xlabel('k');
ylabel('P22');

figure(8)
plot(0,0)
hold on
plot([0:N-1],Kf(1,:),'o');
hold off
grid
xlabel('k');
ylabel('Kf1');

figure(9)
plot(0,0)
hold on
plot([0:N-1],Kf(2,:),'o');
hold off
grid
xlabel('k');
ylabel('Kf2');

S=x(:,[1:N])-xh(:,:);
Bias1=1/(N+1)*sum(S(1,:));
Var1=1/(N+1)*sum(S(1,:).^2);

Bias2=1/(N+1)*sum(S(2,:));
Var2=1/(N+1)*sum(S(2,:).^2);