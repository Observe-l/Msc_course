function F=myfun(x,cir)


p_A = [100;0;50;1];

A01=[cosd(x(1)),0,-sind(x(1)),0
     sind(x(1)),0,cosd(x(1)),0
     0,-1,0,400
     0,0,0,1];
A12=[cosd(x(2)),0,sind(x(2)),0
     sind(x(2)),0,-cosd(x(2)),0
     0,1,0,0
     0,0,0,1];
A23=[cosd(x(3)),-sind(x(3)),0,0
     sind(x(3)),cosd(x(3)),0,0
     0,0,1,100
     0,0,0,1];
T02=A01*A12;
T03=T02*A23;
T30=inv(T03);
F = T30*cir-p_A;
end