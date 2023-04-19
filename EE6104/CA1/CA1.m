eta = 0.01;
wn = 1;

ga = 1;
Gamma = 100*diag([1*ga,1*ga,1*ga,1*ga,1*ga]);

a1 = 0.22;
a2 = 6.1;
b0 = -0.5;
b1 = -1;
num = [b0 b1];
dem = [1 2*eta*wn wn^2];
sys = tf(num,dem);
pole(sys)

K_p = b0;
Z_p = [1 b1/b0];
R_p = [1 a1 a2];
T = [1 2*eta*wn wn^2];
a_m = 3;
R_m = [1 a_m];
K_m = a_m;
[E,F] = deconv(conv(T,R_m),R_p);

Fbar = F/K_p;
Gbar = conv(E,Z_p);
G1 = Gbar - T;
K_star = K_m/K_p;
theta_bar_star = [K_star,-G1(3),-G1(2),-Fbar(4),-Fbar(3)];