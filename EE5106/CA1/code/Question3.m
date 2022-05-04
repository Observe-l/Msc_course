N=360;

syms theta1 theta2 theta3 fN ft
p_A = [0.1;0;0.05;1];
A01=[cosd(theta1),0,-sind(theta1),0
     sind(theta1),0,cosd(theta1),0
     0,-1,0,0.4
     0,0,0,1];
A12=[cosd(theta2),0,sind(theta2),0
     sind(theta2),0,-cosd(theta2),0
     0,1,0,0
     0,0,0,1];
A23=[cosd(theta3),-sind(theta3),0,0
     sind(theta3),cosd(theta3),0,0
     0,0,1,0.1
     0,0,0,1];
A3E=[1,0,0,0.1;
     0,1,0,0;
     0,0,1,0.05;
     0,0,0,1];
T02=A01*A12;
T03=A01*A12*A23;
T0E=A01*A12*A23*A3E;
T30=inv(T03);
p_A0=T03*p_A;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%Calculate torque/force%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
F_33=[-fN*sind(theta2);
    ft;
    -fN*cosd(theta2);
    0.04-0.05*ft;
    0.1*fN*cosd(theta2)-0.05*fN*sind(theta2);
    0.1*ft];
F_EE=[-fN*sind(theta2);
    ft;
    -fN*cosd(theta2);
    0.04;
    0;
    0];
%%%% Jacobian matrix
b0=[0;0;1];
b1=[-sind(theta1);cosd(theta1);0];
b2=[sind(theta2)*cosd(theta1);sind(theta1)*sind(theta2);cosd(theta2)];
r0e=0.4*b0+0.1*b2;
r1e=0.1*b2;
r2e=0.1*b2;
J1=[cross(b0,r0e);b0];
J2=[cross(b1,r1e);b1];
J3=[cross(b2,r2e);b2];
J=[J1,J2,J3];
%%%% Transformation of Forces and moments
p0E=T0E(1:3,4);
R0E=T0E(1:3,1:3);
p0E_cross=[0,-p0E(3),p0E(2);
          p0E(3),0,-p0E(1);
          -p0E(2),p0E(1),0];
T_NF=[R0E,zeros(3,3);
      zeros(3,3),R0E];

F0E=T_NF*F_EE;

p03=T03(1:3,4);
R03=T03(1:3,1:3);
p0E_cross=[0,-p03(3),p03(2);
          p03(3),0,-p03(1);
          -p03(2),p03(1),0];
T_NF=[R03,zeros(3,3);
      zeros(3,3),R03];

F03=T_NF*F_33;
tau_3=J.'*F03;
tau_E=J.'*F0E;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Insert 9 point between two adjacent points.%%%%%%
%%%%% The surface_path can be seen as moving track%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
surface =[]; % This is the results

theta2 = -45;
theta3 = 0;
fN=10;
ft=10;
k=1;
for i = -90:1:270
    theta1=i;
    surface(:,k)=double(subs(p_A0));
    theta1_time(k)=theta1;
    joint_tau(:,k) = double(subs(tau_3));
    joint_tau_E(:,k) = double(subs(tau_E));
    k=k+1;
end

theta2_time=-45*ones(N+1);
theta3_time=zeros(N+1);

Theta1_rate=ones(N+1);
Theta2_rate=zeros(N+1);
Theta3_rate=zeros(N+1);


% results
figure(1)
plot3(surface(1,1:N+1),surface(2,1:N+1),surface(3,1:N+1))
text(surface(1,1),surface(2,1),surface(3,1),'A');
text(surface(1,91),surface(2,91),surface(3,91),'B');
text(surface(1,181),surface(2,181),surface(3,181),'C');
text(surface(1,271),surface(2,271),surface(3,271),'D');
title("Tool tips path")
xlabel('x0 axis (meter)')
ylabel('y0 axis (meter)')
zlabel('z0 axis (meter)')
grid on


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% joint angles versus time %%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(2)
plot(1:N+1,theta1_time, 1:N+1,theta2_time, 1:N+1,theta3_time,'LineWidth', 1.5)

title("Joint angles versus time")
xlabel('time(seconds)')
ylabel('angles(degrees)')
legend('Angle of Joint 1 ($\theta_1$)','Angle of Joint 2 ($\theta_2$)','Angle of Joint 3 ($\theta_3$)','interpreter', 'latex')
grid on


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% joint rate versus time %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(3)
% plot(1:N+1,Theta1_rate,'b-','LineWidth', 1.5)
% hold on
% plot(1:N+1,Theta2_rate,'r-','LineWidth', 1.5)
% hold on
% plot(1:N+1,Theta3_rate,'g-','LineWidth', 1.5)
% hold on
plot(1:N+1,Theta1_rate,1:N+1,Theta2_rate,1:N+1,Theta3_rate,'b-','LineWidth', 1.5)
title("Joint rates versus time")
xlabel('time(seconds)')
ylabel('rate(degrees/seconds)')
legend('rate of Joint 1 ($\theta_1$)','rate of Joint 2 ($\theta_2$)','rate of Joint 3 ($\theta_3$)','interpreter', 'latex')
ylim([-5,5])
grid on


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% joint torque versus time %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(4)

plot(1:N+1,joint_tau(1,1:N+1),1:N+1,joint_tau(2,1:N+1),1:N+1,joint_tau(3,1:N+1),'b-','LineWidth', 1.5)
title("Joint torque versus time")
xlabel('time(seconds)')
ylabel('joint torque (N . m)')
legend('Joint torque 1 ($\tau_1$)', 'Joint torque 2 ($\tau_2$)','Joint torque 3 ($\tau_3$)', 'interpreter', 'latex')

grid on