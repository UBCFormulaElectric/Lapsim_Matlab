function [EnduranceCompScore] = EnduranceComScoreCalc(EnduranceTime)

    Tmax = 1986.408;
    Tmin = 1369.936;
    
    if(EnduranceTime > Tmax)
        EnduranceCompScore = 25; 

    else
        
        EnduranceCompScore = 250 * (Tmax/EnduranceTime - 1)/(Tmax/Tmin - 1) + 25;

    end

    if(EnduranceCompScore > 275)
        EnduranceCompScore = 275; 
    end 
    
end

