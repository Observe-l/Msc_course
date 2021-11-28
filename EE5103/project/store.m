clear
N=3;
Nrun=100; 
T=1;       
sw=1;
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

plot(0,0)
hold on

w=random('normal',0,sw,Nrun,N);
v=random('normal',0,sv,Nrun,N);

for run=1:Nrun
    xhm(:,1)=[0 0]';
    x(:,1)=[0 0]';
    for k=1:N
        x(:,k+1)=A*x(:,k)+[T^2/2 T]'*w(run,k);
        y(k)=C*x(:,k)+v(run,k);
        
        xh(:,k)=xhm(:,k)+Kf(:,k)*(y(k)-C*xhm(:,k));
        xhm(:,k+1)=A*xhm(:,k)+K(:,k)*(y(k)-C*xhm(:,k));
    end
    plot([0:N-1],x(1,1:N)-xh(1,1:N),'x');
    xs(:,run)=x(:,N);
    xhs(:,run)=xh(:,N);
end
hold off
grid
xlabel('k');
Pf=P(:,:,N);