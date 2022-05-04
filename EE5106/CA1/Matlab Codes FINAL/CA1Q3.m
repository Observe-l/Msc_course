clear all
close all
clc

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
T02=A01*A12;
T03=A01*A12*A23;
T30=inv(T03);
p_A0=T03*p_A;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%Calculate torque/force%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
F3=[-fN*sind(theta2);
    ft;
    -fN*cosd(theta2);
    0.04-0.05*ft;
    0.1*fN*cosd(theta2)-0.05*fN*sind(theta2);
    0.1*ft];
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

F03 = [T03(1:3,1:3) zeros(3); zeros(3) T03(1:3,1:3)]*F3;
tau=J.'*F03;

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
    joint_tau(:,k) = double(subs(tau));
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
title("Tool Tip's Path")
xlabel('x0 axis (meters)')
ylabel('y0 axis (meters)')
zlabel('z0 axis (meters)')
grid on


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% joint angles versus time %%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(2)
plot(1:N+1,theta1_time, 1:N+1,theta2_time, 1:N+1,theta3_time,'LineWidth', 1.5)

title("Joint Angles versus Time")
xlabel('Time(seconds)')
ylabel('Angles(degrees)')
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
title("Joint Rates versus Time")
xlabel('Time(seconds)')
ylabel('Rate(degrees/seconds)')
legend('Rate of Joint 1 ($\theta_1$)','Rate of Joint 2 ($\theta_2$)','Rate of Joint 3 ($\theta_3$)','interpreter', 'latex')
ylim([-5,5])
grid on


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% joint torque versus time %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(4)

plot(1:N+1,joint_tau(1,1:N+1),1:N+1,joint_tau(2,1:N+1),1:N+1,joint_tau(3,1:N+1),'b-','LineWidth', 1.5)
title("Joint Torque versus Time")
xlabel('Time(seconds)')
ylabel('Joint Torque (N . m)')
legend('Joint Torque 1 ($\tau_1$)', 'Joint Torque 2 ($\tau_2$)','Joint Torque 3 ($\tau_3$)', 'interpreter', 'latex')

grid on