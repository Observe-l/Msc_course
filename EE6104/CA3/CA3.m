poti = [-5 -4 -3 -2 -1 0 1 2 3 4 5]; % Potientiometer Output (in volts)
ang = [-180 -144 -108 -72 -36 0 36  72 108 144 180]; % Angular Position (in degrees)
reg_poti = fitlm(poti,ang,'intercept',false);
figure
hold on 
plot(reg_poti.Fitted,poti,'r-')
grid on 
xlabel('Angular Position (in degrees)')
ylabel('Output voltage of potientiometer(volts)')


tach = [-4.03,-3.17,-2.3,-1.45,-0.6,0,0.62,1.48,2.33,3.2,4.06];
ang2 = [-31.52,-24.82,-18.01,-11.31,-4.71,0,5.03,11.62,18.33,25.03,31.73]; 
reg_tach = fitlm(tach,ang2,'intercept',false);
figure
hold on 
plot(reg_tach.Fitted,tach,'r-')
grid on 
xlabel('Angular Velocity (rad/sec)')
ylabel('Output voltage of tachogenerator(volts)')

var = 1;
 
K = 6.2;
tau = 0.25;
b = [0;1];

C = 0.5;
w = 10;
Am = [0 1;-w^2 -2*C*w];
gm = [0;w^2];

Gamma = [ 1 0; 
          0 1];
gamma = 100;

Q = [10000 0;
     0     1];
P = lyap(Am',Q);









