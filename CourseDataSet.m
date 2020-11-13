function CrseData = CourseDataSet()

   CrseData = xlsread('2018LincolnEndurance.xlsx');   %Read Course Data as set of X,Y Coordinates from excel
    
   CrseData = CrseData.*0.3;
   
    n = 5000;
    bn = 0.005*n;
    
    t = 1:length(CrseData(:,1));
    xy = [transpose(CrseData(:,1));transpose(CrseData(:,2))];
    pp = csaps(t,xy);
    tInterp = linspace(1,length(CrseData(:,1)),n);
    xyInterp = ppval(pp, tInterp);
    
    figure
    plot(CrseData(:,1),CrseData(:,2),'o:')
    hold on
    plot(xyInterp(1,:),xyInterp(2,:),'r.')
    legend({'Original data','Spline interpolation'},'FontSize',12)
    axis('equal');
    hold off
    
   CrseData = transpose(xyInterp);
   
                           
   CrseData(1,3) = Inf;
  

    
for i = 2:(length(CrseData) - 1)                % Cycles through all course data and determines the radius and instantaneous center of each segment

   [R,xcyc] = fit_circle([CrseData(i-1,1) CrseData(i-1,2);CrseData(i,1) CrseData(i,2);CrseData(i+1,1) CrseData(i+1,2)]);
   Slength = sectorL(CrseData(i,1), CrseData(i,2), CrseData(i+1,1), CrseData(i+1,2));   %Runs sector length function and writes to CrseData
   
%     if R>200                                        %Sets a threshold where any radius above this is classified as a straight (ie. R=Inf)
%         CrseData(i,3) = Inf;
%     else
        CrseData(i,3) = R;                          %Otherwise radius is set to calculated
%     end
   
   CrseData(i-1,4) = Slength;
   CrseData(i,5:6) = xcyc;
     
end
  
CrseData(:,3) = smooth(CrseData(:,3),bn);                                 %Smooths radius data based on moving aver with with bucket size of 3

for i = 2:(length(CrseData)-1)
   
    if CrseData(i,3) > 180
        CrseData(i,3) = Inf;
    end
    
end


figure
plot(CrseData(:,1), CrseData(:,2),'b');
figure
plot(1:length(CrseData), CrseData(:,3),'r');


  CrseData(1,7) = 0;                                           %Sets the values for direction vector and dtheta for the first segment
  CrseData(1,8) = 1;
  CrseData(1,9) = 0;
   
  
  
  

  
 for i = 2:length(CrseData)     
     
   %Loops through the course data to determine the direction unit vector
        
       if CrseData(i,3) == inf                                  %if the radius is infinite (ie a straight) a different algorith for determining vector is used
         
           xvec = CrseData(i+1,1) - CrseData(i,1);              %Calculates x and y components of vector
           yvec = CrseData(i+1,2) - CrseData(i,2);
           mag = sqrt(yvec^2 + xvec^2);                         %Calculates magnitude so vector can be normalized
           CrseData(i,7) = xvec/mag;
           CrseData(i,8) = yvec/mag;
           
       else
           
            yvec = CrseData(i,2) - CrseData(i,6);               %Otherwise direction vector is the vector perpendicular to vector from center of point
            xvec = CrseData(i,1) - CrseData(i,5);
            mag = sqrt(yvec^2 + xvec^2);
            CrseData(i,7) = yvec/mag;
            CrseData(i,8) = -1*(xvec/mag);
            
       end
        if i ~= 1                                                               %Determines unit vector direction based off whether different in angle between previous is greater than 90
       
            dtheta = atan2d(CrseData(i-1,7)*CrseData(i,8) - CrseData(i-1,8)*CrseData(i,7), CrseData(i-1,7)*CrseData(i,7) + CrseData(i-1,8)*CrseData(i,8));
        
        end 
        
        dtheta = abs(dtheta);
        
        if dtheta >= 90
            
            CrseData(i,7) = -1*(yvec/mag);
            CrseData(i,8) = xvec/mag;
            
        end
        
        CrseData(i,9) = deg2rad(atan2d(CrseData(i-1,7)*CrseData(i,8) - CrseData(i-1,8)*CrseData(i,7), CrseData(i-1,7)*CrseData(i,7) + CrseData(i-1,8)*CrseData(i,8)));
        
 end
 
 LapLength = sum(CrseData(:,4));

 
%    figure
%    quiver(CrseData(:,1),CrseData(:,2),CrseData(:,7),CrseData(:,8))  

%save('2018LincolnEndurance.mat','CrseData');
 
 display(LapLength)
 
end

   
 







% B = smooth(CrseData(:,3),3);                                 %Smooths radius data based on moving aver with with bucket size of 3
%     CrseData(:,3) = B;
% 
% k = 1;
% %ICrseData(k,1:2) = CrseData(1,1:2);
% 
% ref = [1,0];
% i = 2;
% % for i = 2:(length(CrseData)-1)
%     
%     posN(1,1:2) = CrseData(i-1, 1:2) - CrseData(i,5:6)
%     posN(2,1:2) = CrseData(i,1:2) - CrseData(i, 5:6)
%     posN(3,1:2) = CrseData(i+1, 1:2) - CrseData(i,5:6)
%     
%     thetaN(1) = acos(dot(posN(1,1:2),ref)/(norm(ref)*norm(posN(1,1:2))));
%     thetaN(2) = acos(dot(posN(2,1:2),ref)/(norm(ref)*norm(posN(2,1:2))));
%     thetaN(3) = acos(dot(posN(3,1:2),ref)/(norm(ref)*norm(posN(3,1:2))));
%     
%     for m = 1:3
%        if posN(m,2) < 0 thetaN(m) = 2*pi - thetaN(m); end
%     end
%     %thetaN = [atan(posN(1,2)/posN(1,1)), atan(posN(2,2)/posN(2,1)), atan(posN(3,2)/posN(3,1))]
%     
%     dtheta = (thetaN(2) - thetaN(3))/d;
%     ICrseData(k,1:2) = CrseData(i,1:2);
%     k=k+1;
%     
%     for j = 1:3
%          
%         ICrseData(k,1) = CrseData(i,3)*cos(thetaN(2)-dtheta*j) + CrseData(i,5);
%         ICrseData(k,2) = CrseData(i,3)*cos(thetaN(2)-dtheta*j) + CrseData(i,6);
%         k=k+1;
%          
%     end
%       
% % end
% 
% 
% scatter(ICrseData(:,1), ICrseData(:,2),'r')
% hold on;
% %scatter(CrseData(:,1), CrseData(:,2),'b')





