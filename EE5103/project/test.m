clear
N=25;
Nrun=1; 
T=1;
sw=1;
sv=1;

% A=[cos(pi/12),-sin(pi/12);sin(pi/12) cos(pi/12)];
A=[1 0;0 1];
C=[1 0;0 1];
R1=sw^2*eye(2);
R2=sv^2*eye(2);
Pm(:,:,1)=1e5*eye(2);

for k=1:N
    Kf(:,:,k)=Pm(:,:,k)*C'*(C*Pm(:,:,k)*C'+R2)^(-1);
    K(:,:,k)=(A*Pm(:,:,k)*C')*(C*Pm(:,:,k)*C'+R2)^(-1);
    P(:,:,k)=Pm(:,:,k)-(Pm(:,:,k)*C')*(C*Pm(:,:,k)*C'+R2)^(-1)*C*Pm(:,:,k);
    Pm(:,:,k+1)=A*Pm(:,:,k)*A'+ R1 -K(:,:,k)*(C*Pm(:,:,k)*C'+R2)*K(:,:,k)';
end

w=random('normal',0,sw,Nrun,N);
v=random('normal',0,sv,Nrun,N);
% y=[7.1165 9.6022 8.9144 9.2717 6.3400 4.0484 0.3411 -0.6784 -5.7726 -5.4925 -9.4523 -9.7232 -9.5054 -9.7908 -7.7300 -5.9779  -4.5535 -1.5042 -0.7044 3.2406 8.3029 6.1925 9.1178 9.0904 9.0662;
%     0.000 3.1398 6.3739 9.5877 10.1450 10.1919 9.0683 10.2254 7.5799 7.7231 5.4721 3.3990 0.9172 -1.3551 -5.2708 -9.7011 -9.4256 -9.3053 -9.3815 -9.8822 -8.1876 -8.7501 -4.5653 -1.9179 -1.0000];

AF=[cos(pi/12),-sin(pi/12);sin(pi/12),cos(pi/12)];
for run=1:Nrun
    xhm(:,1)=[0 0]';
    x(:,1)=[10 10]';
    for k=1:N
        x(:,k+1)=AF*x(:,k);
        y(:,k)=C*x(:,k)+[1;1]*v(run,k);
        
        xh(:,k)=xhm(:,k)+Kf(:,:,k)*(y(k)-C*xhm(:,k));
        xhm(:,k+1)=A*xhm(:,k)+K(:,:,k)*(y(k)-C*xhm(:,k));
    end
end
xs(:,run)=x(:,N);
xhs(:,run)=xh(:,N);

figure(1)
plot(0,0)
hold on
% plot([0:N-1],x(1,1:N),'x');
% plot([0:N-1],x(2,1:N),'o');
plot(xh(1,1:N),xh(2,1:N),'-');
plot(x(1,1:N),x(2,1:N),'o');
axis equal;
hold off
grid
xlabel('k');

% figure(2)
% plot(0,0)
% hold on
% plot(x(1,1:N),x(2,1:N),'x');
% % plot(y(1,1:N),y(2,1:N),'-');
% plot(xh(1,1:N),xh(2,1:N),'-');
% axis equal;
% 
% hold off
% xlabel('k');

Pf=P(:,:,N);