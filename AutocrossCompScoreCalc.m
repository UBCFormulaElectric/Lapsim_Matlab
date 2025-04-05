function [autocrossCompScore] = AutocrossCompScoreCalc(autocrossLapTime)
    %Determined from FSAE Electric 2024 Results
    Tmin = 46.776; 
    Tmax = 67.825; 

    if(autocrossLapTime > Tmax) 
        
        autocrossCompScore = 6.5;


    else
        autocrossCompScore = 118.5*(Tmax/autocrossLapTime -  1)/(Tmax/Tmin - 1) + 6.5;
    end 
    
end

