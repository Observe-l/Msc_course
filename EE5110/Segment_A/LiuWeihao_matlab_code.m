%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%This program use LQR controler and State Observer to control the wafer temperature.
%%The simulation is in the simulink model.
%%Liu Weihao
%%Date:28/8/2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

N = 5;			% number of zones
% The total number of states is 2N, the first N states are the plate temperature
% while the next N states are the wafer temperature

D = 0.45;		% 450mm
tp = 1.778e-3;	% plate thickness
ta = 125e-6;	% airgap (6mils)
tw = 0.925e-3;% wafer thickness
dr = D/2/N;		% zone thickness
ta = 125e-6*ones(1,N);

for i=1:N,
   Aps(i) = 2*pi*i*dr*tp;
   Apz(i) = pi*(i*i - (i-1)*(i-1))*dr*dr;
   Aws(i) = 2*pi*i*dr*tw;
   Vp(i) = Apz(i)*tp;
   Vw(i) = Apz(i)*tw;
end;

%Thermophysical Properties
% rho - density
% Cp - specific heat
% k - thermal conductivity
% Silicon
rho_si = 2330;
Cp_si = 790;
k_si = 99;

% Aluminum
rho_al = 2700;
Cp_al = 896;
k_al = 167;

% Quatz
rho_q = 2800;
Cp_q = 833;

% Air gap
k_a = 0.03;
ka = k_a;
rho_a = 1.1; 
Cp_a = 1000;
V_a = 10;
h = 10;

%Plate (aluminum)
kp = k_al;
Cpp = Cp_al;
rhop = rho_al;

%Wafer (silicon)
kw = k_si;
Cpw = Cp_si;
rhow = rho_si;

%Modeling
%Resistance and Capacitance
for i=1:N-1,
   Rpr(i) = log((i+1/2)/(i-1/2))/(2*pi*kp*tp);
   Rwr(i) = log((i+1/2)/(i-1/2))/(2*pi*kw*tw);
end;
for i=1:N,
   Ra(i) = ta(i)/(ka*Apz(i));
   Rwz(i) = 1/(h*Apz(i));
end;
Rpr(N) = 1/(h*Aps(N));
Rwr(N) = 1/(h*Aws(N));

for i=1:N,
   Cp(i) = rhop*Cpp*Vp(i);
   Cw(i) = rhow*Cpw*Vw(i);
end;


%Energy Balance Equations
% In state-space format
% define A and B matrix here, C assumed to be I (all states available)
% A = |App Apw|
%     |Awp Aww|
App = zeros(N,N);		%note that App is tridiagonial
App(1,1) = -(1/Rpr(1) + 1/Ra(1))/Cp(1);
for i=2:N,
   App(i,i) = -(1/Rpr(i) + 1/Rpr(i-1) + 1/Ra(i))/Cp(i);
   App(i,i-1) = (1/Rpr(i-1))/Cp(i);
end;
for i=1:N-1,
   App(i,i+1) = (1/Rpr(i))/Cp(i);
end;

Apw = diag(1./(Ra.*Cp));  % will be different if the airgap is varying
Awp = diag(1./(Ra.*Cw));

Aww = zeros(N,N);		%note that Aww is tridiagonial
Aww(1,1) = -(1/Rwr(1) + 1/Ra(1) + 1/Rwz(1))/Cw(1);
for i=2:N,
   Aww(i,i) = -(1/Rwr(i) + 1/Rwr(i-1) + 1/Ra(i) + 1/Rwz(i))/Cw(i);
   Aww(i,i-1) = (1/Rwr(i-1))/Cw(i);
end;
for i=1:N-1,
   Aww(i,i+1) = (1/Rwr(i))/Cw(i);
end;

for i=1:N,
   temp(i)=Apz(i)/Cp(i);
end;
Bpp = diag(temp);
Bww = zeros(N,N);
%q = u2;
%Combining everything
A = [App Apw;Awp Aww];
B = [Bpp;Bww];
C = eye(2*N,2*N);
D = [zeros(N,N);zeros(N,N)];
sys = ss(A,B,C,D);
%step(sys);

%Tw = 100*ones(N,1);
%Tp = -(Aww/Awp)*Tw;

%plantop = A*T + B*q;


%%LQR controler

qq=[100 100 100 100 100 300 100 100 100 100];
Q=diag(qq);
rr=[0.001 0.001 0.001 0.001 0.001];
R=diag(rr);
Kr=lqr(A,B,Q,R);
%%[cc,dd]=eig(A-B*Kr);

%%State Observer
%%We need to use the bake-palte's temperature to estimate the temperature of the wafer
%%z'=A1*x1+B1*u+C1*y'
%%x1=z+Hy
%%x1 is the output of this State Observer, it represents the temperature of wafer;
%%u is the input of the hole system;

%%y' is part of the output of original system"sys". 
%%Because we can't use the temperature of wafer as feedback, y' only represent the temperature of bake-palte

%%The whole output y can be expressd as y=[y';x1];
%%Then, the LQR controler can use 'y' as feedback.
%%The eigenvalues of matrix H is usually 3-5 times det(sI-A+B*Kr), so I set it to -0.3

P=eye(2*N,2*N);
Hr=[-0.3 -0.3 -0.3 -0.3 -0.3];
H=place(Aww,Apw,Hr);
A1=Aww-H*Apw;
B1=Bww-H*Bpp;
C1=Awp-H*App;


%%Then we need to set the stable state of this system.
%%Follow the instruction on the assignment, The wafer steady-state temperature should be 110℃
%%So we can caculate the palte steady-state temperature.
%%Then we need to input a signal 'Rs' to achieve that goal.
A0=A-B*Kr;
W0=B*Kr-A;
W=mat2cell(W0,[5,5],[5,5]);
W11=W{1,1};
W12=W{1,2};
W21=W{2,1};
W22=W{2,2};
Tf2=110*ones(5,1);
tf2=W22*Tf2;
Tf1=-W21\tf2;
Tf=[Tf1;Tf2]; %%steady-state temperature
Te=A0*Tf;
Rs=B\W0*Tf;%%Reference signal
