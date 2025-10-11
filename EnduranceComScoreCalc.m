function [EnduranceCompScore] = EnduranceComScoreCalc(EnduranceTime)

    Tmax = 2292.825;
    Tmin = 1581.258;
    
    if(EnduranceTime > Tmax)
        EnduranceCompScore = 25; 

    else
        
        EnduranceCompScore = 250 * (Tmax/EnduranceTime - 1)/(Tmax/Tmin - 1) + 25;

    end

    if(EnduranceCompScore > 275)
        EnduranceCompScore = 275; 
    end 
    
end

