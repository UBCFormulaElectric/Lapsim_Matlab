function [AccelerationScore] = AccelerationCompScoreCalc(AccelerationTime)
    Tmax = 5.463;
    Tmin = 3.642;

    if(AccelerationTime > Tmax)
        AccelerationScore = 4.5;
    else
        AccelerationScore = 95.5* (Tmax/AccelerationTime - 1)/(Tmax/Tmin - 1) + 4.5; 
    end

end

