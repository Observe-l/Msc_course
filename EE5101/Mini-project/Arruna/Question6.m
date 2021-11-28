clear;
clc;
sympref('FloatingPointOutput',true);
syms u1 u2 x
a=2;
b=5;
c=4;
d=1;
A=[-1.7 -0.25 0; 23 -30 20; 0 -450 -740];
B=[5 0; -44 0; 0 -830];
Cd=[1 0 0;0 1 0;0 0 1];
D=0;
x0=[1; 100; 200];
xsp=[5;250;300];
W=[a+b+1 0 0;0 c+4 0;0 0 d+5];

"""  At Steady State """ ;
U=[u1;u2];
xs=-inv(A)*B*U; %At steady state xdot=0
dis=xs-xsp;
J=0.5*dis'*W*dis;
J1=diff(J,u1)
J2=diff(J,u2)
[U1,U2]=vpasolve([J1 == 0, J2 == 0],[u1,u2])
U=[U1;U2]

""" J calculation with equilibrium points """ ;
xs=-inv(A)*B*U
dis=xs-xsp
J=0.5*dis'*W*dis

""" J calculation with initial condition """;
dis1=x0-xsp;
J1=0.5*dis1'*W*dis1

dis2=-xsp;
J2=0.5*dis2'*W*dis2
