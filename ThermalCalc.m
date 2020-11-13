function [TCellFinish,TBaseFinish,T3cell,Tbase] = ThermalCalc(ThermalData,TP,TcellStart,TbaseStart,CP,SectorData)

    Vacc = 402;
    Racc = 0.08;   %mOhms
    R3cell = (3/(2.5*10^-3))^(-1);
    CellVol3 = 0.0093*0.042*0.1275*3;    
    T3cell(1) = TcellStart;
    Tbase(1) = TbaseStart;
    DynamicVis = 1.825*10^-5;
    rhoAir = 1.225;
    Lseg = 0.25;
    Pr = 0.71;
    kair = 0.02551;
    kalum = 200;
    
    h = 1.78*kair*(TP.Lf+TP.a)/(TP.Lf*TP.a);
    %h = 60
    Ab = (TP.Wb*TP.Lb - TP.N*TP.tf*TP.Lb);
    Af = TP.Lf*TP.Lb*2;
    
    
    
    RB2Air = 1/(h*Ab);
    
    %Fin Parameters
    
    P = 2*(TP.Lb+TP.tf);
    Ac = TP.Lb*TP.tf;
    
    
    
    RF2Air = (h*P*kalum*Ac)^(-1/2)/(tanh(sqrt(h*P/(kalum*Ac))*TP.Lf));
    
    RFinEquiv = (1/RB2Air + (1/(RF2Air))*TP.N)^-1;
    
    
    
    
   %  RthCtoB = (2/(TP.Rcont1 + TP.Rcond1 + TP.Rcont2))^(-1);    %2 Fins thermal resistance

    RthCtoB = (2/(TP.Rcont1 + TP.Rcond1 + TP.Rcont2))^(-1);     %3 Fins thermal resistance
      
    
    
    for i = 1:length(ThermalData)
        
       Iacc(i) = (Vacc - sqrt(400^2-4*Racc*ThermalData(i,2)))/(2*Racc);
       
       qinC = Iacc(i)^2*R3cell;
      
       qoutC = (T3cell(i) - Tbase(i))/(RthCtoB);
       %qoutC = 0;           %Delete
       
       
       dT3celldt = (qinC - qoutC)/(TP.Cellrho*CellVol3*TP.CellHeatCap);
       
       T3cell(i+1) = T3cell(i) + dT3celldt*SectorData(i,5);
       
       
       Re = rhoAir*SectorData(i,3)*TP.VelocityMulti*Lseg/DynamicVis;
       
       %h(i) = k/Lseg*0.680*Re^(1/2)*Pr^(1/3);  %First Approximation
        %h(i) = 0;              %delete
       
       qinB = qoutC*16;
       %qinB = 0;
       qoutB = (Tbase(i)-TP.Tamb)/RFinEquiv;
       
       dTbasedt = (qinB-qoutB)/(TP.Baserho*TP.BaseVolume*TP.BaseHeatCap);
       
       Tbase(i+1) = Tbase(i) + dTbasedt*SectorData(i,5);
       
       
       
        
    end
    
    TCellFinish = T3cell(i);
    TBaseFinish = Tbase(i);

    
    
%     figure;
%     plot(1:length(ThermalData), Iacc(:));
end