
syms d1 
syms theta1 theta2 theta3
syms l1 l2 l3


l1 = 0.8;
l2 = 0.8;
l3 = 0.5;

%calculate A_{i-1}_{i}
A01 = [1 0 0 0; 
       0 1 0 0; 
       0 0 1 d1; 
       0 0 0 1];
A12 = [cos(theta1) -sin(theta1) 0 0.8*cos(theta1); 
       sin(theta1) cos(theta1)  0 0.8*sin(theta1);
       0           0            1 0; 
       0           0            0 1];
A23 = [cos(theta2) -sin(theta2) 0 0.8*cos(theta2); 
       sin(theta2) cos(theta2)  0 0.8*sin(theta2);
       0           0            1 0; 
       0           0            0 1];
A34 = [cos(theta3) -sin(theta3) 0 0.5*cos(theta3); 
       sin(theta3) cos(theta3)  0 0.5*sin(theta3);
       0           0            1 0; 
       0           0            0 1];

A04 = A01 * A12 * A23 * A34;
simplify(A04);

%calculate R_{i-1}_{i}
R01 = [cos(theta1) -sin(theta1) 0;
       sin(theta1) cos(theta1) 0;
       0           0           1];
R12 = [cos(theta1) -sin(theta1) 0;
       sin(theta1) cos(theta1) 0;
       0           0           1];
R23 = [cos(theta2) -sin(theta2) 0;
       sin(theta2) cos(theta3) 0;
       0           0           1];
R34 = [cos(theta3) -sin(theta3) 0;
       sin(theta3) cos(theta3) 0;
       0           0           1];


%calculate r_{i-1}_{e}
X_bar = [0;0;0;1];

X_1e = A04*X_bar - A01*X_bar;
X_2e = A04*X_bar - A01*A12*X_bar;
X_3e = A04*X_bar - A01*A12*A23*X_bar;

b = [0;0;1];

J_L2 = cross(b,X_1e(1:3));
J_L3 = cross(b,X_2e(1:3));
J_L4 = cross(b,X_3e(1:3));

% Jacobian Matrix
J = [b J_L2 J_L3 J_L4;[0;0;0] b b b];
simplify(J);

% Calculate the inverse kinematics
P = A04(1:2,4);
simplify(P(1)^2+P(2)^2);

A01 * A12



