function  [AccelSimResults, AccelPowerResults, TotalT] = AccelSim(CP,AP)

    MotorLimit_500V = load("MotorLimit_500V.mat");
    MotorLimit_500V = MotorLimit_500V.MotorLimit_500V;

      rho = 1.225;
     [CfdragT, CfdownT] = AeroMap(AP);
     Fdrag1 = 1/2*rho*CfdragT; %*Drag_Var;   %Calculates Fdrag prime which is simply the collection of constants such that Drag Force = Fdrag1*Velocity^2 
     Fdown1 = 1/2*rho*CfdownT; %*Down_Var;

    
     dt = 0.001;
     Distance_Max = 75; %m
    
     i = 1;
     t(i) = 0;
     Ffz(i) = 0;
     Frz(i) = 0;
     Ffx(i) = 0;
     Frx(i) = 0;
     Tr(i) = 0;
     Tf(i) = 0;
     
     
     Fdrag(i) = 0;
     Fdown(i) = 0;
     pos(i) = 0;
     vel(i) = 0;
     accel(i) = 0;
     
     TracLimFfx(i) = 0;   %Traction limit front wheel
     TracLimFrx(i) = 0;   %Traction limit rear wheel
   

    
%          A = [ 2 2 CP.CarMass*9.81+vel(i)^2*Fdrag1; (2*(CP.WheelBase-CP.CG(1))+2*CP.TireCf*CP.CG(2)) (-2*CP.CG(1)+2*CP.TireCf*CP.CG(2)) -Fdown1*vel(i)^2*(CP.CG(1)-AP.CP(1)) - Fdrag1*vel(i)^2*(AP.CP(2) - CP.CG(2))];
%          B = rref(A)
%          Ffz(i) = B(1,3)
%          Frz(i) = B(2,3)
%          Ffx(i) = CP.TireCf*Ffz(i)
%          Frx(i) = CP.TireCf*Frz(i)

     
      while pos(i) < Distance_Max
          
         A = [ 2 2 CP.CarMass*9.81+vel(i)^2*Fdown1; (2*(CP.WheelBase-CP.CG(1))+2*CP.TireCf*CP.CG(2)) (-2*CP.CG(1)+2*CP.TireCf*CP.CG(2)) -Fdown1*vel(i)^2*(CP.CG(1)-AP.CP(1)) - Fdrag1*vel(i)^2*(AP.CP(2) - CP.CG(2))];
         B = rref(A);
         
         Ffz(i) = B(1,3);
         Frz(i) = B(2,3);
         Ffx(i) = CP.TireCf*Ffz(i); 
         %Ffx(i) = 0;
         Frx(i) = CP.TireCf*Frz(i);
         
         TracLimFfx(i) = Ffx(i);
         TracLimFrx(i) = Frx(i);
         
         
         
            WheelRpm = vel(i)*60/(2*pi*CP.Rtire);
            MotorRpm = WheelRpm*CP.Nratio;
            MaxWheelTorque = interp1(MotorLimit_500V(:,1), MotorLimit_500V(:,2),MotorRpm,'nearest')*CP.Nratio;
            
            if Ffx(i)*CP.Rtire > MaxWheelTorque
                Ffx(i) = MaxWheelTorque/CP.Rtire; 
            end
            
            if Frx(i)*CP.Rtire > MaxWheelTorque
                Frx(i) = MaxWheelTorque/CP.Rtire; 
            end
            
            OutputPower(i) = (Ffx(i)+Frx(i))*vel(i);
            
            if OutputPower(i) > CP.Pmax*CP.MechEff/2
                 d = (CP.Pmax*CP.MechEff)/(2*OutputPower(i));
                
                Ffx(i) = Ffx(i)*d;
                Frx(i) = Frx(i)*d;
            end
         
%          if OutputPower(i) > CP.Pmax*CP.MechEff/2
%              
%              d = (CP.Pmax*CP.MechEff/2)/OutputPower(i);
%              
%              Ffx(i) = Ffx(i)*d;
%              Frx(i) = Frx(i)*d;
%                
%          end
         
         Fdrag(i) = Fdrag1*vel(i)^2;
         
         accel(i) = (-Fdrag1*vel(i)^2 + 2*Ffx(i) + 2*Frx(i))/CP.CarMass;
         vel(i+1) = vel(i)+accel(i)*dt;
         
         pos(i+1) = pos(i)+vel(i)*dt + 1/2*accel(i)*dt^2;
         t(i+1) = t(i) + dt;
         i = i+1;
         
      end
      
       Ffz(i) = Ffz(i-1);
       Frz(i) = Frz(i-1);
       Ffx(i) = Ffx(i-1);
       Frx(i) = Frx(i-1);
       TracLimFfx(i) = TracLimFfx(i-1);
       TracLimFrx(i) = TracLimFrx(i-1);
       Fdrag(i) = Fdrag(i-1);
       
       
       Tr = Frx*CP.Rtire;
       Tf = Ffx*CP.Rtire;
       
       TracLimTr = TracLimFrx*CP.Rtire;
       TracLimTf = TracLimFfx*CP.Rtire;
       
       Pf = Ffx.*vel;
       Pr = Frx.*vel;
       
       
       AccelPowerResults = [max(Pf), max(Pr)];
       
       AccelSimResults(:,1) = Ffz(:);  % Ffz
       AccelSimResults(:,2) = Frz(:);  % Frz
       AccelSimResults(:,3) = Ffx(:);  % Ffx
       AccelSimResults(:,4) = Frx(:);  % Frx
       AccelSimResults(:,5) = TracLimFfx(:);
       AccelSimResults(:,6) = TracLimFrx(:);
       AccelSimResults(:,7) = Tr(:);
       AccelSimResults(:,8) = Tf(:);
       AccelSimResults(:,9) = Pf(:);
       AccelSimResults(:,10) = Pr(:);
       AccelSimResults(:,11) = vel(:);
       AccelSimResults(:,12) = pos(:);
       AccelSimResults(:,13) = t(:);
       AccelSimResults(:,14) = Fdrag(:);
       TotalT = t(end);

end
