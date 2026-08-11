function CrseData = RefineTrack(CrseData, minSegLength)

   %CrseData = xlsread('AutoXdata.xlsx','AutoX2015','A2:B151');   %Read Course Data as set of X,Y Coordinates from excel
 
                           
   %CrseData(1,3) = Inf;
   

%     
% for i = 2:(length(CrseData) - 1)                % Cycles through all course data and determines the radius and instantaneous center of each segment
% 
%    [R,xcyc] = fit_circle([CrseData(i-1,1) CrseData(i-1,2);CrseData(i,1) CrseData(i,2);CrseData(i+1,1) CrseData(i+1,2)]);
%    Slength = sectorL(CrseData(i,1), CrseData(i,2), CrseData(i+1,1), CrseData(i+1,2));   %Runs sector length function and writes to CrseData
%    
%     if R>200                                        %Sets a threshold where any radius above this is classified as a straight (ie. R=Inf)
%         CrseData(i,3) = Inf;
%     else
%         CrseData(i,3) = R;                          %Otherwise radius is set to calculated
%     end
%    
%    CrseData(i-1,4) = Slength;
%    CrseData(i,5:6) = xcyc;
%      
% end
%   
% %B = smooth(CrseData(:,3),3);                                 %Smooths radius data based on moving aver with with bucket size of 3
%  CrseData(:,3) = B;


%scatter(CrseData(:,1), CrseData(:,2),'b');

segLength = minSegLength + 1;

while segLength >= minSegLength
    
    
     CrseData(1,3) = Inf;
  
for i = 1:(length(CrseData) - 2)                % Cycles through all course data and determines the radius and instantaneous center of each segment

   [R,xcyc] = fit_circle([CrseData(i,1) CrseData(i,2);CrseData(i+1,1) CrseData(i+1,2);CrseData(i+2,1) CrseData(i+2,2)]);
   Slength = sectorL(CrseData(i,1), CrseData(i,2), CrseData(i+1,1), CrseData(i+1,2));   %Runs sector length function and writes to CrseData
   
    if R>200                                        %Sets a threshold where any radius above this is classified as a straight (ie. R=Inf)
        CrseData(i,3) = Inf;
    else
        CrseData(i,3) = R;                          %Otherwise radius is set to calculated
    end
   
   CrseData(i,4) = Slength;
   CrseData(i,5:6) = xcyc;
     
end
    
   
k = 1;
ref = [1,0];
DataLength = length(CrseData);


for i = 2:(DataLength-1)

    
    posN(1,1:2) = CrseData(i,1:2) - CrseData(i, 5:6);          % Normalize position of point i to origin
    posN(2,1:2) = CrseData(i+1, 1:2) - CrseData(i,5:6);         % Normalize position of point i+1 to origin

    thetaN(1) = acos(dot(posN(1,1:2),ref)/(norm(ref)*norm(posN(1,1:2))));   % Angle of i to ref [1,0]
    thetaN(2) = acos(dot(posN(2,1:2),ref)/(norm(ref)*norm(posN(2,1:2))));   % Angle of i+1 to ref
    
    for m = 1:2                                                    % Makes sure all angles are measured counter-clockwise
       if posN(m,2) < 0 thetaN(m) = 2*pi - thetaN(m); end
    end
    
    if posN(1,1) > 0 && posN(1,2)*posN(2,2)< 0             % Checks for scenario when one point is above the x-axis and the other below in the Right half plane
       if posN(1,2) > 0 
           thetaN(1) = thetaN(1)+2*pi;
       elseif posN(2,2) > 0 
           thetaN(2) = thetaN(2)+2*pi;
       end
           
    end
    
    
    ICrseData(k,:) = CrseData(i,:);
    k=k+1;
    
     if CrseData(i,3) == Inf 
         
         p = [CrseData(i,1) + (CrseData(i+1,1)-CrseData(i,1))/2, CrseData(i,2) + (CrseData(i+1,2)-CrseData(i,2))/2];    % Linear interpolation along straights
         ICrseData(k,1:2) = p;
         
%          HoldCrseData = CrseData;
%          CrseData(i+1,1:2) = p;
%          CrseData(i+2:end,:) = HoldCrseData(i+1:(end-1),:);
%          CrseData(end+1,:) = HoldCrseData(end,:);
         
     else
         
         dtheta = (thetaN(2) - thetaN(1))/2;
         
         p = [CrseData(i,3)*cos(thetaN(1)+dtheta) + CrseData(i,5), CrseData(i,3)*sin(thetaN(1)+dtheta) + CrseData(i,6)];  % Interpolation based on instantaneous radius
         ICrseData(k,1:2) = p;
         
%          HoldCrseData = CrseData;
%          CrseData(i+1,1:2) = p;
%          CrseData(i+2:end,:) = HoldCrseData(i+1:(end-1),:);
%          CrseData(end+1,:) = HoldCrseData(end,:);
         
     end
     k = k+1;
end



 segLength = mean(CrseData(:,4));
 
 if segLength >= minSegLength
     CrseData = ICrseData;
 end     
 
end
 
  figure;
 scatter(CrseData(:,1), CrseData(:,2),'r.');

B = smooth(CrseData(:,3),3);                                 %Smooths radius data based on moving aver with with bucket size of 3
CrseData(:,3) = B;
 


figure;
plot(1:length(CrseData),CrseData(:,3)) 
 



end

   
 





