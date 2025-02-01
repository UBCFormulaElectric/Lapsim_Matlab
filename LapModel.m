function [SectorDataC, ForceDataC, TotalT, LapLength, EnergyUsed] = LapModel(CP,AP,CourseName)

% CourseData(:,n) is an array containing information about the track data
%   Firt Column : X - Coordinates of track
%   Second Column : Y - Coordinates of track
%   Third Column : Instantateous radius of the track at that point
%   Fourth Column : Legnth of sector, of the i to i+1 data point
%   Fifth Column : Center of Circle Column : X
%   Sixth Column : Center of Cricle Column : Y
%   Seventh Column : Direction Vector  Column : X
%   Eighth Column : Direction Vector Column : Y
%   Ninth Column : Angle between Sector(i) and (i-1)
%
% SectorData(:,n) is an array containing information about the entry and exit speeds of each ector
%   First Column : Velocity at each point  
%   Second Column : Acceleration at each point 
%   Third Column : Position at each point 
%   Fourth Column : dt for segment i to i+1
%   Fifth Column : Front Power for Segment
%   Sixth Column : Rear Power for Segment
%   Seventh Column :    
%
% ForceData(:,n) is an matrix containing information on all the forces used during iteration
%   First Column : Vertical Force at the Front
%   Second Column : Vertical Force at the Rear
%   Third Column : Longitudinal Force at the Front
%   Fourth Column : Longitudinal Force at the Rear
%   Fifth Column : Lateral Force at the Front
%   Sixth Column : Lateral Force at the Rear
%   Seventh Column : Force of Drag


    %  --------------------------------------------------------------------  %
    %  Load Car and Track parameters
    %  --------------------------------------------------------------------  %
    MotorLimit_500V = load("MotorLimit_500V.mat");
    MotorLimit_500V = MotorLimit_500V.MotorLimit_500V;
    CrseData = CourseName;
    rho = 1.225;
    [CfdragT, CfdownT] = AeroMap(AP); %Call to aeromap function which combines the effects of drag and downforce from each individual element

    MotorLimitSpeed = 19900*(2*pi*CP.Rtire)/(60*CP.Nratio);

    Fdrag1 = 1/2*rho*CfdragT;   %Calculates Fdrag prime which is simply the collection of constants such that Drag Force = Fdrag1*Velocity^2
    Fdown1 = 1/2*rho*CfdownT;

    %  --------------------------------------------------------------------  %
    %  Sets initial conditions for acceleration portion of the forwards- 
    %  backwards method. Creates the vectors for the velocity, acceleration,
    %  position, and front and rear longitudinal forces.
    %  --------------------------------------------------------------------  %
    posA   = zeros(1,length(CrseData)-1);
    velA   = zeros(1,length(CrseData)-1);
    accelA = zeros(1,length(CrseData)-1);

    % Initial front and rear wheel forces
    Ffx   = zeros(1,length(CrseData)-1);
    Frx   = zeros(1,length(CrseData)-1);
    Ffy   = zeros(1,length(CrseData)-1);
    Fry   = zeros(1,length(CrseData)-1);
    Ffz   = zeros(1,length(CrseData)-1);
    Frz   = zeros(1,length(CrseData)-1);
    Fdrag = zeros(1,length(CrseData)-1);

    % Calculates initial front and rear wheel forces in the z direction
    % Matrix of the force and moment balance on the XZ plane, RREF to solve for the z forces
    a = [1 1 CP.CarMass*9.81+Fdown1*velA(1)^2; 
        -(CP.WheelBase - CP.CG(1)) CP.CG(1) (Frx(1)+Ffx(1))*CP.CG(2)+Fdown1*velA(1)^2*(CP.CG(1) - AP.CP(1))+Fdrag1*velA(1)^2*(AP.CP(2) - CP.CG(2))];
    b = rref(a);

    Ffz(1) = b(1,3);
    Frz(1) = b(2,3);

    %  --------------------------------------------------------------------  %
    %  Forwards portion of the forwards-backwards method.
    %  
    %  At the start of each iteration, we calculate the required lateral 
    %  forces on the front and the rear for the incoming velocity velA(i-1), 
    %  and use these to calculate the maximum speed for the front and rear.
    %
    %  We then find if the car needs to accelerate (if the motor allows) or 
    %  coast. After, we can recalcalate the z forces for the next iteration. 
    % 
    %  We complete this process over the entire track.
    %  --------------------------------------------------------------------  %
    for i = 2:length(CrseData)  % Loop through all track points with acceleration forces 
        
        % Using the same matrix RREF method we calculate the front and rear forces in the lateral direction
        % Instead, we use the force and moment balance on the XY plane
        a = [1 1 CP.CarMass*velA(i-1)^2/CrseData(i,3); -(CP.WheelBase-CP.CG(1)) CP.CG(1) 0];  % Calculates required lateral tire force for incoming velocity velA(i-1)
        b = rref(a);
        
        % Required front and frear forces
        FfyReq = b(1,3);
        FryReq = b(2,3);
        
        % Calculates theoretical max velocity of this segment assuming front limited
        VmaxF = sqrt(CP.TireCf*Ffz(i-1)*CP.WheelBase/CP.CG(1)*CrseData(i,3)/CP.CarMass); 

        % Calculates theoreticl max velocity of this segment assuming rear limited
        VmaxR = sqrt(CP.TireCf*Frz(i-1)*(1+CP.CG(1)/(CP.WheelBase-CP.CG(1)))*CrseData(i,3)/CP.CarMass); 
        
        % If the velocity on the previous iteration is higher than the theoretical velocity this higher we 
        % do not need to accelerate, we can coast.
        if velA(i-1) > min([VmaxF VmaxR])
  
            % If front limited, Fry is derived from Ffy
            if VmaxF < VmaxR
                velA(i) = VmaxF;
                Ffy(i) = Ffz(i-1)*CP.TireCf;
                Fry(i) = Ffy(i)*(CP.WheelBase - CP.CG(1))/CP.CG(1);
            % If rear limited, Ffy is derived from Fry
            else
                velA(i) = VmaxR;
                Fry(i) = Frz(i-1)*CP.TireCf;
                Ffy(i) = Fry(i)*CP.CG(1)/(CP.WheelBase - CP.CG(1));
            end
                
            accelA(i) = 0; %-Fdrag1*velA(i-1)^2/CP.CarMass; 

            Ffx(i) = 0; %1/2*Fdrag1*velA(i-1)^2;
            Frx(i) = 0; %1/2*Fdrag1*velA(i-1)^2; 
            %Ffx(i) = 0;
        
        % If the desired velocity is not possible from the motor, we need to cap our speed
        elseif velA(i-1) > MotorLimitSpeed
            
            % Set velocity of current segment to theoretical max
            velA(i) = MotorLimitSpeed;
            accelA(i) = 0; %-Fdrag1*velA(i-1)^2/CP.CarMass; 
                
            %if C == 1      % If front limited
            %                 
            %   Ffy(i) = Ffz(i-1)*CP.TireCf;
            %   Fry(i) = Ffy(i)*(CP.WheelBase - CP.CG(1))/CP.CG(1);
            %                 
            %elseif C == 2   % If rear limited    
            %                 
            %   Fry(i) = Frz(i-1)*CP.TireCf;
            %   Ffy(i) = Fry(i)*CP.CG(1)/(CP.WheelBase - CP.CG(1));
            %                 
            %end

            % Set lateral forces to the required ones
            Ffy(i) = FfyReq;
            Fry(i) = FryReq;
            
            % Longitudinal forces 0 since we are just coasting
            Ffx(i) = 0; %1/2*Fdrag1*velA(i-1)^2;  
            Frx(i) = 0; %1/2*Fdrag1*velA(i-1)^2;

        % If the other conditions are not met we can accelerate
        else

            % Set lateral forces to the required ones
            Ffy(i) = FfyReq;
            Fry(i) = FryReq;
            
            % Longitudinal acceleration is based on tire parameters
            Ffx(i) = sqrt((CP.TireCf*Ffz(i-1))^2-Ffy(i)^2);
            Frx(i) = sqrt((CP.TireCf*Frz(i-1))^2-Fry(i)^2);
            
            % Power = Force * Velocity
            OutputPower = (Ffx(i)+Frx(i))*velA(i-1);

            % 4 Wheel Drive Code
            WheelRpm = velA(i-1)*60/(2*pi*CP.Rtire);
            MotorRpm = WheelRpm*CP.Nratio;
            MaxWheelTorque = interp1(MotorLimit_500V(:,1), MotorLimit_500V(:,2),MotorRpm,'nearest')*CP.Nratio;
                
            if Ffx(i)*CP.Rtire > MaxWheelTorque*2
                Ffx(i) = MaxWheelTorque*2/CP.Rtire; 
            end
                
            if Frx(i)*CP.Rtire > MaxWheelTorque*2
                Frx(i) = MaxWheelTorque*2/CP.Rtire; 
            end
                
            if OutputPower > CP.Pmax*CP.MechEff
                d = (CP.Pmax*CP.MechEff)/(OutputPower);
                    
                Ffx(i) = Ffx(i)*d; 
                Frx(i) = Frx(i)*d;
            end
            
            % Longitudinal force balance to find the acceleration, classical kinematics to find the velocity
            accelA(i) = (Ffx(i) + Frx(i) - Fdrag1*velA(i-1)^2)/CP.CarMass;
            velA(i) = sqrt(velA(i-1)^2 + 2*accelA(i)*CrseData(i,4));  
                
        end

        % Update the position of the vehicle on the track based on the segment size
        posA(i) = posA(i-1)+CrseData(i,4);
        
        % (Same calculation as pre-loop.)
        % Calculates initial front and rear wheel forces in the z direction
        % Matrix of the force and moment balance on the XZ plane, RREF to solve for the z forces
        a = [1 1 CP.CarMass*9.81+Fdown1*velA(i-1)^2; 
            (CP.WheelBase - CP.CG(1)) -CP.CG(1) (Frx(i)+Ffx(i))*CP.CG(2)+Fdown1*velA(i-1)^2*(CP.CG(1) - AP.CP(1))+Fdrag1*velA(i-1)^2*(AP.CP(2) - CP.CG(2))];
        b = rref(a);
            
        Ffz(i) = b(1,3);
        Frz(i) = b(2,3);
        Fdrag(i) = Fdrag1*velA(i-1)^2;
        
    end  

    %  --------------------------------------------------------------------  %
    %  Post-loop data formatting
    %  --------------------------------------------------------------------  %

    % Format the force vectors into an (n x 7) matrix
    ForceDataA(:,1) = Ffz(:);
    ForceDataA(:,2) = Frz(:);
    ForceDataA(:,3) = Ffx(:);
    ForceDataA(:,4) = Frx(:);
    ForceDataA(:,5) = Ffy(:);
    ForceDataA(:,6) = Fry(:);
    ForceDataA(:,7) = Fdrag(:);

    % Format the kinematics vectors into an (n x 3) matrix
    SectorDataA(:,1) = velA(:);
    SectorDataA(:,2) = accelA(:);
    SectorDataA(:,3) = posA(:);

    %  --------------------------------------------------------------------  %
    %  Sets initial conditions for braking portion of the forwards- 
    %  backwards method. Creates the vectors for the velocity, acceleration,
    %  position, front and rear longitudinal forces, and front and rear 
    %  vertical forces based on the end result of the acceleration iteration.
    %  --------------------------------------------------------------------  %
    posB   = zeros(1,length(CrseData)-1);
    velB   = zeros(1,length(CrseData)-1);
    accelB = zeros(1,length(CrseData)-1);

    posB(1)   = posA(end);
    velB(1)   = velA(end);
    accelB(1) = accelA(end);

    Ffx = zeros(1,length(CrseData)-1);
    Frx = zeros(1,length(CrseData)-1);
    Ffy = zeros(1,length(CrseData)-1);
    Fry = zeros(1,length(CrseData)-1);
    Ffz = zeros(1,length(CrseData)-1);
    Frz = zeros(1,length(CrseData)-1);

    Ffz(1) = Ffz(end);
    Frz(1) = Frz(end);
    Ffx(1) = Ffx(end);
    Frx(1) = Frx(end);

    % Flips the course data so that we are iterating from the back of the track forwards
    CrseData = flip(CrseData);

    %  --------------------------------------------------------------------  %
    %  Backwards portion of the forwards-backwards method.
    %  
    %  At the start of each iteration, we calculate the required lateral 
    %  forces on the front and the rear for the incoming velocity velA(i-1), 
    %  and use these to calculate the maximum speed for the front and rear.
    %
    %  We then find if the car needs to brake or coast After, we can 
    %  recalcalate the z forces for the next iteration. 
    % 
    %  We complete this process over the entire track.
    %  --------------------------------------------------------------------  %
    for i = 2:length(CrseData)   % Loops through all track points assuming braking forces
        
        % Using the same matrix RREF method we calculate the front and rear forces in the lateral direction
        % Instead, we use the force and moment balance on the XY plane
        a = [1 1 CP.CarMass*velB(i-1)^2/CrseData(i,3); -(CP.WheelBase-CP.CG(1)) CP.CG(1) 0];
        b = rref(a);
            
        % Required front and frear forces
        FfyReq = b(1,3);
        FryReq = b(2,3);
            
        % Calculates theoretical max velocity of this segment assuming front limited
        VmaxF = sqrt(CP.TireCf*Ffz(i-1)*CP.WheelBase/CP.CG(1)*CrseData(i,3)/CP.CarMass);

        % Calculates theoreticl max velocity of this segment assuming rear limited
        VmaxR = sqrt(CP.TireCf*Frz(i-1)*(1+CP.CG(1)/(CP.WheelBase-CP.CG(1)))*CrseData(i,3)/CP.CarMass);
            
        % If the previous iteration velocity (time step in the future) is higher then we want to coast. 
        % Otherwise, we want to brake.
        if velB(i-1) > min([VmaxF VmaxR])
                
            % If front limited, Fry is derived from Ffy
            if VmaxF < VmaxR
                velB(i) = VmaxF;
                Ffy(i) = Ffz(i-1)*CP.TireCf;
                Fry(i) = Ffy(i)*(CP.WheelBase - CP.CG(1))/CP.CG(1);
            % If rear limited, Ffy is derived from Fry
            else
                velB(i) = VmaxR;
                Fry(i) = Frz(i-1)*CP.TireCf;
                Ffy(i) = Fry(i)*CP.CG(1)/(CP.WheelBase - CP.CG(1));
            end
            
            % Acceleration is 0 because we are coasting
            accelB(i) = 0;

            % Calculate drag based on the aero parameters
            Frx(i) = 1/2*Fdrag1*velB(i-1)^2;
            Ffx(i) = 1/2*Fdrag1*velB(i-1)^2;
            
        else
        
            % Full breaking
            Ffy(i) = FfyReq;
            Fry(i) = FryReq;
            
            % Longitudinal acceleration is based on tire parameters
            Ffx(i) = sqrt((CP.TireCf*Ffz(i-1))^2-Ffy(i)^2);
            Frx(i) = sqrt((CP.TireCf*Frz(i-1))^2-Fry(i)^2);
            
            % Power = Force * Velocity
            %OutputPower = (Ffx(i)+Frx(i))*velB(i-1);
                
            %if OutputPower(i) > CP.Pmax*CP.MechEff
            %    d = (CP.Pmax)/OutputPower(i);          
            %    Ffx(i) = Ffx(i)*d;
            %    Frx(i) = Frx(i)*d;              
            %end
                
            % Longitudinal force balance to find the acceleration, classical kinematics to find the velocity
            accelB(i) = (Ffx(i) + Frx(i) + Fdrag1*velB(i-1)^2)/CP.CarMass;
            velB(i) = sqrt(velB(i-1)^2 + 2*accelB(i)*CrseData(i-1,4));  
                
        end
        
        % Track length left is the previous track length - the length of the current segment
        posB(i) = posB(i-1)-CrseData(i,4);

        % (Same calculation as pre-loop.)
        % Calculates initial front and rear wheel forces in the z direction
        % Matrix of the force and moment balance on the XZ plane, RREF to solve for the z forces
        a = [1 1 CP.CarMass*9.81+Fdown1*velB(i-1)^2; 
            +(CP.WheelBase - CP.CG(1)) -CP.CG(1) -(Frx(i)+Ffx(i))*CP.CG(2)+Fdown1*velB(i-1)^2*(CP.CG(1) - AP.CP(1))+Fdrag1*velB(i-1)^2*(AP.CP(2) - CP.CG(2))];
        b = rref(a);
        
        Ffz(i) = b(1,3);
        Frz(i) = b(2,3);
        Fdrag(i) = Fdrag1*velA(i-1)^2;

    end

    %  --------------------------------------------------------------------  %
    %  Post-loop data formatting
    %  --------------------------------------------------------------------  %

    % Flip kinematics vectors since we iterated through the loop backwards
    velB = flip(velB);
    posB = flip(posB);
    accelB = flip(accelB);

    % Format kinematics vectors into an (n x 3) matrix
    SectorDataB(:,1) = velB(:);
    SectorDataB(:,2) = accelB(:);
    SectorDataB(:,3) = posB(:);

    % Format force vectors into an (n x 7) matrix (flipped as well)
    ForceDataB(:,1) = flip(Ffz(:));
    ForceDataB(:,2) = flip(Frz(:));
    ForceDataB(:,3) = flip(Ffx(:));
    ForceDataB(:,4) = flip(Frx(:));
    ForceDataB(:,5) = flip(Ffy(:));
    ForceDataB(:,6) = flip(Fry(:));
    ForceDataB(:,7) = flip(Fdrag(:));

    % Flip the course data so it is forwards again
    CrseData = flip(CrseData);

    % Preallocate (n x 3) matrix for combined force vector data
    SectorDataC(:,1) = zeros(1,length(velA));
    SectorDataC(:,2) = zeros(1,length(accelA));
    SectorDataC(:,3) = zeros(1,length(posA));

    % Preallocate (n x 7) matrix for combined kinematics vector data
    ForceDataC(:,1) = zeros(1,length(Ffz));
    ForceDataC(:,2) = zeros(1,length(Frz));
    ForceDataC(:,3) = zeros(1,length(Ffx));
    ForceDataC(:,4) = zeros(1,length(Frx));
    ForceDataC(:,5) = zeros(1,length(Ffy));
    ForceDataC(:,6) = zeros(1,length(Fry));
    ForceDataC(:,7) = zeros(1,length(Fdrag));

    %  --------------------------------------------------------------------  %
    %  Combining the Forwards and Backwards Iterations
    %
    %  We will iterate through the forwards and backwards results and take 
    %  the data at the lower (limiting) of the two velocity curves for each 
    %  time step. All in all this gives us our forwards-backwards method.
    %  --------------------------------------------------------------------  %
    for i = 1:min(length(SectorDataB), length(SectorDataA))
    
        % If the Acceleration curve has a higher velocity use those data
        % points, otherwise use the Braking curve
        if SectorDataA(i,1) < SectorDataB(i,1)
            SectorDataC(i,1) = SectorDataA(i,1); % Velocity
            SectorDataC(i,2) = SectorDataA(i,2); % Acceleration
            SectorDataC(i,3) = SectorDataA(i,3); % Position
            ForceDataC(i,1:7) = [ForceDataA(i,1),ForceDataA(i,2),ForceDataA(i,3),ForceDataA(i,4),ForceDataA(i,5),ForceDataA(i,6),ForceDataA(i,7)];
        else
            SectorDataC(i,1) = SectorDataB(i,1); % Velocity
            SectorDataC(i,2) = SectorDataB(i,2); % Acceleration
            SectorDataC(i,3) = SectorDataA(i,3); % Position (from Accel data)
            ForceDataC(i,1:7) = [ForceDataB(i,1),ForceDataB(i,2),-ForceDataB(i,3),-ForceDataB(i,4),ForceDataB(i,5),ForceDataB(i,6),ForceDataB(i,7)];
        end
        
    end

    %  --------------------------------------------------------------------  %
    %  Data Processing
    %  --------------------------------------------------------------------  %

    % Final 2 rows are trimmed from our matrices
    CrseData    = CrseData(1:(end-2),:);
    SectorDataC = SectorDataC(1:(end-2),:);
    ForceDataC  = ForceDataC(1:(end-2),:);
    
    % Total time taken over the lap is finally calculated, using our forwards-backwards results
    [TotalT, SectorDataC] = ElapTime(CrseData,SectorDataC);
    LapLength = sum(CrseData(:,4));
        
    % Binomial coeffiicients are created to be used in a filter:
    % https://en.wikipedia.org/wiki/Binomial_coefficient
    % This means that values at the centre of the filter window will be weighted heavier
    % than values at the outside of the window
    % https://www.mathworks.com/help/matlab/ref/conv.html
    h = [1/2 1/2];
    binomialCoeff = conv(h,h);
    for n = 1:4
        binomialCoeff = conv(binomialCoeff,h);
    end
    
    % We filter the acceleration and the longitudinal forces
    % We should consider using filtfilt instead of filter so there is no lag in the filtered signal
    SectorDataC(:,2) = filter(binomialCoeff, 1, SectorDataC(:,2)); % Acceleration
    ForceDataC(:,3)  = filter(binomialCoeff, 1, ForceDataC(:,3));  % Front Longitudinal
    ForceDataC(:,4)  = filter(binomialCoeff, 1, ForceDataC(:,4));  % Rear Longitudinal

    % Calculate Power for the Front and Rear (P = Fx * v / 2)
    SectorDataC(:,5) = (ForceDataC(:,3).*SectorDataC(:,1)./2); % Front Power   ./CP.MechEff;
    SectorDataC(:,6) = (ForceDataC(:,4).*SectorDataC(:,1)./2); % Rear Power    ./CP.MechEff;
    
    % Remove Imaginary Numbers (?)
    SectorDataC = real(SectorDataC);

    for i = 1:length(SectorDataC)
        
        % Front Energy = (Front Power / MechEff) * dt * 2 
        if SectorDataC(i,5) > 0
            SectorDataC(i,7) = (SectorDataC(i,5)/CP.MechEff)*SectorDataC(i,4)*2;
        end
            
        % Rear Energy = (Rear Power / MechEff) * dt * 2 
        if SectorDataC(i,6) > 0
            SectorDataC(i,8) = (SectorDataC(i,6)/CP.MechEff)*SectorDataC(i,4)*2;  
        end
        
    end

    % Calculate the Energy Used over the Lap
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

end