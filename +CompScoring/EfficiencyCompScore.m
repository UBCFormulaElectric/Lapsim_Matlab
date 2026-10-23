function [EfficiencyScore] = EfficiencyCompScore(energyUsed,totalTime)

    Emax = 0.848;
    Emin = 0.333;
    lapMin  = 62.270;
    lapMax = 90.921; 
    totalLaps = 22;
    lapTime = totalTime/totalLaps; 
    EnergyMin = 2.449; 
 


    Efactor = (lapMin/totalLaps)/(lapTime/totalLaps) * EnergyMin/energyUsed; 
    
    if(lapTime > lapMax)
        EfficiencyScore = 0; 
    
    elseif(Efactor < Emin)
        EfficiencyScore = 0; 

    else

        EfficiencyScore = 100* (Efactor - Emin)/(Emax - Emin); 

    end

    if(EfficiencyScore > 100)
       EfficiencyScore = 100; 
    end 



end

