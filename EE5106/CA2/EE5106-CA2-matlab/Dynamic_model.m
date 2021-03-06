function [D,C,G]=Dynamic_model(q,dq)

mass = [1;1.2;1;0.6];
m1 = mass(1);
m2 = mass(2);
m3 = mass(3);
m4 = mass(4);
g = 9.8;

D=zeros(4,4); C=zeros(4,4); G=zeros(4,1);

D(1,1) = 1;
D(2,2) = 1.408*cos(q(3))+0.24*cos(q(4))+0.24*cos(q(3)+q(4));
D(2,3) = 0.96*cos(q(3))+0.4*cos(q(4))+0.12*cos(q(3)+q(4))+1.1255;
D(2,4) = 0.12*cos(q(4))+0.12*cos(q(3)+q(4))+0.1125; 
D(3,2) = 0.96*cos(q(3))+0.4*cos(q(4))+0.12*cos(q(3)+q(4))+1.1255;
D(3,3) = 0.24*cos(q(4))+0.8695;
D(3,4) = 0.12*cos(q(4))+0.1125;
D(4,2) = 0.12*cos(q(4))+0.12*cos(q(3)+q(4))+0.1125;
D(4,3) = 0.12*cos(q(4))+0.1125;
D(4,4) = 0.1125;



C(2,2) = - dq(4)*(0.12*sin(q(3)+q(4)) + 0.12*sin(q(4))) - dq(3)*(0.12*sin(q(3)+q(4)) + 0.704*sin(q(3)));
C(2,3) = - dq(4)*(0.12*sin(q(3)+q(4)) + 0.2*sin(q(4))) - dq(3)*(0.12*sin(q(3)+q(4)) + 0.96*sin(q(3))) - dq(2)*(0.12*sin(q(3)+q(4)) + 0.704*sin(q(3)));
C(2,4) = - dq(4)*(0.12*sin(q(3)+q(4)) + 0.12*sin(q(4))) - dq(3)*(0.12*sin(q(3)+q(4)) + 0.2*sin(q(4))) - dq(2)*(0.12*sin(q(3)+q(4))+ 0.12*sin(q(4))); 

C(3,2) = dq(2)*(0.12*sin(q(3)+q(4)) + 0.704*sin(q(3))) - dq(4)*0.2*sin(q(4));
C(3,3) = - dq(4)*0.12*sin(q(4));
C(3,4) = - dq(2)*0.2*sin(q(4))- dq(3)*0.12*sin(q(4)) - dq(4)*0.12*sin(q(4));
C(4,2) =  dq(2)*((0.12*sin(q(3)+q(4))) + 0.12*sin(q(4))) + dq(3)*0.2*sin(q(4));
C(4,3) =  dq(2)*0.2*sin(q(4)) + dq(3)*0.12*sin(q(4));

G(1) = (m1 + m2 + m3 + m4) * g;