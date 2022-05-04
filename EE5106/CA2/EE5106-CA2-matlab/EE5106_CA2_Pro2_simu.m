clear;
%setup robotics model
syms d1 
syms theta1 theta2 theta3
syms l1 l2 l3

% d1 = 0;
% theta1 = 0;
% theta2 = 0;
% theta3 = 0;
l1 = 0.8;
l2 = 0.8;
l3 = 0.5;

%       theta        d        a        alpha     sigma
L(1)=Link([0           d1       0        0         1]); %Define D-H parameters
L(2)=Link([theta1      0        l1       0         0]);
L(3)=Link([theta2      0        l2       0         0]);
L(4)=Link([theta3      0        l3       0         0]);

L(1).qlim = [0 1];
robot = SerialLink(L,'name','cleaning robot'); %Connect the link, name it
% robot.display();
% 
% robot.plot([0.5, pi/2, pi/2, pi/2]); %export model
% teach(robot);

Q = [d1 theta1 theta2 theta3];
F_kinematics_matrix = robot.fkine(Q); % forward kinematics

J = robot.jacob0(Q); % Jacobian Matrix
simplify(J);







