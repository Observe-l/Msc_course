%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%Author: Liu Weihao
%%%Data: 13 Mar 2022
%%%File name: Question2.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
syms l1 d2 d3 theta1 fx fy fz
%D-H representation
T1=[cos(theta1),-sin(theta1),0,0;
    sin(theta1),cos(theta1),0,0;
    0,0,1,l1;
    0,0,0,1];
T2=[0,0,1,0;
    1,0,0,0;
    0,1,0,d2;
    0,0,0,1];
T3=[1,0,0,0;
    0,1,0,0;
    0,0,1,d3;
    0,0,0,1];

T = T1*T2*T3;

% unit vector along z-axis expressed in x0y0z0
b0 = [0;0;1];
b1 = [0;0;1];
b2 = [cos(theta1);sin(theta1);0];
% Position vector from Oi-1 to end-effector
r0 = l1*b0+d2*b1+d3*b2;
r1 = d2*b1+d3*b2;
r2 = d3*b2;

% Jacobian matrix
J1 = [cross(b0,r0);b0];
J2 = [b1;zeros(3,1)];
J3 = [b2;zeros(3,1)];
J = [J1,J2,J3];
% Liner velocity part
JL = J(1:3,:);


% Transformation of Forces and moments
F=[fx;
   fy;
   fz;
   0;
   0;
   0];
R= T(1:3,1:3);
p = T(1:3,4:4);
px=[0,-p(3),p(2);p(3),0,-p(1);-p(2),p(1),0];
T_tra=[R,zeros(3,3);px*R,R];

% drive torque
tau_o = J.' * F;

% Substitute the value
fx = 1;
fy = 2;
fz = 3;
theta1 = 0;
d2 = 1;
d3 = 1;
tau = subs(tau_o);