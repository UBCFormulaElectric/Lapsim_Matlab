function [ThermalData, SectorData] = PhysicsModel_V3_1wheel(CP, AP)


rho = 1.225;



%%%%%%%%%%%  Runniing Initializing Functions  %%%%%%%%%%%%
    CourseData = CourseDataSet();   %Sets course cords. and raduis 
    [CfdragT, CfdownT] = AeroMap(AP); %Call to aeromap function which combines the effects of drag and downforce from each individual element
   CourseData(:,3);

    %Car Parameter is an array containing important car information
    % First Row : TireCf
    % Second Row : CarMass
    % Third Row : Rtire
    % Fourth Row : Pmax
    % Fifth Row : Tmax
    % Sixth Row : Drive Ratio
    % Seventh Row CG coords : x,y
    % Eighth Row Rear Axle coords : x
  
    %Aero Parameter is an array containing the 
    % First Row : Cfdragbdy
    % Second Row : Afbdy
    % Third Row : CfdragFW
    % Fourth Row : CfdownFW
    % Fifth Row : AfFW
    % Sixth Row : CfdragRW
    % Seventh Row : CfdownRW
    % Eigth Row : AfRW
    % Ninth Row : Center of Pressure (x,y)
    
    %CourseData is an array containing information about the track data 
    % Firt Column : X - Coordinates of track
    % Second Column : Y - Coordinates of track
    % Third Column : Instantateous radius of the track at that point
    % Fourth Column : Legnth of sector, of the i to i+1 data point
    % Fifth Column : Center of Circle Column : X
    % Sixth Column : Center of Cricle Column : Y
    % Seventh Column : Direction Vector  Column : X
    % Eighth Column : Direction Vector Column : Y
    % Ninth Column : Angle between Sector(i) and (i-1) 
    
    %SectorData is an array containing information about the entry and exit
    %speeds of each ector
    %First Column : Velocity at each point assuming Only acceleration force
    %Second Column : Velocity at each point asusming only braking force
    %Thrid Column : Combined velocity profiles
    %Fourth Column : Distance meter from start of course
    %Fifth Column : Individual Time of the segment i to i+1
    %Sixth Column : Power/sector

    %ForceData is an array containing information about the forces acting on the vehicle and each sector
    %First Column : Ffx
    %Second Colimn : Ffy
    %Third Column : Ffz
    %Fourth Column : Frx
    %Fifth Column : Fry
    %Sixth Column : Frz
    %Seventh Column : Fd
    %Eigth Column : Fl
    %Ninth Column : Fa
    
    Fdrag1 = 1/2*rho*CfdragT;   %Calculates Fdrag prime which is simply the collection of constants such that Drag Force = Fdrag1*Velocity^2 
    Fdown1 = 1/2*rho*CfdownT;
    
  
SectorData = zeros(length(CourseData),6); 
% ForceDataAccel = zeros(length(CourseData),9);
% ForceDataBrake = 
SectorData(1,1) = 0;
SectorData(2,1) = 0;
ForceDataAccel(1,4) = 0;
ForceDataAccel(2,4) = 0;
Ffz = 1/2*CP.CarMass*9.81;
Frz = 1/2*CP.CarMass*9.81;


for i = 2:(length(CourseData)-1)
   
    Fcmax = CP.CarMass*9.81*CP.TireCf;
    Fc = CP.CarMass*(SectorData(i,1)^2)/CourseData(i,3);         %Calculates Current Sector Centripedal Force given incoming velocity
    Frt = (CP.CarMass*9.81/2)*CP.TireCf;
    Fft = (CP.CarMass*9.81/2)*CP.TireCf;
    
    if Fc > Fcmax
        
       Fc = Fcmax ;
       SectorData(i,1) = sqrt(CP.TireCf*9.81*CourseData(i,3));
       Ffy = Fc/2;
       Fry = Fc/2;
       Ffx = 0;
       Frx = 0;
     
    
    else
        
        Ffy = Fc/2;
        Fry = Fc/2;
        Ffx = 0;
        Frx = sqrt(Frt^2 - Fry^2);
    
    end
     
    Fd = Fdrag1*SectorData(i-1,1)^2;
    Fr = CP.ResCf*SectorData(i-1,1);
   
      Fa = -Fr - Fd + Ffx + Frx;

    Accel = Fa/CP.CarMass;
    
    ForceDataAccel(i,1) = Ffx;
    ForceDataAccel(i,2) = Ffy;
    ForceDataAccel(i,3) = Ffz;
    ForceDataAccel(i,4) = Frx;
    ForceDataAccel(i,5) = Fry;
    ForceDataAccel(i,6) = Frz;
    ForceDataAccel(i,7) = Fd;
    %ForceData(i,8) = Fl;
    %ForceData(i,9) = Accel*CarPar.CarMass;
    
    SectorData(i+1,1) = sqrt(SectorData(i,1)^2 + 2*Accel*CourseData(i,4));
    
end



for i = 2:length(CourseData)
   
    SectorData(i,4) = SectorData(i-1,4) + CourseData(i,4);
    
end



   
    
    
    SectorData(length(CourseData),2) = SectorData(length(CourseData),1);   %Sets the start velocity of the braking profile to the end of the accel profile
 
    for i = length(CourseData)-1:-1:2
        
    Fcmax = CP.CarMass*9.81*CP.TireCf;
    Fc = CP.CarMass*(SectorData(i,2)^2)/CourseData(i,3);         %Calculates Current Sector Centripedal Force given incoming velocity
    Frt = (CP.CarMass*9.81/2)*CP.TireCf;
    Fft = (CP.CarMass*9.81/2)*CP.TireCf;
     
    if Fc > Fcmax
        
       Fc = Fcmax; 
       SectorData(i,2) = sqrt(CP.TireCf*9.81*CourseData(i,3));
       Ffy = Fc/2;
       Fry = Fc/2;
       Ffx = 0;
       Frx = 0;
     
    
    else
        
        Ffy = Fc/2;
        Fry = Fc/2;
        Ffx = -sqrt(Fft^2 - Ffy^2);
        Frx = -sqrt(Frt^2 - Fry^2);
    
    end
     
    Fd = Fdrag1*SectorData(i+1,2)^2;
    Fr = CP.ResCf*SectorData(i+1,2);
   
      Fa = - Fr - Fd - Ffx - Frx; 

    Accel = Fa/CP.CarMass;
    
     ForceDataBrake(i,1) = Ffx;
     ForceDataBrake(i,2) = Ffy;
     ForceDataBrake(i,3) = Ffz;
     ForceDataBrake(i,4) = Frx;
     ForceDataBrake(i,5) = Fry;
     ForceDataBrake(i,6) = Frz;
     ForceDataBrake(i,7) = Fd;
     %ForceData(i,8) = Fl;
    %ForceData(i,9) = Accel*CarPar.CarMass;
    
    SectorData(i-1,2) = sqrt(SectorData(i,2)^2 + 2*Accel*CourseData(i-1,4));
     
                
    end
 
      for i = 1:(length(CourseData)-2)
          
        SectorData(i,3) = min([SectorData(i,1) SectorData(i,2)]); 
        
        if SectorData(i,1)<= SectorData(i,2)
            
            ThermalData(i,1) = ForceDataAccel(i,4);
            
        else
            
            ThermalData(i,1) = 0;
            
        end
        
        ThermalData(i,2) = ThermalData(i,1)*SectorData(i,3)/CP.MechEff;  %Power calculation
        ThermalData(i,3) = SectorData(i,3);
        
        
     end
     
     
%       
%     [TotalP,SectorData] = Power(CourseData,SectorData,CarMass);
%  
    
    SectorData = SectorData(1:length(ThermalData),:);    %Truncates the sector data array as the last couple of data points don't have force data to match
    [TotalT, SectorData] = ElapTime(CourseData,SectorData);
    LapLength = sum(CourseData(:,4))
    
    ThermalData(:,4) = ThermalData(:,2).*SectorData(:,5);
    
    LapEnergy =  sum(ThermalData(:,4))
    
%     figure,
%     yyaxis left;
%     plot(SectorData(:,4),SectorData(:,3),'b');
%     hold on;
%     %plot(SectorData(:,4),SectorData(:,1),'r');
%     %plot(SectorData(:,4),SectorData(:,2),'g');
%     title('Velocity Trace','fontsize',36)
%     xlabel('Distance (m)','fontsize',36) % x-axis label
%     ylabel('Velocity (m/s)','fontsize',36) % y-axis label
%     
%     
%     
%      yyaxis right;
%      plot(SectorData(:,4), ThermalData(:,2), 'r');
%      hold off;
%    
    
  
end
