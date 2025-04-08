function [EnduranceCompScore] = EnduranceComScoreCalc(EnduranceTime)

    Tmax = 2292.825;
    Tmin = 1581.258;
    
    if(EnduranceTime > Tmax)
        EnduranceCompScore = 0; 

    else
        
        EnduranceCompScore = 250 * (Tmax/EnduranceTime - 1)/(Tmax/Tmin - 1);

    end
    
end

