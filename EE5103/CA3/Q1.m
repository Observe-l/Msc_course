ts=0.01;
TF1=tf(0.1,[1,-1.8,0.9],ts);
TF2=tf([0.0556,0.04448],[1,-1.8,0.9],ts);
syms z
num1=0.1*(z^2-1.5*z+0.5);
den1=(z^2-1.8*z+0.9)*(z+0.8);
num1=sym2poly(num1);
den1=sym2poly(den1);
U1=tf(num1,den1,ts);

num2=z*(z^2-1.8*z+0.9)-(-0.0812*z+0.137)*(z+0.8);
den2=(z-0.219)*(z^2-1.8*z+0.9);
num2=sym2poly(num2);
den2=sym2poly(den2);
U2=tf(num2,den2,ts);

figure(1)
subplot(1,2,1)
step(TF1,TF2);
title('Output signal');
legend('Zero is canceled','Zero is not canceled');
subplot(1,2,2)
step(U1,U2);
title('Input signal');
legend('Zero is canceled','Zero is not canceled');