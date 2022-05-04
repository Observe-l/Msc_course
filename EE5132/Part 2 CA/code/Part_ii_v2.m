%%
%% LEACH protocol for WSN
%% EE5132/EE5024 CK Tham, ECE NUS
%% Based on code by Smaragdakis, Matta and Bestavros, BU, USA
%%

clear;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PARAMETERS %%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Field Dimensions - x and y maximum (in meters)
xm=100;
ym=100;

%x and y Coordinates of the Sink
sink.x=50;
sink.y=50;

%Number of Nodes in the field
n=100;

%Optimal Election Probability of a node
%to become cluster head
p=0.1;
ps=0.2;

%Energy Model (all values in Joules)
%Initial Energy 
Eo=2;

%Eelec=Etx=Erx
ETX=50*0.000000001;
ERX=50*0.000000001;

%Transmit Amplifier types (Epsilon_{amp})
Emp=100*0.000000000001;

data_size = 2000;

% Data Aggregation Energy
EDA=50*0.000000001;

%maximum number of rounds
rmax=1000;

SUBCLUSTER=[];

%%%%%%%%%%%%%%%%%%%%%%%%% END OF PARAMETERS %%%%%%%%%%%%%%%%%%%%%%%%
%Creation of the random Sensor Network
% figure(1);
for i=1:1:n
    S(i).xd=rand(1,1)*xm;
    S(i).yd=rand(1,1)*ym;
    S(i).G=0;
    S(i).SG=0;
    %initially there are no cluster heads only nodes
    S(i).type='N';
    S(i).E=Eo;
    % plot(S(i).xd,S(i).yd,'o');
    % hold on;
end

S(n+1).xd=sink.x;
S(n+1).yd=sink.y;
% plot(S(n+1).xd,S(n+1).yd,'x');
        
%First Iteration
% figure(1);

%counter for CHs
countCHs=0;
%counter for CHs per round
rcountCHs=0;

countCHs;
rcountCHs=rcountCHs+countCHs;
flag_first_dead=0;
diff_m=[];
Ratio=[];
% for p=0:0.05:1
% p
AggPacketRecvEnergy = [];
step=0.05;
for ps=0:step:1
ps

for i=1:1:n
    S(i).G=0;
    S(i).SG=0;
    %initially there are no cluster heads only nodes
    S(i).type='N';
    S(i).E=Eo;
end

%counter for CHs
countCHs=0;
%counter for CHs per round
rcountCHs=0;

countCHs;
rcountCHs=rcountCHs+countCHs;
flag_first_dead=0;
%%%%%%%%%%%%%%%%%%%%%% START OF MAIN LOOP for rmax rounds %%%%%%%%%%%%%%%%%%
for r=1:1:rmax
%     r
    %Operation for epoch
    if(mod(r, round(1/p) )==0)
        for i=1:1:n
            S(i).G=0;
            % S(i).SG=0;
        end
    end
    if(mod(r, round(1/ps) )==0)
        for i=1:1:n
            S(i).SG=0;
        end
    end
    
    
    
    % hold off;
    
    %Number of dead nodes
    dead=0;
    
    %counter for packets transmitted to Base Stations and to Cluster Heads
    packets_TO_BS=0;
    packets_TO_CH=0;
    packets_TO_SE=0;
    %counter for packets transmitted to Base Stations and to Cluster Heads 
    %per round
    PACKETS_TO_CH(r)=0;
    PACKETS_TO_BS(r)=0;
    PACKETS_TO_SE(r)=0;
    
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
                
                % Calculation of Energy dissipated from Primary CH to BS
                distance;
                S(i).E = S(i).E - ( ETX*data_size + Emp*data_size*(distance*distance) ); 
           end
         end
       end
    end
    
    STATISTICS(r).CLUSTERHEADS=cluster-1;
    CLUSTERHS(r)=cluster-1;
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%% Election of Secondary cluster-head
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % The number of sub cluster
    countSCHs = 0;
    subcluster = 1;
    
    for i=1:1:n
        temp_rand=rand;
        % Elect Secondary cluster-head from normal node. The remain energy
        % should be biger than 0
        if(S(i).type =='N' && S(i).E>0 && S(i).SG<=0)
            if(temp_rand<=(ps/(1-ps*mod(r,round(1/ps)))))
                countSCHs = countSCHs + 1;
                packets_TO_SE = packets_TO_SE + 1;
                PACKETS_TO_SE(r) = packets_TO_SE;
                S(i).type='S';
                S(i).SG=round(1/ps)-1;
                SE(subcluster).xd=S(i).xd;
                SE(subcluster).yd=S(i).yd;
                SE(subcluster).id= i;
                subcluster = subcluster + 1;
                % In figure 1, Secondary cluster-head is a blue "+"
                % plot(S(i).xd,S(i).yd,'b+');
    
                % Find the closest primary cluster head when primary CHs
                % exist
                if(cluster-1>=1)
                    min_dis=sqrt( (S(i).xd-S(n+1).xd)^2 + (S(i).yd-S(n+1).yd)^2 );
                    min_dis_cluster=0;
                    for c=1:1:cluster-1
                        temp=min(min_dis,sqrt( (S(i).xd-C(c).xd)^2 + (S(i).yd-C(c).yd)^2 ) );
                        if(temp<min_dis)
                            min_dis=temp;
                            min_dis_cluster=c;
                        end
                    end
                    %Energy dissipated to associated Cluster Head(Transmit)
                    S(i).E = S(i).E - (ETX*(data_size)+Emp*data_size*(min_dis*min_dis));
                    % Energy dissipated at associated Cluster Head (Receive and aggregation)
                    if(min_dis_cluster>0)
                        S(C(min_dis_cluster).id).E = S(C(min_dis_cluster).id).E - (ERX+EDA)*data_size;
                        PACKETS_TO_CH(r)=subcluster-1; 
                    end
                    S(i).min_dis=min_dis;
                    S(i).min_dis_cluster=min_dis_cluster;
                end
            end
        end
    end
    SUBCLUSTER(:,r)=subcluster - 1;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%% Energy dissipated for normal node and secondary cluster-head
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for i=1:1:n
       if ( S(i).type=='N' && S(i).E>0 )
         %%%% Secondarey CHs are exist, normal node talk to secondary CHs %%%%%%
         if(subcluster-1>=1)
           min_dis=sqrt( (S(i).xd-S(n+1).xd)^2 + (S(i).yd-S(n+1).yd)^2 );
           min_dis_subcluster=0;
           for c=1:1:subcluster-1
               temp=min(min_dis,sqrt( (S(i).xd-SE(c).xd)^2 + (S(i).yd-SE(c).yd)^2 ) );
               if ( temp<min_dis )
                   min_dis=temp;
                   min_dis_subcluster=c;
               end
           end
           min_dis_cluster=0;
           for c=1:1:cluster-1
               temp=min(min_dis,sqrt( (S(i).xd-C(c).xd)^2 + (S(i).yd-C(c).yd)^2 ) );
               if ( temp<min_dis )
                   min_dis=temp;
                   min_dis_cluster=c;
                   min_dis_subcluster=0;
               end
           end
           % Energy dissipated to associated Cluster Head
           min_dis;
           S(i).E = S(i).E - (ETX*(data_size)+Emp*data_size*(min_dis*min_dis)); 
    
           % Energy dissipated at associated Cluster Head
           if(min_dis_subcluster>0)
               S(SE(min_dis_subcluster).id).E = S(SE(min_dis_subcluster).id).E - (ERX+EDA)*data_size; 
               PACKETS_TO_SE(r)=n-dead-(cluster-1)-(subcluster-1); 
           elseif(min_dis_cluster>0)
               S(C(min_dis_cluster).id).E = S(C(min_dis_cluster).id).E - (ERX+EDA)*data_size;
               PACKETS_TO_CH(r)=PACKETS_TO_CH(r)+1; 
           end
           
           S(i).min_dis=min_dis;
           S(i).min_dis_cluster=min_dis_cluster;
         end
      end
    end
    % hold on;
    
    countCHs;
    rcountCHs=rcountCHs+countCHs;
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
    
    AggPacketRecvEnergy = [AggPacketRecvEnergy PacketRecEnergy] ;

end
% AggPacketRecvEnergy(1)=AggPacketRecvEnergy(end);
% Agg_n=AggPacketRecvEnergy/max(AggPacketRecvEnergy);
% diff_m = [diff_m max(Agg_n)-min(Agg_n)];
% min_agg=min(Agg_n);
% ratio=(find(min_agg==Agg_n)-1)*0.05;
% Ratio=[Ratio ratio(1)];
% end
%%%%%%%%%%%%%%%%%%%% END OF MAIN LOOP for rmax rounds %%%%%%%%%%%%%%%%%%
% diff_m(1)=diff_m(end);
% figure(1)
% plot(0:5:100,diff_m)
% xlabel('Percentage of nodes that are Primary cluster heads')
% ylabel('Maximum difference')
% 
% 
% ratio(1)=ratio(end);
% figure(2)
% plot(0:5:100,Ratio);


AggPacketRecvEnergy(1)=AggPacketRecvEnergy(end);
Agg_n=AggPacketRecvEnergy/max(AggPacketRecvEnergy);

figure(1)
plot(0:5:100,Agg_n)
xlabel('Percentage of nodes that are secondary cluster heads')
ylabel('Normalized energy dissipation')

% figure(1)
% plot(cumsum(PACKETS_TO_BS),'b-')
% hold on
% % legend('TL-LEACH','LEACH')
% xlabel('Time(rounds) (Fig 7(a) TWC)')
% ylabel('Number of data signals received at the base station')
% 
% figure(2)
% plot(AggPacketRecvEnergy,cumsum(PACKETS_TO_BS),'b--')
% hold on
% % legend('TL-LEACH','LEACH')
% xlabel('Energy(J)(Fig 7(b) TWC)')
% ylabel('Number of data signals received at the base station')
% 
% figure(3)
% plot(100*ones(1,rmax)-DEAD,'b-')
% hold on
% % legend('TL-LEACH','LEACH')
% xlabel('Time(rounds) (Fig 8(a) TWC)')
% ylabel('Number of nodes alive')
% 
% figure(4)
% plot(cumsum(PACKETS_TO_BS),100*ones(1,rmax)-DEAD,'b--')
% hold on
% % legend('TL-LEACH','LEACH')
% xlabel('Number of data items received at BS (Fig 8(b) TWC)')
% ylabel('Number of nodes alive')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   STATISTICS    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                                     %
%  DEAD  : a rmax x 1 array of number of dead nodes/round 
%  CLUSTERHS : a rmax x 1 array of number of Cluster Heads/round
%  PACKETS_TO_BS : a rmax x 1 array of number packets send to Base Station/round
%  PACKETS_TO_CH : a rmax x 1 array of number of packets send to ClusterHeads/round
%  first_dead: the round where the first node died                   
%                                                                                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

