x0=[180;0;0];
z=1;
N=360;
%%% Theta 1 range: [0,360] %%%%%%%
%%% Theta 2 range: [-90,90] %%%%%%
%%% Theta 3 range: [-180,180] %%%%
low_bound=[0;-90;-180];
up_bound=[360;90;180];
results = [];
% The radius of the circle is 170. z axis is 460.
% Assume that angular velocity is: 1 deg / second
for i = 0:1:360
    cir = [170*sind(-i);170*cosd(-i);460;1];
    % results(:,z)=fsolve(@(x)myfun(x,cir),x0);
    results(:,z)=lsqnonlin(@(x)myfun(x,cir),x0,low_bound,up_bound);
    z = z+1;
end

% Verify the results here
syms theta1 theta2 theta3 thetaA fN ft
p_A = [100;0;50;1];
A01=[cosd(theta1),0,-sind(theta1),0
     sind(theta1),0,cosd(theta1),0
     0,-1,0,400
     0,0,0,1];
A12=[cosd(theta2),0,sind(theta2),0
     sind(theta2),0,-cosd(theta2),0
     0,1,0,0
     0,0,0,1];
A23=[cosd(theta3),-sind(theta3),0,0
     sind(theta3),cosd(theta3),0,0
     0,0,1,100
     0,0,0,1];
T02=A01*A12;
T03=A01*A12*A23;
T30=inv(T03);
p_A0=T03*p_A;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%Calculate torque/force%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
F=[-fN*cos(thetaA);
    ft;
    -fN*sin(thetaA);
    40-50*ft;
    100*fN*sin(thetaA)-50*fN*cos(thetaA);
    100*ft];

b0=[0;0;1];
b1=[-sind(theta1);cosd(theta1);0];
b2=[sind(theta2)*cosd(theta1);sind(theta1)*sind(theta2);cosd(theta2)];
r0e=400*b0+100*b2;
r1e=100*b2;
r2e=100*b2;
J1=[cross(b0,r0e);b0];
J2=[cross(b1,r1e);b1];
J3=[cross(b2,r2e);b2];
J=[J1,J2,J3];
tau=J.'*F;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Insert 9 point between two adjacent points.%%%%%%
%%%%% The surface_path can be seen as moving track%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
surface =[]; % This is the results
surface_path =[];%This is the moving track
theta1=results(1,1);
theta2=results(2,1);
theta3=results(3,1);
surface_path(:,1)=double(subs(p_A0));
for i = 0:1:N-1
    for m = 1:1:10
        theta1=results(1,i+1) + m*(results(1,i+2) - results(1,i+1))/10;
        theta2=results(2,i+1) + m*(results(2,i+2) - results(2,i+1))/10;
        theta3=results(3,i+1) + m*(results(3,i+2) - results(3,i+1))/10;
        surface_path(:,10*i+m+1)=double(subs(p_A0));
    end
end

for i = 1:1:N+1
    theta1=results(1,i);
    theta2=results(2,i);
    theta3=results(3,i);
    surface(:,i)=double(subs(p_A0));
end
rate=[];
rate(:,1)=[0;0;0];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%% Cauculate joint rate %%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% rate = (angles(n)-angles(n-1))/step_time
%%%% step time is 1 seconds
for i = 1:1:N
    rate(:,i+1)=results(1:3,i+1)-results(1:3,i);
end

% results
figure(1)
plot3(surface(1,1:N+1),surface(2,1:N+1),surface(3,1:N+1))
xlim([-200 200])
ylim([-200 200])
zlim([300 600])
title("Results")
xlabel('x0 axis (millimeter)')
ylabel('y0 axis (millimeter)')
zlabel('z0 axis (millimeter)')

% path
figure(2)
plot3(surface_path(1,1:10*N+1),surface_path(2,1:10*N+1),surface_path(3,1:10*N+1))
xlim([-200 200])
ylim([-200 200])
zlim([300 600])
title("Path of the tool tip")
xlabel('x0 axis (millimeter)')
ylabel('y0 axis (millimeter)')
zlabel('z0 axis (millimeter)')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% joint angles versus time %%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(3)
subplot(2,2,1)
plot(1:N+1,results(1,1:N+1))
title("Joint 1")
xlabel('time(seconds)')
ylabel('angles(degrees)')

% joint 2 angles
subplot(2,2,2)
plot(1:N+1,results(2,1:N+1))
title("Joint 2")
xlabel('time(seconds)')
ylabel('angles(degrees)')

% joint 3 angles
subplot(2,2,3)
plot(1:N+1,results(3,1:N+1))
title("Joint 3")
xlabel('time(seconds)')
ylabel('angles(degrees)')
sgtitle("Joint angles versus time")

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% joint rate versus time %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(4)
subplot(2,2,1)
plot(1:N+1,rate(1,1:N+1))
title("Joint 1")
xlabel('time(seconds)')
ylabel('rate(degrees/seconds)')

subplot(2,2,2)
plot(1:N+1,rate(2,1:N+1))
title("Joint 2")
xlabel('time(seconds)')
ylabel('rate(degrees/seconds)')

subplot(2,2,3)
plot(1:N+1,rate(3,1:N+1))
title("Joint 3")
xlabel('time(seconds)')
ylabel('rate(degrees/seconds)')
sgtitle("Joint rates versus time")
