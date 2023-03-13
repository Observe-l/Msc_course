%%
%% LEACH protocol for WSN
%% EE5132/EE5024 CK Tham, ECE NUS
%% Based on code by Smaragdakis, Matta and Bestavros, BU, USA
%%
clear;
clear all;
close all;
clf('reset');

tic

final_ed = [];
final_ed_A = [];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PARAMETERS %%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Field Dimensions - x and y maximum (in meters)
xm=100;
ym=100;

%x and y Coordinates of the Sink
sink.x=0;
sink.y=175;

%Number of Nodes in the field
n=100;

%Optimal Election Probability of a node
%to become cluster head
%p=0.1;

%Energy Model (all values in Joules)
%Initial Energy 
Eo=2;

%Eelec=Etx=Erx
ETX=50*0.000000001;
ERX=50*0.000000001;

%Transmit Amplifier types (Epsilon_{amp})
Emp=100*0.000000000001;

% Data Aggregation Energy
EDA=50*0.000000001;

%maximum number of rounds
rmax=300;

%%%%%%%%%%%%%%%%%%%%%%%%% END OF PARAMETERS %%%%%%%%%%%%%%%%%%%%%%%%


%%%%% iterate through cluster node density %%%%%%%%

%Creation of the random Sensor Network
% figure(1);
for i=1:1:n
    S(i).xd=rand(1,1)*xm;
    S(i).yd=rand(1,1)*ym;
    S(i).G=0;
    %initially there are no cluster heads only nodes
    S(i).type='N';
    S(i).E=Eo;
    S(i).Ed=0;
    % plot(S(i).xd,S(i).yd,'o');
    % hold on;
end

S(n+1).xd=sink.x;
S(n+1).yd=sink.y;
% plot(S(n+1).xd,S(n+1).yd,'x');
AggPacketRecvEnergy = [] ;
step = 0.01;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% After generate the node map, start the main loop (vary p)
%%%% I think we'd better fix the scenario.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for p = 0:step:1
p
% Initialize Ed, Ed_a, counter before round loop
% Energy dissipated include Data Aggregation Energy
Ed_A=0;
% Energy dissipated exclude Data Aggregation Energy
Ed=0;
counter = 0;

for i=1:1:n
%     S(i).xd=rand(1,1)*xm;
%     S(i).yd=rand(1,1)*ym;
    S(i).G=0;
    %initially there are no cluster heads only nodes
    S(i).type='N';
    S(i).E=Eo;
    S(i).Ed=0;
    % plot(S(i).xd,S(i).yd,'o');
    % hold on;
end

%First Iteration
% figure(1);

%counter for CHs
countCHs=0;
%counter for CHs per round
rcountCHs=0;

countCHs;
rcountCHs=rcountCHs+countCHs;
flag_first_dead=0;
PacketRecEnergy     = 0  ;

%%%%%%%%%%%%%%%%%%%%%% START OF MAIN LOOP for rmax rounds %%%%%%%%%%%%%%%%%%
for r=1:1:rmax
  % r
  %Operation for epoch
  if(mod(r, round(1/p) )==0)
    for i=1:1:n
        S(i).G=0;
    end
  end

% hold off;

%Number of dead nodes
dead=0;

%counter for packets transmitted to Base Stations and to Cluster Heads
packets_TO_BS=0;
packets_TO_CH=0;
%counter for packets transmitted to Base Stations and to Cluster Heads 
%per round
PACKETS_TO_CH(r)=0;
PACKETS_TO_BS(r)=0;

% figure(1);

for i=1:1:n
    %checking if there is a dead node
    if (S(i).E<=0)
        % plot(S(i).xd,S(i).yd,'red .');
        dead=dead+1;
        % hold on;    
    end
    if S(i).E>0
        S(i).type='N';
        % plot(S(i).xd,S(i).yd,'o');
        % hold on;
    end
end
% plot(S(n+1).xd,S(n+1).yd,'x');

STATISTICS(r).DEAD=dead;
DEAD(r)=dead;

%When the first node dies
if (dead==1)
    if(flag_first_dead==0)
        first_dead=r
        flag_first_dead=1;
    end
end

countCHs=0;
cluster=1;
for i=1:1:n
   if(S(i).E>0)
     temp_rand=rand;     
     if ((S(i).G)<=0)

     %Election of Cluster Heads
       if(temp_rand<=(p/(1-p*mod(r,round(1/p)))))
            countCHs=countCHs+1;
            packets_TO_BS=packets_TO_BS+1;
            PACKETS_TO_BS(r)=packets_TO_BS;
            
            S(i).type='C';
            S(i).G=round(1/p)-1;
            C(cluster).xd=S(i).xd;
            C(cluster).yd=S(i).yd;
            % plot(S(i).xd,S(i).yd,'k*');
            
            distance=sqrt( (S(i).xd-(S(n+1).xd))^2 + (S(i).yd-(S(n+1).yd))^2 );
            C(cluster).distance=distance;
            C(cluster).id=i;
            cluster=cluster+1;
            
            % Calculation of Energy dissipated
            distance;
            S(i).E = S(i).E - ( ETX*2000 + Emp*2000*(distance*distance) ); %cz: why minus, why initial energy: S.E is energy left at the sensor, so if <0 it is a dead node
            %%%%%%%%%%%%%%%% lwh's modification %%%%%%%%%%%%%%%%
            %%%% Energy dissipated from cluster head to base station
            if S(i).E > 0
                counter = counter + 1;
                Ed = Ed + (ETX*(2000)+Emp*2000*(distance*distance));
                Ed_A = Ed_A + (ETX*(2000)+Emp*2000*(distance*distance));
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       end
     end
   end
end

STATISTICS(r).CLUSTERHEADS=cluster-1;
CLUSTERHS(r)=cluster-1;

% Election of Associated Cluster Head for Normal Nodes
for i=1:1:n
   if ( S(i).type=='N' && S(i).E>0 ) % cz: >0 ensures not a dead node
     if(cluster-1>=1)
       min_dis=sqrt( (S(i).xd-S(n+1).xd)^2 + (S(i).yd-S(n+1).yd)^2 );
       min_dis_cluster=0;
       for c=1:1:cluster-1
           temp=sqrt( (S(i).xd-C(c).xd)^2 + (S(i).yd-C(c).yd)^2 );
           if ( temp<min_dis )
               min_dis=temp;
               min_dis_cluster=c;
           end
       end
       
       % Energy dissipated to associated Cluster Head
       min_dis;
       S(i).E = S(i).E - (ETX*(2000)+Emp*2000*(min_dis*min_dis));

       %%%%%%%%%%%%%% lwh's modification %%%%%%%%%%%%%%%
       %%% Data from normal node to cluster head. (normal node energy dissipated)
       if S(i).E > 0
           counter = counter + 1;
           Ed = Ed + (ETX*(2000)+Emp*2000*(min_dis*min_dis));
           Ed_A = Ed_A + (ETX*(2000)+Emp*2000*(min_dis*min_dis));
       end
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

       % Energy dissipated at associated Cluster Head
       if(min_dis_cluster>0)
           S(C(min_dis_cluster).id).E = S(C(min_dis_cluster).id).E - (ERX+EDA)*2000;

           %%%%%%%%%%%%%% lwh's modification %%%%%%%%%%%%%%%
           %%%% Data from normal node to cluster head. (cluster heater energy dissipated)
           if S(C(min_dis_cluster).id).E > 0
               counter = counter + 1;
               Ed = Ed + ERX*2000;
               Ed_A = Ed_A + (ERX+EDA)*2000;
           end
           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

           PACKETS_TO_CH(r)=n-dead-cluster+1; 
       end
       S(i).min_dis=min_dis;
       S(i).min_dis_cluster=min_dis_cluster;
     end
  end
end
% hold on;

end

PacketRecEnergy = 0 ;

for i=1:n
    if(S(i).E < 0)
        temp = 0 ;
    else
        temp = S(i).E ;
    end
    PacketRecEnergy = PacketRecEnergy + Eo - temp;

end

AggPacketRecvEnergy = [AggPacketRecvEnergy PacketRecEnergy];
mean_ed = Ed / counter;
mean_ed_A = Ed_A / counter;

final_ed = [final_ed mean_ed];
final_ed_A = [final_ed_A mean_ed];

%%%%%%%%%%%%%%%%%%%%%% END OF MAIN LOOP for rmax rounds %%%%%%%%%%%%%%%%%%


end

final_ed(:,1)=final_ed(:,end);
final_ed_A(:,1)=final_ed_A(:,end);
AggPacketRecvEnergy(:,1)=AggPacketRecvEnergy(:,end);
% normalize energy dissipation
PRE_n= AggPacketRecvEnergy/max(AggPacketRecvEnergy);
Ed_n = final_ed/max(final_ed);
Ed_A_n = final_ed_A/max(final_ed_A);
x = 0:step:1;

% Energy dissipated exclude Data Aggregation Energy
figure(1)
plot(x,Ed_n)
xlabel('Percentage of nodes that are cluster heads')
ylabel('Normalized energy dissipation')

% Energy dissipated include Data Aggregation Energy
figure(2)
plot(x,Ed_A_n)
xlabel('Percentage of nodes that are cluster heads')
ylabel('Normalized energy dissipation')

figure(3)
plot(x,PRE_n)
xlabel('Percentage of nodes that are cluster heads')
ylabel('Normalized energy dissipation')
toc
