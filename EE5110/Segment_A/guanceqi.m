s=tf('s');
Ts=110*ones(10,1);
Rs=110*ones(5,1);
T0=[110*ones(5,1);25*ones(5,1)];
t=0:0.01:500;
u=110*ones(5,length(t));
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
sys1 = ss(A,B,C,D);


%[cc,dd]=eig(A);

pr=[-4+3i -4-3i -40 -41 -42 -43 -44 -45 -46 -47];
%pr=[-1/15+0.009686442097i -1/15-0.009686442097i -10 -10 -10 -10 -20 -20 -20 -20];
%Kr=place(A,B,pr);
qq=[100 100 100 100 100 400 100 100 100 100];
%rr=[0.01 0.01 0.01 0.01 0.01];
rr=[0.005 0.005 0.005 0.005 0.005];
Q=diag(qq);
R=diag(rr);
Kr=lqr(A,B,Q,R);

P=eye(2*N,2*N);
Hr=[-5 -5 -5 -5 -5];
H=place(Aww,Apw,Hr);
A1=Aww-H*Apw;
B1=Bww-H*Bpp;
C1=Awp-H*App;


K0=Kr;
A0=A-B*Kr;
%[cc,dd]=eig(A0);
B0=(B*Kr-A)*Ts/Rs;
%L0=B\B0;
%L1=A0*Ts+B0*Rs;
%L2=A0*Ts+B*L0*Rs;
%L3=L2-L1;
%II=pinv(B);
%Zr=II*L3;
%A2=A0*Ts;
%B2=B*L0;

W0=B*Kr-A;
W=mat2cell(W0,[5,5],[5,5]);
W11=W{1,1};
W12=W{1,2};
W21=W{2,1};
W22=W{2,2};
Tf2=110*ones(5,1);
tf2=W22*Tf2;
Tf1=-W21\tf2;
Tf=[Tf1;Tf2];
Te=A0*Tf;
Zr=B\W0*Tf;
B2=B*Zr-Te;


C0=eye(2*N,2*N);
D0=zeros(2*N,N);
sys0=ss(A0,B0,C0,D0);
%figure(1)
lsim(sys0,u,t,T0);

%figure(1)
%lsim(sys2,u,t,Ts);
%figure(2)
%lsim(sys2,u,t,T0);
%step(sys);

%Tw = 100*ones(N,1);
%Tp = -(Aww/Awp)*Tw;

%plantop = A*T + B*q;