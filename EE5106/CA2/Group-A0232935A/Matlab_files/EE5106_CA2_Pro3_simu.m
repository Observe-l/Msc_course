n = 4;
q0 = [0.5, 0, 0, 0]; % initial position
dq0 = zeros(n,1); % zero initial velocity
T=25; % period

q(:,1)=q0; 
dq(:,1)=dq0;
h=0.01; % sampling gap
i=1;

for t=0:h:T
    tao = [0;  0.8* sin(t); 0.8* sin(t); 0.5 * sin(t)]; % given torque
    [D,C,G] = Dynamic_model(q(:,i),dq(:,i)); % find D, C, G
    ID = inv(D); % do the inverse
    ddq(:,i) = ID * (tao - C * dq(:,i) -G); % find acceleration
    dq(:,i+1) = dq(:,i) + ddq(:,i) * h;  % find velocity
    q(:,i+1) = q(:,i) + dq(:,i) * h + (1/2) * ddq(:,i) * h * h; % find position
    i=i+1;
end

t = 0.01:h:T;
i = 1:1:T*100;

figure(1) 
plot(t,q(2,i),t,q(3,i),t,q(4,i));
legend('q2','q3','q4'); 
xlabel('time')


figure(2) 
plot(t,q(2,i));
legend('q2'); 
xlabel('time')


figure(3) 
plot(t,q(3,i));
legend('q3'); 
xlabel('time')

figure(4) 
plot(t,q(4,i));
legend('q4'); 
xlabel('time')

figure(5) 
plot(t,dq(2,i),t,dq(3,i),t,dq(4,i));
legend('dq2','dq3','dq4'); 
xlabel('time')

figure(6) 
plot(t,ddq(2,i),t,ddq(3,i),t,ddq(4,i));
legend('ddq2','ddq3','ddq4'); 
xlabel('time')


