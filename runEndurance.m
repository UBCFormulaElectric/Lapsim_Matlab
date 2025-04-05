function [SectorDataC_EN, ForceDataC_EN, TotalT_EN, LapLength_EN, EnergyUsed_Lap, EnergyUsed_EN, ENScalar, CP, AP] = runEndurance(CP, AP, CourseData)

    %  --------------------------------------------------------------------  %
    % Input Parameter(s):
    % 
    %   CP, Car Parameters structure
    % 
    %   AP, Aero Parameters structure
    % 
    %   CourseData: Track Data for given Course.
    % 
    %   Output Parameter(s):
    %       SectorDataC_EN(:,n) a matrix that contains the following data:
    %           1st Column: Velocity at each point
    %           2nd Column: Acceleration at each point
    %           3rd Column: Position at each point
    %           4th Column: dt for segment i to i+1
    %           5th Column: Front Power for Segment
    %           6th Column: Rear Power for Segment
    % 
    %       ForceDataC_EN(:,n) a matrix that contains the following data:
    %           1st Column: Ffz
    %           2nd Column: Frz
    %           3rd Column: Ffx
    %           4th Column: Frx
    %           5th Column: Ffy
    %           6th Column: Fry
    %           7th Column: Fdrag
    % 
    %       TotalT_EN: Total time over the lap
    %
    %       LapLength_EN, Total distance of the lap
    %
    %       EnergyUsed_Lap, Energy used during the lap
    %       
    %       EnergyUsed_EN, Energy used
    %
    %       ENScalar: The number of laps of given track needed to complete
    %       endurance distance.
    % 
    %       CP, Car Parameters structure
    % 
    %       AP, Aero Parameters structure
    %  --------------------------------------------------------------------  %

     
    %  --------------------------------------------------------------------  %
    %  Calling lapModel to determine baseline energy used per lap, with
    %  user provided intial conditions
    %  --------------------------------------------------------------------  %
    
    [SectorDataC_EN, ForceDataC_EN, TotalT_EN, LapLength_EN, EnergyUsed_Lap] = LapModel(CP,AP,CourseData);


    %  --------------------------------------------------------------------  %
    %  The car’s available energy is an input form on the endurance tab. 
    % It is copied over and the ENScalar is calculated. ENScalar represents 
    % the number of laps of the current track needed to complete the 22 km 
    % competition endurance distance. The single-lap energy consumption is 
    % then multiplied by ENScalar to determine the total amount of energy 
    % required to complete the endurance distance. 
    %  --------------------------------------------------------------------  %
    
    EnergyAvailable = CP.AvailableEnergy;
    ENScalar = 22000/LapLength_EN;

    %  --------------------------------------------------------------------  %
    % First, the initial total power available is also pulled from the car 
    % parameters, and a Power Scaling Factor is also calculated. The Power 
    % Scaling factor < 1 means that too much energy is being used to 
    % complete the endurance run, and thus we must adjust the per-lap 
    % energy consumption.
    %  --------------------------------------------------------------------  %
           
    EnergyUsed_EN = EnergyUsed_Lap*ENScalar;

    PowerScaleFactor = EnergyAvailable/EnergyUsed_EN;
    



    %  --------------------------------------------------------------------  %
    % Main loop where the maximum power of the car is reduced by the power 
    % factor  until the per lap energy consumption, results in a total power 
    % consumption across the endurance distance, is within 2% of the
    % original energy avialable. 
    %  --------------------------------------------------------------------  %
    
    while (EnergyUsed_EN < EnergyAvailable*0.98 || EnergyUsed_EN > EnergyAvailable*1.01) && PowerScaleFactor<=1
        
        %Ratio between energy required and energy available. Allows us to
        %adjust the Pmax and thus the per lap energy consumption in the
        %right direction such that energy required = energy available.
        PowerScaleFactor = EnergyAvailable/EnergyUsed_EN; 


        %Reducing Pmax in CP, by multiplying it by PowerScaleFactor.
        %Reducing Pmax results in a lower per-lap power consumption
        %calculated by LapModel. 
        CP.Pmax = CP.Pmax*PowerScaleFactor;
        
        %Using LapModel to find energy consumption per lap and the new Pmax
        [SectorDataC_EN, ForceDataC_EN, TotalT_EN, LapLength_EN , EnergyUsed_Lap] = LapModel(CP,AP,CourseData);
                

        %Calculates total energy consumption based on per-lap consumption
        EnergyUsed_EN = EnergyUsed_Lap*ENScalar;

    end



end