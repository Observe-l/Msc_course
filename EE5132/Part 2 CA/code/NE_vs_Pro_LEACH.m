%%
%% LEACH protocol for WSN
%% Senario as described in (Heinzelman, Chandrakasan, & Balakrishnan, 2002)
%% BY Group3
%% Based on code by Smaragdakis, Matta and Bestavros, BU, USA

clear;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PARAMETERS %%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Number of Nodes in the field
n=100;

%Optimal Election Probability of a node
%to be;come cluster head
% p=0.1;

%Energy Model (all values in Joules)
%Initial Energy 
Eo=2;

%Eelec=Etx=Erx
ETX=50*0.000000001;
ERX=50*0.000000001;

%Transmit Amplifier types (Epsilon_{amp})
Emp=0.0013*0.000000000001;
Efs=100*0.000000000001;

%Data Aggregation Energy
EDA=50*0.000000001;

%Bits transmitted
length = 500 * 8;

%maximum number of rounds
rmax=500;

%distance threshold
d_o=sqrt(Efs/Emp);

%the energy of direct connect
Dissipate_Energy(1) = Eo * n;

%%%%%%%%%%%%%%%%%%%%%%%%% END OF PARAMETERS %%%%%%%%%%%%%%%%%%%%%%%%
%Creation of the random Sensor Network


for m = 2 : 1 : 101

p = (m - 1)/100;

%Field Dimensions - x and y maximum (in meters)
xm=100;
ym=100;

%x and y Coordinates of the Sink
sink.x=0.5*xm;
sink.y=1.75*ym;

%figure(1);
for i=1:1:n
    S(i).xd=rand(1,1)*xm;
    S(i).yd=rand(1,1)*ym;
    S(i).G=0; % the set of nodes that weren't cluster-heads the previous rounds

    %initially there are no cluster heads only nodes
    S(i).type='N';
    S(i).E=Eo;
end

S(n+1).xd=sink.x;
S(n+1).yd=sink.y;

        
%%%%%%%First Iteration%%%%%%%%%%%%

%counter for CHs
countCHs1=0;
%counter for CHs per round
rcountCHs1=0;

countCHs1;
rcountCHs1=rcountCHs1+countCHs1;
flag_first_dead=0;



%%%%%%%%%%%%%%%%%%%%%% START OF MAIN LOOP for rmax rounds %%%%%%%%%%%%%%%%%%

for r=1:1:rmax
  r%  show the round index
  %Operation for epoch
  if(mod(r, round(1/p) )==0)
    for i=1:1:n
        S(i).G=0;
    end
  end

%hold off;

%Number of dead nodes
dead=0;

%counter for packets transmitted to Base Stations and to Cluster Heads
packets_TO_BS=0;
packets_TO_CH=0;
%counter for packets transmitted to Base Stations and to Cluster Heads 
%per round
PACKETS_TO_CH(r)=0;
PACKETS_TO_BS(r)=0;

%figure(1);

for i=1:1:n
    %checking if there is a dead node
    if (S(i).E<=0)
        dead=dead+1;   
    end
    if S(i).E>0
        S(i).type='N';

    end
end
%plot(S(n+1).xd,S(n+1).yd,'x');

STATISTICS(r).DEAD=dead;
DEAD(r)=dead;


%When the first node dies
if (dead==1)
    if(flag_first_dead==0)
        first_dead=r
        flag_first_dead=1;
    end
end


%%%%%%%%%%%%% Calculate the average energy%%%%%%%%%%%%%%%%%%%%
% According to Heinzelman, Chandrakasan, & Balakrishnan, 2002, we should
% compute the average energy at the BS station
EnergyTotal=0;
for i=1:n
    if (S(i).E >= 0)
        EnergyTotal=EnergyTotal + S(i).E;
    end
end
EnergyAvg = EnergyTotal/n;

ENERGEY_TOTAL(r) = EnergyTotal;
ENERGEY_AVG(r) = EnergyAvg;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


countCHs1=0;
cluster=1;
for i=1:1:n
   if(S(i).E>0)
     temp_rand=rand;     
     if ((S(i).G)<=0)

     %Election of Cluster Heads
       if(temp_rand<=(p/(1-p*mod(r,round(1/p)))))
            countCHs1=countCHs1+1; %CH numbers plus 1
            packets_TO_BS=packets_TO_BS+1;
            PACKETS_TO_BS(r)=packets_TO_BS;
            
            S(i).type='C';
            S(i).G=round(1/p)-1;
            C(cluster).xd=S(i).xd;
            C(cluster).yd=S(i).yd;

            distance=sqrt( (S(i).xd-(S(n+1).xd))^2 + (S(i).yd-(S(n+1).yd))^2 );
            C(cluster).distance=distance;
            C(cluster).id=i;
            cluster=cluster+1;
            
            % Calculation of Energy dissipated
            % Base on Heinzelman, Chandrakasan, & Balakrishnan, 2002
            % formula
            distance;
            if (distance>=d_o)
                S(i).E=S(i).E - ( (ETX+EDA)*length + Emp*length*(distance)^4); 
            end
            if (distance<d_o)
                S(i).E=S(i).E - ( (ETX+EDA)*length  + Efs*length*(distance)^2); 
            end
 
       end
     end
   end
end

COUNTCHS1(r) = countCHs1;

STATISTICS(r).CLUSTERHEADS=cluster-1;
CLUSTERHS(r)=cluster-1;

% Election of Associated Cluster Head for Normal Nodes
for i=1:1:n
   if ( S(i).type=='N' && S(i).E>0 )
       
    %if there are more than 1 clusters
    if(cluster-1>=1)
        % the initial minimum distance are set to infinity
        min_dis=Inf;
        min_dis_cluster=0;
        for c=1:1:cluster-1
            temp=min(min_dis,sqrt( (S(i).xd-C(c).xd)^2 + (S(i).yd-C(c).yd)^2 ) );
            if ( temp<min_dis )
                min_dis=temp;
                min_dis_cluster=c;
            end
        end 
        min_dis;
        if (min_dis>=d_o)
            S(i).E=S(i).E - ( (ETX+EDA)*length + Emp*length*(min_dis)^4); 
        end
        if (min_dis<d_o)
            S(i).E=S(i).E - ( (ETX+EDA)*length  + Efs*length*(min_dis)^2); 
        end
        S(C(min_dis_cluster).id).E = S(C(min_dis_cluster).id).E- ( (ERX+EDA)*length); 
       
        S(i).min_dis=min_dis;
        S(i).min_dis_cluster=min_dis_cluster; 

        PACKETS_TO_BS1(r)=n-dead-cluster+1;
        PACKETS_TO_CH1(r)=n-dead-cluster+1; 

   %if there is only 1 cluster
   else
        min_dis=sqrt( (S(i).xd-S(n+1).xd)^2 + (S(i).yd-S(n+1).yd)^2 );
        if (min_dis>=d_o)
            S(i).E=S(i).E - ( (ETX+EDA)*length + Emp*length*(min_dis)^4); 
        end
        if (min_dis<d_o)
            S(i).E=S(i).E - ( (ETX+EDA)*length  + Efs*length*(min_dis)^2); 
        end
        packets_TO_BS=packets_TO_BS+1;
    
    end

  end
end


countCHs1;
rcountCHs1=rcountCHs1+countCHs1;

PacketRecEnergy = 0 ;

for i=1:n
    if(S(i).E < 0)
        temp = 0 ;
    else
        temp = S(i).E ;
    end
    PacketRecEnergy = PacketRecEnergy + Eo - temp;

end

AggPacketRecvEnergy(r) = PacketRecEnergy;

end

%record the decipate energy
Dissipate_Energy(m) = Eo * n - EnergyTotal;

end

%%%%%%%%%%%%%%%%%%%%%% END OF MAIN LOOP for rmax rounds %%%%%%%%%%%%%%%%%%

figure
m = 1 : 1 : 101;
Dissipate_Energy(1) = Dissipate_Energy(end);

plot(m, Dissipate_Energy(m)/max(Dissipate_Energy), 'r-','LineWidth',1)
axis([0 100 0 1])
xticks(0:10:100);
xlabel('percentage')
ylabel('Dissipate Energy - LEACH')




% figure
% plot(cumsum(PACKETS_TO_BS),'k-','LineWidth',1)
% legend('LEACH')
% xlabel('Time(rounds)')
% ylabel('Number of data signals received at the base station')
% 
% figure
% plot(AggPacketRecvEnergy,cumsum(PACKETS_TO_BS),'k-','LineWidth',1)
% legend('LEACH')
% xlabel('Energy(J)')
% ylabel('Number of data signals received at the base station')
% 
% figure
% plot(100*ones(1,rmax)-DEAD,'k-','LineWidth',1)
% legend('LEACH')
% xlabel('Time(rounds)')
% ylabel('Number of nodes alive')
% 
% figure
% plot(cumsum(PACKETS_TO_BS),100*ones(1,rmax)-DEAD,'k-','LineWidth',1)
% legend('LEACH')
% xlabel('Number of data items received at BS')
% ylabel('Number of nodes alive')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   STATISTICS    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                                     %
%  DEAD  : a rmax x 1 array of number of dead nodes/round 
%  CLUSTERHS : a rmax x 1 array of number of Cluster Heads/round
%  PACKETS_TO_BS : a rmax x 1 array of number packets send to Base Station/round
%  PACKETS_TO_CH : a rmax x 1 array of number of packets send to ClusterHeads/round
%  first_dead: the round where the first node died                   
%  ENERGEY_TOTAL : a rmax x 1 array of total energy round
%  ENERGEY_AVG: a rmax x 1 array of average energy round                                                                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





