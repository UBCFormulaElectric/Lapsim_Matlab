function [SectorDataC_EN, ForceDataC_EN, TotalT_EN, LapLength_EN, EnergyUsed_Lap, EnergyUsed_EN, ENScalar, CP, AP] = runEndurance(CP, AP, CourseData)

    [SectorDataC_EN, ForceDataC_EN, TotalT_EN, LapLength_EN, EnergyUsed_Lap] = LapModel(CP,AP,CourseData);
            
    EnergyAvailable = CP.AvailableEnergy;
    ENScalar = 22000/LapLength_EN;
           
            
    %EnergyUsed_Lap = (sum(app.SectorDataC_EN(:,7)) + sum(app.SectorDataC_EN(:,8)))/(1000*3600);
    EnergyUsed_EN = EnergyUsed_Lap*ENScalar;
            
   %%InitialPmax = CP.Pmax;
    PowerScaleFactor = EnergyAvailable/EnergyUsed_EN;
            
    while (EnergyUsed_EN < EnergyAvailable*0.98 || EnergyUsed_EN > EnergyAvailable*1.01) && PowerScaleFactor<=1
        
        PowerScaleFactor = EnergyAvailable/EnergyUsed_EN;
                
        CP.Pmax = CP.Pmax*PowerScaleFactor;
                
        [SectorDataC_EN, ForceDataC_EN, TotalT_EN, LapLength_EN , EnergyUsed_Lap] = LapModel(CP,AP,CourseData);
                
        %EnergyUsed_Lap = (sum(app.SectorDataC_EN(:,7)) + sum(app.SectorDataC_EN(:,8)))/(1000*3600);
        EnergyUsed_EN = EnergyUsed_Lap*ENScalar;

    end



end