function  [AccelSimResults, AccelPowerResults, TotalT] = AccelSim(CP,AP, dt, Distance_Max)
    %  --------------------------------------------------------------------  %
    %  AccelSimResults an array containing the results from the
    %  acceleration simulation: 
    % 
    %       Column 1: FzFront (N)
    %       Column 2: FzRear (N)
    %       Column 3: FxFront (N)
    %       Column 4: FxRear (N)
    %       Column 5: frontTractionLimit (N/m^2)
    %       Column 6: rearTractionLimit (N/m^2)
    %       Column 7: frontTireTorque (Nm)
    %       Column 8: rearTireTorque (Nm)
    %       Column 9: frontPower (W)
    %       Column 10: rearPower (W)
    %       Column 11: velocity (m/s)
    %       Column 12: position (m)
    %       Column 13: time (seconds)
    % 
    %  AccelPowerResults, Acceleration Power data Matrix
    %       Column 1: maxFrontPower
    %       Column 2: maxRearPower

    %  TotalT: 
    %       Theoretical total time for car to travel the max distance 
    %       internally defined, based on acceleration data
    % 
    %  --------------------------------------------------------------------  %


    
    %  --------------------------------------------------------------------  %
    %  Load Motor and Aero parameters
    %  --------------------------------------------------------------------  %
    MotorLimit_500V = load("MotorLimit_500V.mat");
    MotorLimit_500V = MotorLimit_500V.MotorLimit_500V;

    rho = 1.225;
    [CfdragT, CfdownT] = AeroMap(AP);
    Fdrag1 = 1/2*rho*CfdragT; %*Drag_Var;   %Calculates Fdrag prime which is simply the collection of constants such that Drag Force = Fdrag1*Velocity^2 
    Fdown1 = 1/2*rho*CfdownT; %*Down_Var;


    %  --------------------------------------------------------------------  %
    %  Intializing AccelSim data variables (time, distance,velocity, 
    %  acceleration, and forces
    %  --------------------------------------------------------------------  %
    i = 1;
    t(i) = 0;
    Ffz(i) = 0;
    Frz(i) = 0;
    Ffx(i) = 0;
    Frx(i) = 0;
    

     
     
    Fdrag(i) = 0;
    %Fdown(i) = 0;
    pos(i) = 0;
    vel(i) = 0;
    accel(i) = 0;
     
    TracLimFfx(i) = 0;   %Traction limit front wheel
    TracLimFrx(i) = 0;   %Traction limit rear wheel

    %  --------------------------------------------------------------------  %
    %  Main loop where all of the simulation data is computed. The
    %  simulation continues, until the distance travelled by the car in the
    %  simulation is greater than the total acceleration distance set by
    %  the user. Each i entry in the simulation data represents the
    %  performace of the car for "dt" seconds. 
    %  --------------------------------------------------------------------  %
     
     while pos(i) < Distance_Max

        %Finding Ffz and Frz for the car at this time instance, using
        %force + momment equations assuming static equilibrium:
          
        A = [ 2 2 CP.CarMass*9.81+vel(i)^2*Fdown1; (2*(CP.WheelBase-CP.CG(1))+2*CP.TireCf*CP.CG(2)) (-2*CP.CG(1)+2*CP.TireCf*CP.CG(2)) -Fdown1*vel(i)^2*(CP.CG(1)-AP.CP(1)) - Fdrag1*vel(i)^2*(AP.CP(2) - CP.CG(2))];
        B = rref(A);
         
        Ffz(i) = B(1,3);
        Frz(i) = B(2,3);


        %Computes the longitudional force based on the tire force. Since
        %this simulation only considers straight line acceleration, we can
        %assume that slip angle = 0, and Ffy=Fry= 0.
         
        %This calculated force is subject to change due to the mechanical
        %limits of the car.


        Ffx(i) = CP.TireCf*Ffz(i); 
        %Ffx(i) = 0;
        Frx(i) = CP.TireCf*Frz(i);
         
        TracLimFfx(i) = Ffx(i);
        TracLimFrx(i) = Frx(i);
         
        

        
        WheelRpm = vel(i)*60/(2*pi*CP.Rtire);
        MotorRpm = WheelRpm*CP.Nratio;
        %Calculating the maximum torque, based on the current Motor RPM. 
        MaxWheelTorque = interp1(MotorLimit_500V(:,1), MotorLimit_500V(:,2),MotorRpm,'nearest')*CP.Nratio;
        
        %If the torque required to produce Ffx or Ffy, is greater than that
        %maximum torque that can be produced at a given condition, Ffx and
        %Ffr need to be adjusted to the force corresponding to the maximum
        %torque that can be produced.
        if Ffx(i)*CP.Rtire > MaxWheelTorque
            Ffx(i) = MaxWheelTorque/CP.Rtire; 
        end
            
        if Frx(i)*CP.Rtire > MaxWheelTorque
            Frx(i) = MaxWheelTorque/CP.Rtire; 
        end

        %If the power required to produce both Ffx and Ffy are greater than
        %the maximum power output, Ffx and Ffy are adjusted such that the
        %meet the power limits. 
        
        
        OutputPower(i) = (Ffx(i)+Frx(i))*vel(i); %#ok<AGROW>
            
        if OutputPower(i) > CP.Pmax*CP.MechEff/2
            d = (CP.Pmax*CP.MechEff)/(2*OutputPower(i));
                
            Ffx(i) = Ffx(i)*d;
            Frx(i) = Frx(i)*d;
        end
         
        %Calculating acceleration based on the force data 

        Fdrag(i) = Fdrag1*vel(i)^2;
         
        accel(i) = (-Fdrag(i) + 2*Ffx(i) + 2*Frx(i))/CP.CarMass;


        %Calculates the new position, velocity as a result of the following
        %acceleration being applied for dt seconds. The position, velocity
        %and time data are always one time step ahead as the pos,vel and
        %time all depends on the forces from the previous interation. 
        
        vel(i+1) = vel(i)+accel(i)*dt;
        pos(i+1) = pos(i)+vel(i)*dt + 1/2*accel(i)*dt^2;
        t(i+1) = t(i) + dt;
        i = i+1;
         
    end

  
    %  --------------------------------------------------------------------  %
    %  Setting force and acceleration data for the next time step after
    %  the while loop breaks. Since the last entry vel,pos and t are always
    %  with respect to the next time step, this ensures that all arrays
    %  have the same number of entries. 
    %  --------------------------------------------------------------------  %  
    Ffz(i) = Ffz(i-1);
    Frz(i) = Frz(i-1);
    Ffx(i) = Ffx(i-1);
    Frx(i) = Frx(i-1);
    TracLimFfx(i) = TracLimFfx(i-1);
    TracLimFrx(i) = TracLimFrx(i-1);
    Fdrag(i) = Fdrag(i-1);


    %  --------------------------------------------------------------------  %
    %  Computing tireTorque, Traction limit and front and rear power based
    %  on the force and kinematic data of the car throughout the
    %  simulation.
    %  --------------------------------------------------------------------  %  
    
    Tr = Frx*CP.Rtire;
    Tf = Ffx*CP.Rtire;
       
    %%TracLimTr = TracLimFrx*CP.Rtire;
    %%TracLimTf = TracLimFfx*CP.Rtire;
       
    Pf = Ffx.*vel;
    Pr = Frx.*vel;

    
    %  --------------------------------------------------------------------  %
    %  Storing All Simulation Results to be returned by the function.
    %  --------------------------------------------------------------------  %

       
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
