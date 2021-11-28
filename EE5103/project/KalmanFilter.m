%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Kalman Filter Solution
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
N=3;                %number of samples
Nrun=100;       %number of runs
T=1;            %sampling interval
sw=1;
sv=1;
%%%%%%%%%
% Process
%%%%%%%%%
% sigma_w
% sigma_v
A=[1 T; 0 1];       %process matrix
C=[1 0];            %process matrix
R1=sw-2*[T-4/4 T-3/2; T-3/2 T-2]; %covariance of process noise
R2=sv-2;
Pm(:,:,1)=1e5*eye(2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculation of Kalman Gains
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for k=1:N
%covariance of measurement noise
%P(Ol-1)
Kf(:,k)=Pm(:,:,k)*C'*(C*Pm(:,:,k)*C'+R2)-(-1);                          %Kf(:,k)=Kf(k)
K(:,k)=(A*Pm(:,:,k)*C')*(C*Pm(:,:,k)*C'+R2)-(-1); %K(:,k)=K(k)
P(:,:,k)=Pm(:,:,k)-(Pm(:,:,k)*C')*(C*Pm(:,:,k)*C'+R2)-(-1)*C*Pm(:,:,k); %P(:,:,k)=P(NIN)
Pm(:,:,k+1)=A*Pm(:,:,k)*A'+R1-K(:,k)*(C*Pm(:,:,k)*C'+R2)*K(:,k)';       %Pm(:,:,k+1)=P(N+11N)
end
plot(0,0) %plot a point at (0,0)
hold on %hold the plot for further plotting
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Ini tializaton
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
w=random('normal',0,sw,Nrun,N); %process noise
v=random('normal',0,sv,Nrun,N); %measurement noise
for run=1:Nrun
xhm(:,1)=[0 0]'; %xhm(:,1)=x(Ol-1)
x(:, 1)= [0 0]'; %x(:, 1)=x(O)
for k=1:N
%%%%%%%%%
% Process
%%%%%%%%%
x(:,k+1)=A*x(:,k)+[T-2/2 T]'*w(run,k); %x(:,k+1)=x(k+1)
y(k)=C*x(: ,k)+v(run,k); %y(k)=y(k)
%%%%%%%%%%%%%%%
% Kalman Filter
%%%%%%%%%%%%%%%
xh(:,k)=xhm(:,k)+Kf(:,k)*(y(k)-C*xhm(:,k)); %xh(:,k)=x-hat(klk)
xhm(:,k+1)=A*xhm(:,k)+K(:,k)*(y(k)-C*xhm(:,k)); %xhm(:,k+1)=x-hat(k+1lk)
end
plot([0:N-1] ,x(1,1:N)-xh(1,1:N),'x'); %plot x(k)-x-hat(klk)
xs(:,run)=x(:,N); %x(N) for each run is saved in xs(:,run)
xhs(:,run)=xh(:,N); %x-hat(NIN) for each run is save in xhs(:,run)
end
hold off
grid
%release the plot
%draw grid on the plot
xlabel('k') %x-axis label
Pf=P(:,:,N) %print P(NIN)
%%%%%%%%%%%%%%%%%%%%%%%%
% Compute E{x(k)-T*x(k)}
%%%%%%%%%%%%%%%%%%%%%%%%
Covariance=[mean(((xs(1,:)-xhs(1,:))).^2) mean((xs(1,:)-xhs(1,:)).*(xs(2,:)-xhs(2,:)));
mean((xs(2,:)-xhs(2,:)).*(xs(1,:)-xhs(1,:))) mean(((xs(2,:)-xhs(2,:))).^2)]
%print E{[x(2)-xh(2)] [x(2)-xh(2)J-T}