clear;
syms dth1 dth2 dth3
syms th1 th2 th3
syms l1 l2 l3
syms I1 I2 I3
syms d1 dd1

G=zeros(4,1);
mass = [1;1.2;1;0.6]; % mass of each  link
m1 = mass(1);
m2 = mass(2);
m3 = mass(3);
m4 = mass(4);
g = 9.8;

q = [d1;th1;th2;th3];
dq = [dd1;dth1;dth2;dth3];

%%%%%%%%%%%%%%%%%%%%%%%%%%% solve D(q)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
D = [1  0                                                    0                                                    0;
     0  1.408*cos(th2)+0.24*cos(th3)+0.24*cos(th2+th3)       0.96*cos(th2)+0.4*cos(th3)+0.12*cos(th2+th3)+1.1255  0.12*cos(th3)+0.12*cos(th2+th3)+0.1125;                                  
     0  0.96*cos(th2)+0.4*cos(th3)+0.12*cos(th2+th3)+1.1255  0.24*cos(th3)+0.8695                                 0.12*cos(th3)+0.1125;
     0  0.12*cos(th3)+0.12*cos(th2+th3)+0.1125               0.12*cos(th3)+0.1125                                 0.1125     ];

%%%%%%%%%%%%%%%%%%%%%%%%%%% solve C(q,dq) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = 1 : 4
    for j = 1 : 4
        for k = 1 : 4
            c(i,j,k) = 1/2*(diff(D(k,j),q(i)) + diff(D(k,i),q(j)) - diff(D(i,j),q(k)));
        end
    end
end


for k = 1 : 4
    for j = 1 : 4
        C(k,j) = c(1,j,k)*dq(1) + c(2,j,k)*dq(2) + c(3,j,k)*dq(3) + c(4,j,k)*dq(4);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%% solve G(q) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

G(1) = (m1 + m2 + m3 + m4) * g;



