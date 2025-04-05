function  [AccelSimResults, AccelPowerResults, TotalT] = lapModelAccelSim(CP,AP, dt, Distance_Max)
    %  --------------------------------------------------------------------  %
    %  AccelSimResults an array containing the results from the
    %  acceleration simulation: 
    % 
    %       Column 1: FzFront (N)
    %       Column 2: FzRear (N)
    %       Column 3: FxFront (N)
    %       Column 4: FxRear (N)
    %       Column 5: frontTractionLimit (N/m^2)
    %       Column 6: rearTractionLimit (N/m^2)
    %       Column 7: frontTireTorque (Nm)
    %       Column 8: rearTireTorque (Nm)
    %       Column 9: frontPower (W)
    %       Column 10: rearPower (W)
    %       Column 11: velocity (m/s)
    %       Column 12: position (m)
    %       Column 13: time (seconds)
    % 
    %  AccelPowerResults, Acceleration Power data Matrix
    %       Column 1: maxFrontPower
    %       Column 2: maxRearPower

    %  TotalT: 
    %       Theoretical total time for car to travel the max distance 
    %       internally defined, based on acceleration data
    % 
    %  --------------------------------------------------------------------  %
    
   %Using track created by app. 
   %  AccelStraightLineData = load("AccelerationStraightLine75m.mat"); 
   % 
   %  CourseData = AccelStraightLineData.TrackSave; 



   NumSegments = dt;
   lengthSegment = Distance_Max/(NumSegments-1); 


    CourseData(1,1) = 0; 
    CourseData(1,2) = 0; 
    CourseData(1,3) = inf; 
    CourseData(1,4) = 0; 
    CourseData(1,5) = 0; 
    CourseData(1,6) = 0;
    CourseData(1,7) = 0; 
    CourseData(1,8) = 0; 
    CourseData(1,9) = 0; 

    
    for i = 2:NumSegments
        
        CourseData(i,1) = CourseData(i-1,1)+lengthSegment;
        CourseData(i,2) = 0; 
        CourseData(i,3) = inf; 
        CourseData(i,4) = lengthSegment; 
        CourseData(i,5) = 0; 
        CourseData(i,6) = 0;
        CourseData(i,7) = 0; 
        CourseData(i,8) = 0; 
        CourseData(i,9) = 0; 


    end 


    [SectorDataAccel, ForceDataAccel, TotalTAccel, ~ , ~] = LapModel(CP,AP,CourseData); 
    
    t   = zeros(1,length(SectorDataAccel));

    totalT = length(SectorDataAccel(:,4)); 
    

    for j = 2:length(SectorDataAccel(:,4))

        t(j) = SectorDataAccel(j,4) + t(j-1); 

    end
    

    Tr = ForceDataAccel(:,3).*CP.Rtire;
    Tf = ForceDataAccel(:,4).*CP.Rtire;
    
    Pf = ForceDataAccel(:,3).*SectorDataAccel(:,1);
    Pr = ForceDataAccel(:,4).*SectorDataAccel(:,1);
    
    AccelPowerResults = [max(SectorDataAccel(:,5)), max(SectorDataAccel(:,6))]; 


    AccelSimResults(:,1) = ForceDataAccel(:,1);  % Ffz
    AccelSimResults(:,2) = ForceDataAccel(:,2);  % Frz
    AccelSimResults(:,3) = ForceDataAccel(:,3);  % Ffx
    AccelSimResults(:,4) = ForceDataAccel(:,4);  % Frx
    AccelSimResults(:,5) = ForceDataAccel(:,3);
    AccelSimResults(:,6) = ForceDataAccel(:,4); 
    AccelSimResults(:,7) = Tr(:);
    AccelSimResults(:,8) = Tf(:);
    AccelSimResults(:,9) = Pf(:);
    AccelSimResults(:,10) = Pr(:);
    AccelSimResults(:,11) = SectorDataAccel(:,1);
    AccelSimResults(:,12) = SectorDataAccel(:,3);
    AccelSimResults(:,13) = t(:);
    AccelSimResults(:,14) = ForceDataAccel(:,7); 
    TotalT = TotalTAccel;


end
