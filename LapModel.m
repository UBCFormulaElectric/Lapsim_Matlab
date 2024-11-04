function [SectorDataC, ForceDataC, TotalT, LapLength, EnergyUsed] = LapModel(CP,AP,CourseName)

%     CourseData is an array containing information about the track data
%     % Firt Column : X - Coordinates of track
%     % Second Column : Y - Coordinates of track
%     % Third Column : Instantateous radius of the track at that point
%     % Fourth Column : Legnth of sector, of the i to i+1 data point
%     % Fifth Column : Center of Circle Column : X
%     % Sixth Column : Center of Cricle Column : Y
%     % Seventh Column : Direction Vector  Column : X
%     % Eighth Column : Direction Vector Column : Y
%     % Ninth Column : Angle between Sector(i) and (i-1)
%
%
%
%     % SectorData(A,B,C) is an array containing information about the entry and exit
%     % speeds of each ector
%     % First Column : Velocity at each point  
%     % Second Column : Acceleration at each point 
%     % Third Column : Position at each point 
%     % Fourth Column : dt for segment i to i+1
%     % Fifth Column : Front Power for Segment
%     % Sixth Column : Rear Power for Segment
%     % Seventh Column :    

MotorLimit_500V = load("MotorLimit_500V.mat");
MotorLimit_500V = MotorLimit_500V.MotorLimit_500V;
CrseData = CourseName;
rho = 1.225;
[CfdragT, CfdownT] = AeroMap(AP); %Call to aeromap function which combines the effects of drag and downforce from each individual element

MotorLimitSpeed = 19900*(2*pi*CP.Rtire)/(60*CP.Nratio);

Fdrag1 = 1/2*rho*CfdragT;   %Calculates Fdrag prime which is simply the collection of constants such that Drag Force = Fdrag1*Velocity^2
Fdown1 = 1/2*rho*CfdownT;

% Sets initial conditions for acceleration profile
velA(1) = 0;
accelA(1) = 0;
posA(1) = 0;

% Initial front and rear wheel forces in the x direction
Ffx(1) = 0;
Frx(1) = 0;

% Calculates initial front and rear wheel forces in the z direction
a = [1 1 CP.CarMass*9.81+Fdown1*velA(1)^2; -(CP.WheelBase - CP.CG(1)) CP.CG(1) (Frx(1)+Ffx(1))*CP.CG(2)+Fdown1*velA(1)^2*(CP.CG(1) - AP.CP(1))+Fdrag1*velA(1)^2*(AP.CP(2) - CP.CG(2))];
b = rref(a);

Ffz(1) = b(1,3);
Frz(1) = b(2,3);

VmaxA(1) = 0; % Initial theoretical max velocity


for i = 2:length(CrseData)  % Loop through all track points with acceleration forces 
    
    
        
        a = [1 1 CP.CarMass*velA(i-1)^2/CrseData(i,3); -(CP.WheelBase-CP.CG(1)) CP.CG(1) 0];  % Calculates required lateral tire force for incoming velocity velA(i-1)
        b = rref(a);
        
        FfyReq = b(1,3);   % Required front and frear forces
        FryReq = b(2,3);
        
        VmaxF = sqrt(CP.TireCf*Ffz(i-1)*CP.WheelBase/CP.CG(1)*CrseData(i,3)/CP.CarMass);  % Calculates theoretical max velocity of this segment assuming front limited
        
        VmaxR = sqrt(CP.TireCf*Frz(i-1)*(1+CP.CG(1)/(CP.WheelBase-CP.CG(1)))*CrseData(i,3)/CP.CarMass); % Calculates theoreticl max velocity of this segment assuming rear limited
        
        [VmaxA(i), C] = min([VmaxF VmaxR]);  % Vmax is the theoretical max velocity for that sector, C = 1 for front limited, C=2 for rear limited
        
        
        if velA(i-1) > VmaxA(i)   % If incoming velocity is greater than the theoretical max velocity at this point 
            
            velA(i) = VmaxA(i);   % Set velocity of current segment to theoretical max
            accelA(i) = 0; %-Fdrag1*velA(i-1)^2/CP.CarMass; 
            
            if C == 1      % If front limited
                
                Ffy(i) = Ffz(i-1)*CP.TireCf;
                Fry(i) = Ffy(i)*(CP.WheelBase - CP.CG(1))/CP.CG(1);
                
            elseif C == 2   % If rear limited    
                
                Fry(i) = Frz(i-1)*CP.TireCf;
                Ffy(i) = Fry(i)*CP.CG(1)/(CP.WheelBase - CP.CG(1));
                
            end
            
            Frx(i) = 0; %1/2*Fdrag1*velA(i-1)^2; 
%             Ffx(i) = 0;
            Ffx(i) = 0; %1/2*Fdrag1*velA(i-1)^2;
            
        elseif velA(i-1) > MotorLimitSpeed
            
            velA(i) = MotorLimitSpeed;   % Set velocity of current segment to theoretical max
            accelA(i) = 0; %-Fdrag1*velA(i-1)^2/CP.CarMass; 
            
%             if C == 1      % If front limited
%                 
%                 Ffy(i) = Ffz(i-1)*CP.TireCf;
%                 Fry(i) = Ffy(i)*(CP.WheelBase - CP.CG(1))/CP.CG(1);
%                 
%             elseif C == 2   % If rear limited    
%                 
%                 Fry(i) = Frz(i-1)*CP.TireCf;
%                 Ffy(i) = Fry(i)*CP.CG(1)/(CP.WheelBase - CP.CG(1));
%                 
%             end
            Ffy(i) = FfyReq;
            Fry(i) = FryReq;

           
            Frx(i) = 0; %1/2*Fdrag1*velA(i-1)^2; 
           
            Ffx(i) = 0; %1/2*Fdrag1*velA(i-1)^2;  
        else
            Ffy(i) = FfyReq;
            Fry(i) = FryReq;
            
            %%% HERE
            Ffx(i) = sqrt((CP.TireCf*Ffz(i-1))^2-Ffy(i)^2);
            %Ffx(i) = 0;
            Frx(i) = sqrt((CP.TireCf*Frz(i-1))^2-Fry(i)^2);
            
            
            OutputPower(i) = (Ffx(i)+Frx(i))*velA(i-1);
            

            %% Uncomment From Here for 4wd %%%%
            WheelRpm = velA(i-1)*60/(2*pi*CP.Rtire);
            MotorRpm = WheelRpm*CP.Nratio;
            MaxWheelTorque = interp1(MotorLimit_500V(:,1), MotorLimit_500V(:,2),MotorRpm,'nearest')*CP.Nratio;
            
            if Ffx(i)*CP.Rtire > MaxWheelTorque*2
                Ffx(i) = MaxWheelTorque*2/CP.Rtire; 
            end
            
            if Frx(i)*CP.Rtire > MaxWheelTorque*2
                Frx(i) = MaxWheelTorque*2/CP.Rtire; 
            end
            
            if OutputPower(i) > CP.Pmax*CP.MechEff
                 d = (CP.Pmax*CP.MechEff)/(OutputPower(i));
                
                Ffx(i) = Ffx(i)*d;
                Frx(i) = Frx(i)*d;
            end
             
              accelA(i) = (Ffx(i) + Frx(i) - Fdrag1*velA(i-1)^2)/CP.CarMass;
              velA(i) = sqrt(velA(i-1)^2 + 2*accelA(i)*CrseData(i,4));  
            
        end
        %Ffx(i) = 0;
        %Frx(i) = 0;
        posA(i) = posA(i-1)+CrseData(i,4);
        
        
        a = [1 1 CP.CarMass*9.81+Fdown1*velA(i-1)^2; (CP.WheelBase - CP.CG(1)) -CP.CG(1) (Frx(i)+Ffx(i))*CP.CG(2)+Fdown1*velA(i-1)^2*(CP.CG(1) - AP.CP(1))+Fdrag1*velA(i-1)^2*(AP.CP(2) - CP.CG(2))];
        b = rref(a);
        
        Ffz(i) = b(1,3);
        Frz(i) = b(2,3);
        Fdrag(i) = Fdrag1*velA(i-1)^2;
  
    
end  



ForceDataA(:,1) = Ffz(:);
ForceDataA(:,2) = Frz(:);
ForceDataA(:,3) = Ffx(:);
ForceDataA(:,4) = Frx(:);
ForceDataA(:,5) = Ffy(:);
ForceDataA(:,6) = Fry(:);
ForceDataA(:,7) = Fdrag(:);

SectorDataA(:,1) = velA(:);
SectorDataA(:,2) = accelA(:);
SectorDataA(:,3) = posA(:);

% Sets initial conditions for braking profile to final values for 
velB(1) = velA(end);
accelB(1) = accelA(end);
posB(1) = posA(end);

Ffz(1) = Ffz(end);
Frz(1) = Frz(end);
Ffx(1) = Ffx(end);
Frx(1) = Frx(end);



VmaxB(1) = VmaxA(end);

% Flips the course data to loop through it backwards
CrseData = flip(CrseData);



for i = 2:length(CrseData)   % Loops through all track points assuming braking forces
    
     
        a = [1 1 CP.CarMass*velB(i-1)^2/CrseData(i,3); -(CP.WheelBase-CP.CG(1)) CP.CG(1) 0];
        b = rref(a);
        
        FfyReq = b(1,3);
        FryReq = b(2,3);
        
        VmaxF = sqrt(CP.TireCf*Ffz(i-1)*CP.WheelBase/CP.CG(1)*CrseData(i,3)/CP.CarMass);
        
        VmaxR = sqrt(CP.TireCf*Frz(i-1)*(1+CP.CG(1)/(CP.WheelBase-CP.CG(1)))*CrseData(i,3)/CP.CarMass);
        
        [VmaxB(i), C] = min([VmaxF VmaxR]);  % Vmax is the theoretical max velocity for that sector, C = 1 for front limited, C=2 for rear limited
        
        
        if velB(i-1) > VmaxB(i)
            
            velB(i) = VmaxB(i);
            accelB(i) = 0;
            
            if C == 1
                
                Ffy(i) = Ffz(i-1)*CP.TireCf;
                Fry(i) = Ffy(i)*(CP.WheelBase - CP.CG(1))/CP.CG(1);
                
            elseif C ==2
                
                Fry(i) = Frz(i-1)*CP.TireCf;
                Ffy(i) = Fry(i)*CP.CG(1)/(CP.WheelBase - CP.CG(1));
                
            end
            
            Frx(i) = 1/2*Fdrag1*velB(i-1)^2;
            Ffx(i) = 1/2*Fdrag1*velB(i-1)^2;
            
        else
            
            Ffy(i) = FfyReq;
            Fry(i) = FryReq;
            
            Ffx(i) = sqrt((CP.TireCf*Ffz(i-1))^2-Ffy(i)^2);
            %Ffx(i) = 0;
            Frx(i) = sqrt((CP.TireCf*Frz(i-1))^2-Fry(i)^2);
            
            
            OutputPower(i) = (Ffx(i)+Frx(i))*velB(i-1);
            
%             if OutputPower(i) > CP.Pmax*CP.MechEff
%                 
%                 d = (CP.Pmax)/OutputPower(i);
%                 
%                 Ffx(i) = Ffx(i)*d;
%                 Frx(i) = Frx(i)*d;
%                 
%             end
            
              accelB(i) = (Ffx(i) + Frx(i) + Fdrag1*velB(i-1)^2)/CP.CarMass;
              velB(i) = sqrt(velB(i-1)^2 + 2*accelB(i)*CrseData(i-1,4));  
            
        end
      
        posB(i) = posB(i-1)-CrseData(i,4);
        
        
        a = [1 1 CP.CarMass*9.81+Fdown1*velB(i-1)^2; +(CP.WheelBase - CP.CG(1)) -CP.CG(1) -(Frx(i)+Ffx(i))*CP.CG(2)+Fdown1*velB(i-1)^2*(CP.CG(1) - AP.CP(1))+Fdrag1*velB(i-1)^2*(AP.CP(2) - CP.CG(2))];
        b = rref(a);
        
        Ffz(i) = b(1,3);
        Frz(i) = b(2,3);
        Fdrag(i) = Fdrag1*velA(i-1)^2;
    
end


velB = flip(velB);
posB = flip(posB);
accelB = flip(accelB);

SectorDataB(:,1) = velB(:);
SectorDataB(:,2) = accelB(:);
SectorDataB(:,3) = posB(:);

ForceDataB(:,1) = flip(Ffz(:));
ForceDataB(:,2) = flip(Frz(:));
ForceDataB(:,3) = flip(Ffx(:));
ForceDataB(:,4) = flip(Frx(:));
ForceDataB(:,5) = flip(Ffy(:));
ForceDataB(:,6) = flip(Fry(:));
ForceDataB(:,7) = flip(Fdrag(:));

CrseData = flip(CrseData);

for i = 1:min(length(SectorDataB), length(SectorDataA))
   
    [SectorDataC(i,1),C] = min([SectorDataA(i,1),SectorDataB(i,1)]);
    SectorDataC(i,3) = SectorDataA(i,3);
    
    if C == 1
        ForceDataC(i,1:7) = [ForceDataA(i,1),ForceDataA(i,2),ForceDataA(i,3),ForceDataA(i,4),ForceDataA(i,5),ForceDataA(i,6),ForceDataA(i,7)];
        SectorDataC(i,2) = SectorDataA(i,2);
    elseif C == 2
        ForceDataC(i,1:7) = [ForceDataB(i,1),ForceDataB(i,2),-ForceDataB(i,3),-ForceDataB(i,4),ForceDataB(i,5),ForceDataB(i,6),ForceDataB(i,7)];
        SectorDataC(i,2) = SectorDataB(i,2);
    end
    
end


   CrseData = CrseData(1:(end-2),:);
   SectorDataC = SectorDataC(1:(end-2),:);
   ForceDataC = ForceDataC(1:(end-2),:);
   
   
   
    [TotalT, SectorDataC] = ElapTime(CrseData,SectorDataC);
    LapLength = sum(CrseData(:,4));
    
    
      h = [1/2 1/2];
      binomialCoeff = conv(h,h);
        for n = 1:4
            binomialCoeff = conv(binomialCoeff,h);
        end
   
   
 
        
  SectorDataC(:,2) = filter(binomialCoeff, 1, SectorDataC(:,2));
  ForceDataC(:,3) = filter(binomialCoeff, 1, ForceDataC(:,3));
  ForceDataC(:,4) = filter(binomialCoeff, 1, ForceDataC(:,4));  
  

  SectorDataC(:,5) = (ForceDataC(:,3).*SectorDataC(:,1)./2); % Front Power   ./CP.MechEff;
  SectorDataC(:,6) = (ForceDataC(:,4).*SectorDataC(:,1)./2); % Rear Power    ./CP.MechEff;
   
  SectorDataC = real(SectorDataC);

  for i = 1:length(SectorDataC)
    
      if SectorDataC(i,5) > 0
          SectorDataC(i,7) = (SectorDataC(i,5)/CP.MechEff)*SectorDataC(i,4)*2;
      end
      
      if SectorDataC(i,6) > 0
          SectorDataC(i,8) = (SectorDataC(i,6)/CP.MechEff)*SectorDataC(i,4)*2;  
      end
      
      %SectorDataC(i,7) = 0;
      %SectorDataC(i,8) = 0;
      
  end

  EnergyUse = sum(SectorDataC(:,7)) + sum(SectorDataC(:,8));
  EnergyUsed = EnergyUse/(1000*3600);
  %figure
  %plot(SectorDataC(:,3),ForceDataC(:,3)*CP.Rtire, SectorDataC(:,3), ForceDataC(:,4)*CP.Rtire)
   
%     figure
%     plot(SectorDataA(:,3), SectorDataA(:,1),'r')
%     hold on
%     plot(SectorDataB(:,3), SectorDataB(:,1),'b')
%     plot(SectorDataC(:,3), SectorDataC(:,1),'g')
%     title("Velocity Profile")
%     legend("Acceleration Profile","Braking Profile","Combined Profile")
%     xlabel("Distance (m)")
%     xlim([0 850])
%     ylabel("Velocity (m/s)")
%     hold off
%   
end