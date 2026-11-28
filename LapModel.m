function [SectorDataC, ForceDataC, TotalT, LapLength, EnergyUsed] = LapModel(CP,AP,CourseName,ModelOptions)

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
    CrseData = CourseName;

    % Load MAT files
    data100 = load('/Users/aborawake/Documents/MatlabMatlabModelV2_FE/Lapsim_Matlab/Motor Data Sheets/A2370DD_T100C.mat');

    % Axes setup 
    rpm_vec = data100.Speed(:,1);          
    T_vec   = data100.Shaft_Torque(1,:);

    %Limits
    I_max   = 105;         % Arms
    V_dc    = 350;         % V (nominal DC bus)
    V_margin= 30;          % V reserve margin
    
    limits = struct('I_max', I_max, 'V_dc', V_dc, 'V_margin', V_margin);

    % Build gridded interpolnts
    fields = {'Shaft_Torque','Id_RMS','Iq_RMS','Stator_Current_Phase_RMS',...
              'Vd_RMS','Vq_RMS','Total_Loss','Stator_Copper_Loss',...
              'Iron_Loss','Magnet_Loss','Mechanical_Loss'};
    % makes an 1by 1 array for each map (REPLACE THIS WITH ONLY MAP 100)
    maps100 = struct();
    
    % loads the maps with the look up values
    for i = 1:length(fields)
        f = fields{i};
        maps100.(f) = griddedInterpolant({rpm_vec, T_vec}, data100.(f), 'linear','nearest');
    end

    MotorLimitSpeed = max(rpm_vec)*(2*pi*CP.Rtire)/(60*CP.Nratio); %max(rpm_vec) = 20,000
    %MotorLimitSpeed = 30; %Based on Motor Curves?

    if ModelOptions.four_wheel_drive == 1
        frontWheelDrive = true;
    else
        frontWheelDrive = false;
    end

    [CfdragT, CfdownT] = AeroMap(AP); %Call to aeromap function which combines the effects of drag and downforce from each individual element 

    rho = 1.225;

    Fdrag1 = 1/2*rho*CfdragT;   %Calculates Fdrag prime which is simply the collection of constants such that Drag Force = Fdrag1*Velocity^2
    Fdown1 = 1/2*rho*CfdownT;

    % Pacejka parameters
    pac_fx = [ -15.75854662   1.43389415   3.343542286  0.91617855  ];
    pac_fy = [   0.170613402  1.544452682  2.924301138  0.524592595 ];

    slipAmax = 9.48021;
    slipRmax = 0.123296;

    v_thresh = 0.1;

    % Same-segment force solver settings (total axle force in N).
    forceTol = 0.1;
    maxForceIter = 60;
    % Brake model selection (simulation only; draft hydraulic inputs below).
    % Optional ModelOptions.brake_mode:
    %   "legacy"     : original 40% front bias, tire-limited only
    %   "bias_only"  : hydraulic-model bias, tire-limited only
    %   "mechanical" : hydraulic-model bias and mechanical force limits (default)
    brakeMode = "mechanical";
    if isfield(ModelOptions,'brake_mode')
        brakeMode = string(ModelOptions.brake_mode);
    end
    if ~isscalar(brakeMode) || ~any(brakeMode == ["legacy","bias_only","mechanical"])
        error('LapModel:InvalidBrakeMode','Unknown brake_mode.');
    end
    if brakeMode == "legacy"
        BrakeBias = 0.4;
        brakeCaps = [Inf,Inf];
    else
        % Draft parameters from the supplied brake model. These are not
        % validated hardware specifications or a real-world safety check.
        brakePedalForce = 428;            % N
        brakePedalRatio = 5.1;
        brakeFrontForceFraction = 0.55;   % assumed master-cylinder force split
        brakeMasterArea = 0.000220;      % m^2, equal front/rear
        brakeCaliperArea = [0.002027,0.001013]; % m^2, effective per wheel
        brakePadMu = 0.41;
        brakeEffectiveRotorRadius = 0.150; % m
        validateattributes(CP.Rtire,{'numeric'}, ...
            {'scalar','real','finite','positive'});
        brakePressure = brakePedalForce*brakePedalRatio* ...
            [brakeFrontForceFraction,1-brakeFrontForceFraction]/brakeMasterArea;
        brakeTorque = brakePressure.*brakeCaliperArea* ...
            brakePadMu*brakeEffectiveRotorRadius; % Nm per wheel
        brakeCaps = 2*brakeTorque/CP.Rtire;       % N per axle
        % Hydraulic input split is not the wheel-force split because the
        % front and rear effective piston areas differ.
        BrakeBias = brakeCaps(1)/sum(brakeCaps);
        if brakeMode == "bias_only"
            brakeCaps = [Inf,Inf];
        end
    end

    % Start/Stop Conditions
    vStart = ModelOptions.start_velocity;
    vEnd   = ModelOptions.stop_velocity; %neg 1 means dont brake

    %  --------------------------------------------------------------------  %
    %  Sets initial conditions for acceleration portion of the forwards- 
    %  backwards method. Creates the vectors for the velocity, acceleration,
    %  position, and front and rear longitudinal forces.
    %  --------------------------------------------------------------------  %
    posA    = zeros(1,length(CrseData)-1);
    velXA   = zeros(1,length(CrseData)-1);
    velYA   = zeros(1,length(CrseData)-1);
    accelXA = zeros(1,length(CrseData)-1);
    accelYA = zeros(1,length(CrseData)-1);

    % Initial front and rear wheel forces
    Ffx   = zeros(1,length(CrseData)-1);
    Frx   = zeros(1,length(CrseData)-1);
    Ffy   = zeros(1,length(CrseData)-1);
    Fry   = zeros(1,length(CrseData)-1);
    Ffz   = zeros(1,length(CrseData)-1);
    Frz   = zeros(1,length(CrseData)-1);
    Fdrag = zeros(1,length(CrseData)-1);

    % Start conditions
    velXA(1) = vStart;

    % Calculates initial front and rear wheel forces in the z direction
    % Matrix of the force and moment balance on the XZ plane, RREF to solve for the z forces
    a = [1 1 CP.CarMass*9.81+Fdown1*velXA(1)^2; 
        -(CP.WheelBase - CP.CG(1)) CP.CG(1) (Frx(1)+Ffx(1))*CP.CG(2) - Fdown1*velXA(1)^2*(CP.CG(1) - AP.CP(1))+Fdrag1*velXA(1)^2*(AP.CP(2) - CP.CG(2))];
    b = rref(a);

    Ffz(1) = b(1,3);
    Frz(1) = b(2,3);
    Fdrag(1) = Fdrag1*velXA(1)^2;

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
    for i = 2:length(CrseData)
        % Solve longitudinal force and the corresponding axle loads together.
        % Previous speed is fixed during this quasi-static segment solve.
        ds = CrseData(i,4);
        [velXA(i), accelXA(i), Ffx(i), Frx(i), Ffy(i), Fry(i), ...
            Ffz(i), Frz(i), Fdrag(i)] = solveSegment( ...
            velXA(i-1), CrseData(i,3), ds, false, CP, AP, ...
            Fdown1, Fdrag1, pac_fx, pac_fy, slipRmax, slipAmax, ...
            v_thresh, MotorLimitSpeed, frontWheelDrive, maps100, limits, ...
            forceTol, maxForceIter, BrakeBias, brakeCaps);

        accelYA(i) = (Ffy(i) + Fry(i))/CP.CarMass;
        velYA(i) = sqrt(max(0, velYA(i-1)^2 + ...
            2*accelYA(i)*ds));
        posA(i) = posA(i-1) + ds;
    end

    %  --------------------------------------------------------------------  %
    %  Post-loop data formatting
    %  --------------------------------------------------------------------  %
    velXA(end) = velXA(end-1);
    velYA(end) = velYA(end-1);

    % Format the force vectors into an (n x 7) matrix
    ForceDataA(:,1) = Ffz(:);
    ForceDataA(:,2) = Frz(:);
    ForceDataA(:,3) = Ffx(:);
    ForceDataA(:,4) = Frx(:);
    ForceDataA(:,5) = Ffy(:);
    ForceDataA(:,6) = Fry(:);
    ForceDataA(:,7) = Fdrag(:);

    % Format the kinematics vectors into an (n x 3) matrix
    SectorDataA(:,1) = velXA(:);
    SectorDataA(:,2) = accelXA(:);
    SectorDataA(:,3) = posA(:);

    %  --------------------------------------------------------------------  %
    %  Sets initial conditions for braking portion of the forwards- 
    %  backwards method. Creates the vectors for the velocity, acceleration,
    %  position, front and rear longitudinal forces, and front and rear 
    %  vertical forces based on the end result of the acceleration iteration.
    %  --------------------------------------------------------------------  %
    posB    = zeros(1,length(CrseData)-1);
    velXB   = zeros(1,length(CrseData)-1);
    velYB   = zeros(1,length(CrseData)-1);
    accelXB = zeros(1,length(CrseData)-1);
    accelYB = zeros(1,length(CrseData)-1);

    posB(1)    = posA(end);
    velXB(1)   = velXA(end);
    velYB(1)   = velYA(end);
    accelXB(1) = accelXA(end);
    accelYB(1) = accelYA(end);

    Ffx = zeros(1,length(CrseData));
    Frx = zeros(1,length(CrseData));
    Ffy = zeros(1,length(CrseData));
    Fry = zeros(1,length(CrseData));
    Ffz = zeros(1,length(CrseData));
    Frz = zeros(1,length(CrseData));

    % Initialise reverse-pass forces independently of the forward pass.
    Fdrag = zeros(1,length(CrseData));

    % End Conditions
    if vEnd ~= -1
        velXB(1) = vEnd;
    end

    % Calculates initial front and rear wheel forces in the z direction
    % Matrix of the force and moment balance on the XZ plane, RREF to solve for the z forces
    a = [1 1 CP.CarMass*9.81+Fdown1*velXB(1)^2; 
        -(CP.WheelBase - CP.CG(1)) CP.CG(1) -(Frx(1)+Ffx(1))*CP.CG(2)-Fdown1*velXB(1)^2*(CP.CG(1) - AP.CP(1))+Fdrag1*velXB(1)^2*(AP.CP(2) - CP.CG(2))];
    b = rref(a);

    Ffz(1) = b(1,3);
    Frz(1) = b(2,3);
    Fdrag(1) = Fdrag1*velXB(1)^2;

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
    %  recalculate the z forces for the next iteration. 
    % 
    %  We complete this process over the entire track.
    %  --------------------------------------------------------------------  %
    for i = 2:length(CrseData)
        % Solve longitudinal force and the corresponding axle loads together.
        % Previous speed is fixed during this quasi-static segment solve.
        ds = CrseData(i,4);
        [velXB(i), accelXB(i), Ffx(i), Frx(i), Ffy(i), Fry(i), ...
            Ffz(i), Frz(i), Fdrag(i)] = solveSegment( ...
            velXB(i-1), CrseData(i,3), ds, true, CP, AP, ...
            Fdown1, Fdrag1, pac_fx, pac_fy, slipRmax, slipAmax, ...
            v_thresh, MotorLimitSpeed, frontWheelDrive, maps100, limits, ...
            forceTol, maxForceIter, BrakeBias, brakeCaps);

        accelYB(i) = (Ffy(i) + Fry(i))/CP.CarMass;
        velYB(i) = sqrt(max(0, velYB(i-1)^2 + ...
            2*accelYB(i)*ds));
        posB(i) = posB(i-1) - ds;
    end

    %  --------------------------------------------------------------------  %
    %  Post-loop data formatting
    %  --------------------------------------------------------------------  %
    velXB(end) = velXB(end-1);

    % Flip kinematics vectors since we iterated through the loop backwards
    posB    = flip(posB);
    velXB   = flip(velXB);
    accelXB = flip(accelXB);

    % Format kinematics vectors into an (n x 3) matrix
    SectorDataB(:,1) = velXB(:);
    SectorDataB(:,2) = accelXB(:);
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
    SectorDataC(:,1) = zeros(1,length(velXA));
    SectorDataC(:,2) = zeros(1,length(accelXA));
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
        if SectorDataB(i,1) > SectorDataA(i,1)
            SectorDataC(i,1) = SectorDataA(i,1); % Velocity
            SectorDataC(i,2) = SectorDataA(i,2); % Acceleration
            SectorDataC(i,3) = SectorDataA(i,3); % Position
            ForceDataC(i,1:7) = [ForceDataA(i,1),ForceDataA(i,2),ForceDataA(i,3),ForceDataA(i,4),ForceDataA(i,5),ForceDataA(i,6),ForceDataA(i,7)];
        else
            SectorDataC(i,1) = SectorDataB(i,1); % Velocity
            SectorDataC(i,2) = -SectorDataB(i,2); % Signed acceleration
            SectorDataC(i,3) = SectorDataA(i,3); % Position (from Accel data)
            ForceDataC(i,1:7) = [ForceDataB(i,1),ForceDataB(i,2),-ForceDataB(i,3),-ForceDataB(i,4),ForceDataB(i,5),ForceDataB(i,6),ForceDataB(i,7)];
        end
        
    end

    SectorDataC(:,9) = SectorDataA(:,1);
    SectorDataC(:,10) = SectorDataB(:,1);

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
        else
            SectorDataC(i,7) = 0;
        end
            
        % Rear Energy = (Rear Power / MechEff) * dt * 2 
        if SectorDataC(i,6) > 0
            SectorDataC(i,8) = (SectorDataC(i,6)/CP.MechEff)*SectorDataC(i,4)*2;  
        else
            SectorDataC(i,8) = 0;
        end
        
    end

    % Calculate the Energy Used over the Lap
    EnergyUse = sum(SectorDataC(:,7)) + sum(SectorDataC(:,8));
    EnergyUsed = EnergyUse/(1000*3600);

end

% -------------------------------------------------------------------------
% Solve one segment with a bracketed scalar force search. Positive Fx means
% traction in the forward pass and braking magnitude in the backward pass.
% Loads and tire limits are evaluated at the same incoming speed.
% -------------------------------------------------------------------------
function [vNext, ax, FxF, FxR, FyF, FyR, FzF, FzR, drag] = solveSegment( ...
    v, radius, ds, braking, CP, AP, kd, kg, pac_fx, pac_fy, ...
    slipR, slipA, v_thresh, motorSpeed, fourWD, maps, limits, tol, maxIter, bias, brakeCaps)

    m = CP.CarMass;
    L = CP.WheelBase;
    c = CP.CG(1);
    h = CP.CG(2);
    direction = 1 - 2*double(braking);
    if ~isreal(v) || ~isfinite(v) || v < 0 || ~isreal(radius) || isnan(radius) || ...
             ~isfinite(ds) || ds < 0
        error('LapModel:InvalidSegment', 'Invalid speed, radius or segment length.');
    end
    % Use curvature magnitude for tire capacity, as in the original model.

    if radius == 0 || isinf(radius)
        curvature = 0;
    else
        curvature = 1/abs(radius);
    end

    % First establish the pure-cornering/motor speed envelope independently
    % of trial longitudinal force. This prevents force-dependent switching
    % between the original accelerate/brake and coast branches.
    [~,~,~,~,~,latOK] = tireState(0,v);
    if ~latOK || v > motorSpeed
        lo = 0;
        hi = min(v,motorSpeed);
        for j = 1:maxIter
            mid = (lo+hi)/2;
            [~,~,~,~,~,ok] = tireState(0,mid);
            if ok
                lo = mid;
            else
                hi = mid;
            end
            if hi-lo < 1e-6
                break
            end
        end
        vNext = lo;
        [FzF,FzR,FyF,FyR,~,~] = tireState(0,vNext);
        FxF = 0;
        FxR = 0;
        drag = kg*vNext^2;
        ax = 0; % Envelope reset; not a physical coast/braking step.
        return
    end

    drag = kg*v^2;
    [~,~,~,~,caps0,~] = tireState(0,v);
    % Upper bound from motor speed. Corner overshoot is also limited using
    % the no-longitudinal-force lateral capability at this evaluation speed.
    [~,~,~,~,~,~,latCaps] = tireState(0,v);
    if curvature == 0
        vCap = motorSpeed;
    else
        vCap = min([motorSpeed, sqrt(latCaps(1)*L/(c*m*curvature)), ...
            sqrt(latCaps(2)*L/((L-c)*m*curvature))]);
    end
    if ds > 0
        forceCap = max(0, m*(vCap^2-v^2)/(2*ds) + direction*drag);
    else
        forceCap = 0;
    end

    % Mechanical brake limits also bound the shared pedal-force search.
    if braking
        forceCap = min([forceCap, brakeCaps(1)/bias, ...
            brakeCaps(2)/(1-bias)]);
    end

    % Find a feasible lower bound and an infeasible upper bound.
    % For every trial total force, check the resulting weight transfer,
    % combined-slip limits, motor torque/power, and fixed brake bias.
    lo = 0;
    hi = min(forceCap,max(1,sum(caps0)));
    [ok,~,~] = feasible(hi);
    for j = 1:maxIter
        if ~ok || hi >= forceCap
            break
        end
        lo = hi;
        hi = min(forceCap,2*hi);
        [ok,~,~] = feasible(hi);
    end
    if ok
        lo = hi;
    else
        for j = 1:maxIter
            if hi-lo <= tol
                break
            end
            mid = (lo+hi)/2;
            if feasible(mid)
                lo = mid;
            else
                hi = mid;
            end
        end
        if hi-lo > tol
            warning('LapModel:ForceConvergence', ...
                'Force bracket did not converge at %.3f m/s (width %.3f N).',v,hi-lo);
        end
    end

    % Retain only the feasible side of the bracket. Do not average the
    % accepted force with a rejected trial.
    [~,FxF,FxR] = feasible(lo);
    [FzF,FzR,FyF,FyR] = tireState(FxF+FxR,v);
    ax = (FxF+FxR-direction*drag)/m;
    vNext = min(vCap,sqrt(max(0,v^2+2*ax*ds)));

    function [zf,zr,yf,yr,caps,latOK,latCaps] = tireState(totalFx,speed)
        down = kd*speed^2;
        d = kg*speed^2;
        normal = m*9.81+down;
        moment = direction*totalFx*h - down*(c-AP.CP(1)) ...
            + d*(AP.CP(2)-h);
        zf = (c*normal-moment)/L;
        zr = normal-zf;
        yf = m*speed^2*curvature*c/L;
        yr = m*speed^2*curvature*(L-c)/L;
        if min(zf,zr) < 0
            caps = [0,0];
            latCaps = [0,0];
            latOK = false;
            return
        end
        if speed < v_thresh
            latCaps = CP.TireCf*[zf,zr];
            longCaps = latCaps;
        else
            latCaps = [0,0];
            longCaps = [0,0];
            loads = [zf,zr];
            for n = 1:2
                if loads(n) > 0
                    latCaps(n) = max(0,-Pacejka4(-loads(n),slipA,pac_fy));
                    longCaps(n) = max(0,Pacejka4(-loads(n),slipR,pac_fx));
                end
            end
        end
        if any(~isfinite([latCaps,longCaps]))
            error('LapModel:InvalidTireForce','Nonfinite tire force capacity.');
        end
        demand = [yf,yr];
        latOK = all(demand <= latCaps);
        caps = longCaps.*sqrt(max(0,1-(demand./max(latCaps,eps)).^2));
    end

    function [ok,front,rear] = feasible(totalFx)
        [~,~,~,~,caps,latOK] = tireState(totalFx,v);
        front = 0;
        rear = 0;
        ok = false;
        if ~latOK
            return
        end
        if totalFx == 0
            ok = true;
            return
        end
        if braking
            front = bias*totalFx;
            rear = (1-bias)*totalFx;
            % One shared braking demand: neither axle may exceed its own
            % combined-slip tire capacity or mechanical brake capacity.
            availableBrake = min(caps,brakeCaps);
            ok = front <= availableBrake(1) && rear <= availableBrake(2);
        else
            rpm = v*60*CP.Nratio/(2*pi*CP.Rtire);
            if ~fourWD
                caps(1) = 0;
            end
            for axle = 1:2
                if caps(axle) > 0
                    wanted = caps(axle)*CP.Rtire/(2*CP.Nratio);
                    mot = motor_map_model_function(rpm,wanted,maps,limits);
                    caps(axle) = min(caps(axle), ...
                        max(0,mot.Torque*2*CP.Nratio/CP.Rtire));
                end
            end
            if any(~isfinite(caps))
                error('LapModel:InvalidMotorForce','Nonfinite motor force capacity.');
            end
            available = sum(caps);
            ok = totalFx <= available && ...
                totalFx*v <= CP.Pmax*CP.MechEff;
            if ok && available > 0
                front = totalFx*caps(1)/available;
                rear = totalFx-front;
            end
        end
    end
end





