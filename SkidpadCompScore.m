function [skidpadScore] = SkidpadCompScore(skidpadTime)
    Tmin = 4.898; 
    Tmax = 6.123; 

    if(skidpadTime > Tmax)
        skidpadScore =3.5;
    else
        skidpadScore = 71.5*((Tmax/skidpadTime)^2 - 1)/((Tmax/Tmin)^2 - 1) + 3.5;
    end

    if(skidpadScore > 75 )
        skidpadScore = 75;
    end
end

