clear all
syms teta alpha d a  
syms teta1 teta2 teta3 teta4 teta5 teta6
syms l0 loffset l1 l2 l3 d3
syms nx ny nz tx ty tz bx by bz px py pz
link_no=6;  %assign number of links for manipulator
T_link_all = []; %array where all T matrices of each link will be concatenated.


%Assume the following linik lengths in meters (from IEEE paper for PUMA 600(listed as reference): 
lo = .660;
loffset = .149;
l1 = .432;
l2 = .432;
l3 = .05639;


%This portion of the code below is for inverse kinematics of PUMA 600

%Given T-End Effector
T_EF=[0.8750 -0.4330 0.2165 -0.0378; -0.2165 -0.7500 -0.6250 0.1762; 0.4330 0.5000 -0.7500 0.4596; 0 0 0 1]

%initialize matrix that will contain teta values for all solutions
teta_values = [];

num_sol = 8; %all teta value equations (6 equations) are COS in form, so total combination is 64. We use 8 here to compute teta 1,2 and 3 combinations first. 2^3=8

for n = 1:num_sol
    switch n
        case 1
            teta1_sign= 1; teta2_sign=1; teta3_sign=1;
        case 2
            teta1_sign= 1; teta2_sign=1; teta3_sign=-1;
        case 3
            teta1_sign= 1; teta2_sign=-1; teta3_sign=1;
        case 4
            teta1_sign= 1; teta2_sign=-1; teta3_sign=-1;
        case 5
            teta1_sign= -1; teta2_sign=-1; teta3_sign=-1;
        case 6
            teta1_sign= -1; teta2_sign=1; teta3_sign=1;
        case 7
            teta1_sign= -1; teta2_sign=1; teta3_sign=-1;
        otherwise
            teta1_sign= -1; teta2_sign=-1; teta3_sign=1;
    end

    a1 = (l3*T_EF(2,3)) - T_EF(2,4); %equation 1.3 at documentation
    b1 = T_EF(1,4)-(l3*T_EF(1,3)); %equation 1.4 at documentation
    c1 = -loffset; %equation 1.5 at documentation

    %compute for teta1 using general equation of acos(x)+bsin(x)=c for
    %equation 1.3 at documentation
    teta1_solved = (teta1_sign*acosd(c1/(sqrt(a1^2+b1^2))))+atan2d(b1,a1); % Eq. 1.2

    a2 = T_EF(2,4)*sind(teta1_solved)- l3*T_EF(1,3)*cosd(teta1_solved) + l3*T_EF(2,3)*sind(teta1_solved) + T_EF(1,4)*cosd(teta1_solved); %Eq. 1.10 at documentation
    b2 = T_EF(3,4) - l3*T_EF(3,3) -lo; %Eq. 1.11 at documentation
    c2 = (a2^2 +b2^2 +(l1^2) - (l2^2)) / (2*l1); %Eq. 1.12 at documentation

    %compute for teta2 using general equation of acos(x)+bsin(x)=c for
    %equation 2.0
    teta2_solved = (teta2_sign*acosd(c2/(sqrt(a2^2+b2^2))))+atan2d(b2,a2); %Eq. 1.9


    %compute for teta3
    teta3_solved =(teta3_sign*acosd(((l1*sind(teta2_solved)-b2))/l2)) - teta2_solved; %Eq.1.13 at documentation

    %Solve for T3_6 Homogenous Matrix with computed teta1, teta2 and teta3
    %values

    T_link_U_all = [];

    for m= 1:3 %for loop to calculate T0_1, T0_2 and T0_3 of manipulator
    %if else statement for assigning values to T matrix from DH table
      if m==1
        teta=teta1_solved; alpha=90; d=lo; a=0;
      elseif m==2
        teta=teta2_solved; alpha=0; d=-loffset; a=l1;
      else
        teta=teta3_solved; alpha=90; d=0; a=0;      
      end

      T1=[cosd(teta) -sind(teta)*cosd(alpha) sind(teta)*sind(alpha) a*cosd(teta)]; %this is the 1st row of T matrix using DH notation
      T2=[sind(teta) cosd(teta)*cosd(alpha) -cosd(teta)*sind(alpha) a*sind(teta)]; % this is the 2nd row of T matrix using DH notation
      T3=[0 sind(alpha) cosd(alpha) d]; %this is the 3rd row of T matrix using DH notation
      T4=[0 0 0 1]; %this is the 4th row of T matrix using DH notation
      T_link=[T1; T2; T3; T4]; %build T matrix for the link
     if m~= 1
      T_link_U = T_link_U*T_link; %perform dot product of resulting T matrix with previous iteration T matrix.
     else
    T_link_U = T_link;
     end
     T_link_U_all = [T_link_U_all T_link_U];
    end

    T0_1_up = T_link_U_all(1:4,1:4);
    T0_2_up = T_link_U_all(1:4,5:8);
    T0_3_up = T_link_U_all(1:4,9:12);

    T3_6_up = inv(T0_3_up)*T_EF; %Get T3_6 in terms of T_EF Eq.1.16

    %Solve for remaining teta angles teta 4, teta 5 and teta 6 by getting
    %all possible solutions using solved teta 1, teta 2 and teta 3
    for m = 1:num_sol
        switch m
            case 1
                teta4_sign= 1; teta5_sign=1; teta6_sign=1;
            case 2
                teta4_sign= 1; teta5_sign=1; teta6_sign=-1;
            case 3
                teta4_sign= 1; teta5_sign=-1; teta6_sign=1;
            case 4
                teta4_sign= 1; teta5_sign=-1; teta6_sign=-1;
            case 5
                teta4_sign= -1; teta5_sign=-1; teta6_sign=-1;
            case 6
                teta4_sign= -1; teta5_sign=1; teta6_sign=1;
            case 7
                teta4_sign= -1; teta5_sign=1; teta6_sign=-1;
            otherwise
                teta4_sign= -1; teta5_sign=-1; teta6_sign=1;
            end
    
         %compute for teta5
         teta5_solved = teta5_sign*acosd(T3_6_up(3,3)); %eq.1.17

        %compute for teta4
        teta4_solved = teta4_sign*acosd(T3_6_up(1,3)/sind(teta5_solved)); %eq.1.18

        %compute for teta6
        teta6_solved = teta6_sign*acosd(-T3_6_up(3,1)/sind(teta5_solved)); %eq. 1.19

        teta_values = [teta_values; teta1_solved teta2_solved teta3_solved teta4_solved teta5_solved teta6_solved];
    end
end
teta_values; %this is the collection of all teta angle solution sets computed


%Check if each solution set is valid by plugging the teta angles calculated to forward kinematic
%homogenous matrix code from Q1A:

teta_values_up=[];
for i=1:size(teta_values,1)
    teta_values_current = teta_values(i,:);
    %check if solution is valid or not
    for n= 1:link_no  %for loop to calculate T of manipulator
     %if else statement for assigning values to T matrix from DH table
        if n==1
            teta=teta_values_current(1); alpha=90; d=lo; a=0;
        elseif n==2
            teta=teta_values_current(2); alpha=0; d=-loffset; a=l1;
        elseif n==3
            teta=teta_values_current(3); alpha=90; d=0; a=0;      
        elseif n==4
           teta=teta_values_current(4); alpha=-90; d=l2; a=0;
        elseif n==5
          teta=teta_values_current(5); alpha=90; d=0; a=0;
        else
         teta=teta_values_current(6); alpha=0; d=l3;  a=0;
        end
    
        T1=[cosd(teta) -sind(teta)*cosd(alpha) sind(teta)*sind(alpha) a*cosd(teta)]; %this is the 1st row of T matrix using DH notation
        T2=[sind(teta) cosd(teta)*cosd(alpha) -cosd(teta)*sind(alpha) a*sind(teta)]; % this is the 2nd row of T matrix using DH notation
        T3=[0 sind(alpha) cosd(alpha) d]; %this is the 3rd row of T matrix using DH notation
        T4=[0 0 0 1]; %this is the 4th row of T matrix using DH notation
        T_link=[T1; T2; T3; T4]; %build T matrix for the link
        T_link_all=[T_link_all T_link]; %concatenate all T links into 1 array
        if n~= 1
            T_manipulator = T_manipulator*T_link; %perform dot product of resulting T matrix with previous iteration T matrix.
        else
            T_manipulator = T_link;
        end
    end
    T_manipulator;

     
% Compare T_End effector Matrix from inverse kinematics input and T matrix
% of angle sets by chcking if the difference of their elements are less
% than 0.1
    T_diff_logic_all=[];
    for j=1:4
        for k=1:4
            T_diff_logic= abs(T_EF(j,k)-T_manipulator(j,k))<0.1;
            T_diff_logic_all = [T_diff_logic_all T_diff_logic];
        end
    end

    if all(T_diff_logic_all) == true
        teta_values_up=[teta_values_up; teta_values_current];
    end
end
teta_values_up % add all valid solution set of angles to this matrix

%Plot all valid solutions:
for p=1:size(teta_values_up,1);
    teta_values_plot=teta_values_up(p,:);
     T_link_U_all = [];
         for o= 1:link_no %for loop to calculate T0_1, T0_2, T0_3, T0_4, T0_5 and T0_6 of angle set solution for plotting
        %if else statement for assigning values to T matrix from DH table
             if o==1
                teta=teta_values_plot(1); alpha=90; d=lo; a=0;
            elseif o==2
                teta=teta_values_plot(2); alpha=0; d=-loffset; a=l1;
            elseif o==3
                teta=teta_values_plot(3); alpha=90; d=0; a=0;      
            elseif o==4
                teta=teta_values_plot(4); alpha=-90; d=l2; a=0;
            elseif o==5
                teta=teta_values_plot(5); alpha=90; d=0; a=0;
            else
                teta=teta_values_plot(6); alpha=0; d=l3;  a=0;
            end
    
          T1=[cosd(teta) -sind(teta)*cosd(alpha) sind(teta)*sind(alpha) a*cosd(teta)]; %this is the 1st row of T matrix using DH notation
          T2=[sind(teta) cosd(teta)*cosd(alpha) -cosd(teta)*sind(alpha) a*sind(teta)]; % this is the 2nd row of T matrix using DH notation
          T3=[0 sind(alpha) cosd(alpha) d]; %this is the 3rd row of T matrix using DH notation
          T4=[0 0 0 1]; %this is the 4th row of T matrix using DH notation
          T_link=[T1; T2; T3; T4]; %build T matrix for the link
          if o~= 1
            T_link_U = T_link_U*T_link; %perform dot product of resulting T matrix with previous iteration T matrix.
          else
            T_link_U = T_link;
          end
            T_link_U_all = [T_link_U_all T_link_U];
        end

        T0_1_up=T_link_U_all(1:4,1:4);
        T0_2_up=T_link_U_all(1:4,5:8);
        T0_3_up=T_link_U_all(1:4,9:12);
        T0_4_up=T_link_U_all(1:4,13:16);
        T0_5_up=T_link_U_all(1:4,17:20);
        T0_6_up=T_link_U_all(1:4,21:24);
        
        %Plot Solution for this iteration
        name = strcat('Plot of Solution','_',string(p));
        figure('Name',name);
    
        %Subplot for Y-Z Axis
        subplot(3,1,1);
    
    
        %plot frame 0 to frame 1
        pos_joints_y = [0 T0_1_up(2,4)];
        pos_joints_z = [0 T0_1_up(3,4)]; 
        plot(pos_joints_y,pos_joints_z,'r-')
        hold on
        
        %plot frame 1 to frame 2
        pos_joints_y = [T0_1_up(2,4) T0_2_up(2,4)];
        pos_joints_z = [T0_1_up(3,4) T0_2_up(3,4)]; 
        plot(pos_joints_y,pos_joints_z,'b-')
        hold on
    
        %plot frame 2 to frame 3
        pos_joints_y = [T0_2_up(2,4) T0_3_up(2,4)];
        pos_joints_z = [T0_2_up(3,4) T0_3_up(3,4)]; 
        plot(pos_joints_y,pos_joints_z,'y-')
        hold on
    
        %plot frame 3 to frame 4
        pos_joints_y = [T0_3_up(2,4) T0_4_up(2,4)];
        pos_joints_z = [T0_3_up(3,4) T0_4_up(3,4)]; 
        plot(pos_joints_y,pos_joints_z,'m-')
        hold on
    
        %plot frame 4 to frame 5
        pos_joints_y = [T0_4_up(2,4) T0_5_up(2,4)];
        pos_joints_z = [T0_4_up(3,4) T0_5_up(3,4)]; 
        plot(pos_joints_y,pos_joints_z,'g-')
        hold on
    
        %plot frame 5 to frame 6
        pos_joints_y = [T0_5_up(2,4) T0_6_up(2,4)];
        pos_joints_z = [T0_5_up(3,4) T0_6_up(3,4)]; 
        plot(pos_joints_y,pos_joints_z,'k-')
        hold on
    
        %plot end effector location
        pos_joints_y = [T_EF(2,4)];
        pos_joints_z = [T_EF(3,4)];
        plot(pos_joints_y,pos_joints_z,'o-')
    
           %plot joints location
        pos_joints_y = [0];
        pos_joints_z = [0];
        plot(pos_joints_y,pos_joints_z,'o-')
        text(pos_joints_y,pos_joints_z,'joint 1')
    
        pos_joints_y = [T0_1_up(2,4)];
        pos_joints_z = [T0_1_up(3,4)];
        plot(pos_joints_y,pos_joints_z,'o-')
        text(pos_joints_y,pos_joints_z,'joint 2')
    
        pos_joints_y = [T0_2_up(2,4)];
        pos_joints_z = [T0_2_up(3,4)];
        plot(pos_joints_y,pos_joints_z,'o-')
        text(pos_joints_y,pos_joints_z,'joint 3')
    
        pos_joints_y = [T0_3_up(2,4)];
        pos_joints_z = [T0_3_up(3,4)];
        plot(pos_joints_y,pos_joints_z,'o-')
        text(pos_joints_y,pos_joints_z,'joint 4')
    
        pos_joints_y = [T0_4_up(2,4)];
        pos_joints_z = [T0_4_up(3,4)];
        plot(pos_joints_y,pos_joints_z,'o-')
        text(pos_joints_y,pos_joints_z,'joint 5')
    
        pos_joints_y = [T0_5_up(2,4)];
        pos_joints_z = [T0_5_up(3,4)];
        plot(pos_joints_y,pos_joints_z,'o-')
        text(pos_joints_y,pos_joints_z,'joint 6')
    
        title('Y-Z Axis Manipulator Orientation')
        xlabel('y axis in meters');
        ylabel('z axis in meters');
        axis([-.2 .5 -0.2 1]);
        legend('link 1','link 2','link 3', 'link 4', 'link 5', 'link 6','End-Effector Target');
    
        %Subplot for X-Y Axis
        subplot(3,1,2);
    
        %plot frame 0 to frame 1
        pos_joints_x = [0 T0_1_up(1,4)];
        pos_joints_y = [0 T0_1_up(2,4)]; 
        plot(pos_joints_y,pos_joints_x,'r-')
        hold on
    
         %plot frame 1 to loffset_origin
        pos_joints_x = [T0_1_up(1,4) -loffset*sind(teta_values_plot(1))];
        pos_joints_y = [T0_1_up(2,4) -loffset*cosd(teta_values_plot(1))]; 
        plot(pos_joints_y,pos_joints_x,'b-')
        hold on
    
        %plot loffset_origin to frame 2
        pos_joints_x = [-loffset*sind(teta_values_plot(1)) T0_2_up(1,4)];
        pos_joints_y = [-loffset*cosd(teta_values_plot(1)) T0_2_up(2,4)]; 
        plot(pos_joints_y,pos_joints_x,'b-')
        hold on
    
        %plot frame 2 to frame 3
        pos_joints_x = [T0_2_up(1,4) T0_3_up(1,4)];
        pos_joints_y = [T0_2_up(2,4) T0_3_up(2,4)]; 
        plot(pos_joints_y,pos_joints_x,'y-')
        hold on
    
        %plot frame 3 to frame 4
        pos_joints_x = [T0_3_up(1,4) T0_4_up(1,4)];
        pos_joints_y = [T0_3_up(2,4) T0_4_up(2,4)]; 
        plot(pos_joints_y,pos_joints_x,'m-')
        hold on
    
        %plot frame 4 to frame 5
        pos_joints_x = [T0_4_up(1,4) T0_5_up(1,4)];
        pos_joints_y = [T0_4_up(2,4) T0_5_up(2,4)]; 
        plot(pos_joints_y,pos_joints_x,'g-')
        hold on
    
        %plot frame 5 to frame 6
        pos_joints_x = [T0_5_up(1,4) T0_6_up(1,4)];
        pos_joints_y = [T0_5_up(2,4) T0_6_up(2,4)]; 
        plot(pos_joints_y,pos_joints_x,'k-')
        hold on
    
        %plot end effector location
        pos_joints_x = [T_EF(1,4)];
        pos_joints_y = [T_EF(2,4)];
        plot(pos_joints_y,pos_joints_x,'o-')
    
        %plot joints location
        pos_joints_x = [0];
        pos_joints_y = [0];
        plot(pos_joints_y,pos_joints_x,'o-')
        text(pos_joints_y,pos_joints_x,'joint 1')
    
        pos_joints_x = [T0_1_up(1,4)];
        pos_joints_y = [T0_1_up(2,4)];
        plot(pos_joints_y,pos_joints_x,'o-')
        text(pos_joints_y,pos_joints_x,'joint 2')
    
        pos_joints_x = [T0_2_up(1,4)];
        pos_joints_y = [T0_2_up(2,4)];
        plot(pos_joints_y,pos_joints_x,'o-')
        text(pos_joints_y,pos_joints_x,'joint 3')
    
        pos_joints_x = [T0_3_up(1,4)];
        pos_joints_y = [T0_3_up(2,4)];
        plot(pos_joints_y,pos_joints_x,'o-')
        text(pos_joints_y,pos_joints_x,'joint 4')
    
        pos_joints_x = [T0_4_up(1,4)];
        pos_joints_y = [T0_4_up(2,4)];
        plot(pos_joints_y,pos_joints_x,'o-')
        text(pos_joints_y,pos_joints_x,'joint 5')
    
        pos_joints_x = [T0_5_up(1,4)];
        pos_joints_y = [T0_5_up(2,4)];
        plot(pos_joints_y,pos_joints_x,'o-')
        text(pos_joints_y,pos_joints_x,'joint 6')
    
    
        title('X-Y Axis Manipulator Orientation')
        xlabel('y axis in meters');
        ylabel('x axis in meters');
        axis([-.2 .5 -0.2 1]);
        legend('link 1','loffset','loffset to frame 2', 'link 3', 'link 4', 'link 5','linik 6',"End-Effector Target");
    
        %Subplot for X-Z Axis
        subplot(3,1,3);
    
        %plot frame 0 to frame 1
        pos_joints_x = [0 T0_1_up(1,4)];
        pos_joints_z = [0 T0_1_up(3,4)]; 
        plot(pos_joints_x,pos_joints_z,'r-')
        hold on
    
         %plot frame 1 to loffset_origin
        pos_joints_x = [T0_1_up(1,4) -loffset*sind(teta_values_plot(1))];
        pos_joints_z = [T0_1_up(3,4) lo]; 
        plot(pos_joints_x,pos_joints_z,'b-')
        hold on
    
        %plot loffset_origin to frame 2
        pos_joints_x = [-loffset*sind(teta_values_plot(1)) T0_2_up(1,4)];
        pos_joints_z = [lo T0_2_up(3,4)]; 
        plot(pos_joints_x,pos_joints_z,'b-')
        hold on
    
        %plot frame 2 to frame 3
        pos_joints_x = [T0_2_up(1,4) T0_3_up(1,4)];
        pos_joints_z = [T0_2_up(3,4) T0_3_up(3,4)]; 
        plot(pos_joints_x,pos_joints_z,'y-')
        hold on
    
        %plot frame 3 to frame 4
        pos_joints_x = [T0_3_up(1,4) T0_4_up(1,4)];
        pos_joints_z = [T0_3_up(3,4) T0_4_up(3,4)]; 
        plot(pos_joints_x,pos_joints_z,'m-')
        hold on
    
        %plot frame 4 to frame 5
        pos_joints_x = [T0_4_up(1,4) T0_5_up(1,4)];
        pos_joints_z = [T0_4_up(3,4) T0_5_up(3,4)]; 
        plot(pos_joints_x,pos_joints_z,'g-')
        hold on
    
        %plot frame 5 to frame 6
        pos_joints_x = [T0_5_up(1,4) T0_6_up(1,4)];
        pos_joints_z = [T0_5_up(3,4) T0_6_up(3,4)]; 
        plot(pos_joints_x,pos_joints_z,'k-')
        hold on
    
        %plot end effector location
        pos_joints_x = [T_EF(1,4)];
        pos_joints_z = [T_EF(3,4)];
        plot(pos_joints_x,pos_joints_z,'o-')
    
        %plot joints location
        pos_joints_x = [0];
        pos_joints_z = [0];
        plot(pos_joints_x,pos_joints_z,'o-')
        text(pos_joints_x,pos_joints_z,'joint 1')
    
        pos_joints_x = [T0_1_up(1,4)];
        pos_joints_z = [T0_1_up(3,4)];
        plot(pos_joints_x,pos_joints_z,'o-')
        text(pos_joints_x,pos_joints_z,'joint 2')
    
        pos_joints_x = [T0_2_up(1,4)];
        pos_joints_z = [T0_2_up(3,4)];
        plot(pos_joints_x,pos_joints_z,'o-')
        text(pos_joints_x,pos_joints_z,'joint 3')
    
        pos_joints_x = [T0_3_up(1,4)];
        pos_joints_z = [T0_3_up(3,4)];
        plot(pos_joints_x,pos_joints_z,'o-')
        text(pos_joints_x,pos_joints_z,'joint 4')
    
        pos_joints_x = [T0_4_up(1,4)];
        pos_joints_z = [T0_4_up(3,4)];
        plot(pos_joints_x,pos_joints_z,'o-')
        text(pos_joints_x,pos_joints_z,'joint 5')
    
        pos_joints_x = [T0_5_up(1,4)];
        pos_joints_z = [T0_5_up(3,4)];
        plot(pos_joints_x,pos_joints_z,'o-')
        text(pos_joints_x,pos_joints_z,'joint 6')
    
        title('X-Z Axis Manipulator Orientation')
        xlabel('x axis in meters');
        ylabel('z axis in meters');
        axis([-.2 .5 -0.2 1]);
        legend('link 1','loffset','loffset to frame 2', 'link 3', 'link 4', 'link 5','linik 6',"End-Effector Target");


end
hold off;

