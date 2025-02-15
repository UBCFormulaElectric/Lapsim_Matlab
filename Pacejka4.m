function F = Pacejka4(Fz,SA,params)
%Pacjeka4_Fx: Summary of this function goes here
%   Detailed explanation goes here
    B  = params(1);
    C  = params(2);
    D1 = params(3);
    D2 = params(4);
    
    D = (D1+D2/1000*Fz)*Fz;
    F = D*sin(C*atan(B*SA));
end