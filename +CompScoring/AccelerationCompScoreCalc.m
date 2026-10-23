function [AccelerationScore] = AccelerationCompScoreCalc(AccelerationTime)
    Tmax = 5.732;
    Tmin = 3.821;

    if(AccelerationTime > Tmax)
        AccelerationScore = 4.5;
    else
        AccelerationScore = 95.5* (Tmax/AccelerationTime - 1)/(Tmax/Tmin - 1) + 4.5; 
    end

    if(AccelerationScore > 100)
        AccelerationScore = 100;
    end

end

