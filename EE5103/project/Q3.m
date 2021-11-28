clear
N=25;
Nrun=1; 
T=1;
sw=0.1;
sv=1;

% A=[cos(pi/12),-sin(pi/12);sin(pi/12) cos(pi/12)];
A=[1 T 0 0;0 1 0 0; 0 0 1 T;0 0 0 1];
C=[1 0 0 0;0 0 1 0];
R1=sw^2*[T^4/4 T^3/2 0 0; T^3/2 T^2 0 0;0 0 T^4/4 T^3/2; 0 0 T^3/2 T^2];
R2=sv^2*eye(2);
Pm(:,:,1)=1e5*eye(4);

for k=1:N
    Kf(:,:,k)=Pm(:,:,k)*C'*(C*Pm(:,:,k)*C'+R2)^(-1);
    K(:,:,k)=(A*Pm(:,:,k)*C')*(C*Pm(:,:,k)*C'+R2)^(-1);
    P(:,:,k)=Pm(:,:,k)-(Pm(:,:,k)*C')*(C*Pm(:,:,k)*C'+R2)^(-1)*C*Pm(:,:,k);
    Pm(:,:,k+1)=A*Pm(:,:,k)*A'+ R1 -K(:,:,k)*(C*Pm(:,:,k)*C'+R2)*K(:,:,k)';
end

v=random('normal',0,sv,Nrun,N);
y=[7.1165 9.6022 8.9144 9.2717 6.3400 4.0484 0.3411 -0.6784 -5.7726 -5.4925 -9.4523 -9.7232 -9.5054 -9.7908 -7.7300 -5.9779  -4.5535 -1.5042 -0.7044 3.2406 8.3029 6.1925 9.1178 9.0904 9.0662;
    0.000 3.1398 6.3739 9.5877 10.1450 10.1919 9.0683 10.2254 7.5799 7.7231 5.4721 3.3990 0.9172 -1.3551 -5.2708 -9.7011 -9.4256 -9.3053 -9.3815 -9.8822 -8.1876 -8.7501 -4.5653 -1.9179 -1.0000];

for run=1:Nrun
    xhm(:,1)=[0 0 0 0]';
    x(:,1)=[10 0 0 10]';
    for k=1:N
        x(:,k+1)=[10*cos((k*pi)/12);-(10*pi/12)*sin((k*pi)/12);10*sin((k*pi)/12);(10*pi/12)*cos((k*pi)/12)];
%         x(:,k+1)=AF*x(:,k)+[T^2/2;T;T^2/2;T]*w(run,k);
%         y(:,k)=C*x(:,k)+[1;1]*v(run,k);
        
        xh(:,k)=xhm(:,k)+Kf(:,:,k)*(y(:,k)-C*xhm(:,k));
        xhm(:,k+1)=A*xhm(:,k)+K(:,:,k)*(y(:,k)-C*xhm(:,k));
    end
end
S=x([1,3],[1:N])-xh([1,3],:);
Bias1=1/(N+1)*sum(S(1,:));
Var1=1/(N+1)*sum(S(1,:).^2);

Bias2=1/(N+1)*sum(S(2,:));
Var2=1/(N+1)*sum(S(2,:).^2);

figure(1)
plot(0,0)
hold on
% plot([0:N-1],x(1,1:N),'x');
% plot([0:N-1],x(2,1:N),'o');
plot(xh(1,1:N),xh(3,1:N),'--');
plot(x(1,1:N),x(3,1:N),'o');
axis equal;
hold off
grid
xlabel('x-axis');
ylabel('y-axis');

figure(2)
subplot(2,2,1)
Kf11= squeeze(Kf(1,1,1:N));
Kf21= squeeze(Kf(2,1,1:N));
Kf32= squeeze(Kf(3,2,1:N));
Kf42= squeeze(Kf(4,2,1:N));
plot([0:N-1],Kf11,'x');
grid
xlabel('k');
ylabel('Kf11');

subplot(2,2,2)
plot([0:N-1],Kf21,'x');
grid
xlabel('k');
ylabel('Kf21');

subplot(2,2,3)
plot([0:N-1],Kf32,'x');
grid
xlabel('k');
ylabel('Kf21');

subplot(2,2,4)
plot([0:N-1],Kf42,'x');
grid
xlabel('k');
ylabel('Kf21');

%%%%%%
figure(3)
subplot(2,2,1)
K11= squeeze(K(1,1,1:N));
K21= squeeze(K(2,1,1:N));
K32= squeeze(K(3,2,1:N));
K42= squeeze(K(4,2,1:N));
plot([0:N-1],K11,'x');
grid
xlabel('k');
ylabel('K11');

subplot(2,2,2)
plot([0:N-1],K21,'x');
grid
xlabel('k');
ylabel('K21');

subplot(2,2,3)
plot([0:N-1],K32,'x');
grid
xlabel('k');
ylabel('K32');

subplot(2,2,4)
plot([0:N-1],K42,'x');
grid
xlabel('k');
ylabel('K42');

%%%%%%
figure(4)
subplot(2,2,1)
P11= squeeze(P(1,1,1:N));
P22= squeeze(P(2,2,1:N));
P33= squeeze(P(3,3,1:N));
P44= squeeze(P(4,4,1:N));
plot([0:N-1],P11,'x');
grid
xlabel('k');
ylabel('P11');

subplot(2,2,2)
plot([0:N-1],P22,'x');
grid
xlabel('k');
ylabel('P22');

subplot(2,2,3)
plot([0:N-1],P33,'x');
grid
xlabel('k');
ylabel('P33');

subplot(2,2,4)
plot([0:N-1],P44,'x');
grid
xlabel('k');
ylabel('P44');

%%%%%%
figure(5)
subplot(2,2,1)
Pm11= squeeze(Pm(1,1,1:N));
Pm22= squeeze(Pm(2,2,1:N));
Pm33= squeeze(Pm(3,3,1:N));
Pm44= squeeze(Pm(4,4,1:N));
plot([0:N-1],Pm11,'x');
grid
xlabel('k');
ylabel('P11(k+1|k)');

subplot(2,2,2)
plot([0:N-1],Pm22,'x');
grid
xlabel('k');
ylabel('P22(k+1|k)');

subplot(2,2,3)
plot([0:N-1],Pm33,'x');
grid
xlabel('k');
ylabel('P33(k+1|k)');

subplot(2,2,4)
plot([0:N-1],Pm44,'x');
grid
xlabel('k');
ylabel('P44(k+1|k)');