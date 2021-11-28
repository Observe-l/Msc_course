t=0:0.1:3;
T=3;
A=[15;75;0;0;0;0];
B=[0 0 0 0 0 1;T^5 T^4 T^3 T^2 T 1;0 0 0 0 1 0;5*T^4 4*T^3 3*T^2 2*T 1 0;0 0 0 2 0 0;20*T^3 12*T^2 6*T 2 0 0];
P=B\A;
P5=P(1);
P4=P(2);
P3=P(3);
P2=P(4);
P1=P(5);
P0=P(6);
x=P0+P1.*t+P2.*t.^2+P3.*t.^3+P4.*t.^4+P5.*t.^5;
v=P1+2*P2.*t+3*P3.*t.^2+4*P4.*t.^3+5*P5.*t.^4;
a=2*P2+6*P3.*t+12*P4.*t.^2+20*P5.*t.^3;
figure(1)
plot(t,x);
title("time-position")
xlabel("time")
ylabel("position")

figure(2)
plot(t,v);
title("time-speed")
xlabel("time")
ylabel("speed")

figure(3)
plot(t,a);
title("time-acceleration")
xlabel("time")
ylabel("acceleration")