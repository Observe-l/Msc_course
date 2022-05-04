syms theta1 theta2 theta3 thetaA fN ft

p_A = [100;0;50;1];
x3=[0;0;0;1];
A01=[cos(theta1),0,-sin(theta1),0
     sin(theta1),0,cos(theta1),0
     0,-1,0,400
     0,0,0,1];
A12=[cos(theta2),0,sin(theta2),0
     sin(theta2),0,-cos(theta2),0
     0,1,0,0
     0,0,0,1];
A23=[cos(theta3),-sin(theta3),0,0
     sin(theta3),cos(theta3),0,0
     0,0,1,100
     0,0,0,1];
T02=A01*A12;
T03=A01*A12*A23;
T30=inv(T03);
p_A0=T03*p_A;
theta1=-pi/2;
theta2=-pi/4;
theta3=0;

circle_v2=double(subs(p_A0))
% x30=T03*x3;
% F=[-fN*cos(thetaA);
%     ft;
%     -fN*sin(thetaA);
%     40-50*ft;
%     100*fN*sin(thetaA)-50*fN*cos(thetaA);
%     100*ft];
% 
% 
% b0=[0;0;1];
% b1=[-sin(theta1);cos(theta1);0];
% b2=[sin(theta2)*cos(theta1);sin(theta1)*sin(theta2);cos(theta2)];
% r0e=400*b0+100*b2;
% r1e=100*b2;
% r2e=100*b2;
% J1=[cross(b0,r0e);b0];
% J2=[cross(b1,r1e);b1];
% J3=[cross(b2,r2e);b2];
% J=[J1,J2,J3];
% tau=J.'*F;
