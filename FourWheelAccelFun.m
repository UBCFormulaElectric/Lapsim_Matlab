function AccelSimResults = FourWheelAccelFun(CP,AP,Var, RunVarFlag)
    
%             CP.TireCf = 1.2;
%             CP.CarMass =  246;
%             CP.Rtire =  0.203;
%             CP.Pmax =  80000;
%             CP.Tmax =  2000;
%             CP.Nratio =  4;
%             CP.CG =  [0.7, 0.15] ;
%             CP.WheelBase = 1.525;
%             CP.I = 2;
%             CP.CarTrack = 1.1;
%             CP.ResCf = 1.1;
%             CP.MechEff = 0.78;
%             
%             AP.CfdragBdy = 1;
%             AP.Afbdy =  0.2;
%             AP.CfdragFW = 1.2;
%             AP.CfdownFW =  0;%3.5; 
%             AP.AfFW =  1.5;
%             AP.CfdragRW =  1.8;
%             AP.CfdownRW = 0; %5;
%             AP.AfRW =  2;
%             AP.CP =  [0.7, 0.15];





 switch RunVarFlag
    
     case 'On'
     
     CPMod = CP;
     APMod = AP;    
     i_Down = 2;
     i_Drag = 2;    
         
         
     IterCount = 1;
     
%      [~, Res(IterCount,1:2)] = AccelSim(CP, AP, 1, 1);
%      IterCount = IterCount + 1;    
    
     for i_TireCf = 1:3   
            
         CPMod.TireCf = CP.TireCf*Var.TireCf(i_TireCf);
         [~, Res(IterCount,1:2)] = AccelSim(CPMod, APMod, Var.Drag(i_Drag), Var.DownForce(i_Down));
         IterCount = IterCount + 1;  
         
         for i_Down = 1:3
            
             [~, Res(IterCount,1:2)] = AccelSim(CPMod, APMod, Var.Drag(i_Drag), Var.DownForce(i_Down));
              IterCount = IterCount + 1;  
             for i_Drag = 1:3
             
                 [~, Res(IterCount,1:2)] = AccelSim(CPMod, APMod, Var.Drag(i_Drag),Var.DownForce(i_Down));
                 IterCount = IterCount + 1;
                 
                for i_CGHeight = 1:3
                    
                     CPMod.CG(2) = CP.CG(2)*Var.CGHeight(i_CGHeight);
                     [~, Res(IterCount,1:2)] = AccelSim(CPMod, APMod, Var.Drag(i_Drag), Var.DownForce(i_Down));
                     IterCount = IterCount + 1;
                     
                    for i_Mass = 1:3
                        
                        CPMod.CarMass = CP.CarMass*Var.Mass(i_Mass);
                    	[~, Res(IterCount,1:2)] = AccelSim(CPMod, APMod, Var.Drag(i_Drag), Var.DownForce(i_Down));
                        IterCount = IterCount + 1;
                        
                    end
                    
                end
                
             end
             
         end
         
     end
       
       t = 1:1:length(Res(:,1));
       t = transpose(t);
       
       figure
       scatter(t(:),Res(:,1),'b')
       title('Front Max Power Variation');
       ylabel('Max Power (W)');
       xlabel('Iteration');
       
       figure
       scatter(t(:), Res(:,2),'r')
       title('Rear Max Power Variation');
       ylabel('Max Power (W)');
       xlabel('Iteration');
       
       [AccelSimResults, ~] =  AccelSim(CP,AP,1,1);
       
       
     case 'Off'
 
         [AccelSimResults, ~] =  AccelSim(CP,AP,1,1);
         
         
%        Ffz = AccelSimResults(:,1) ;  % Ffz
%        Frz = AccelSimResults(:,2) ;  % Frz
%        Ffx = AccelSimResults(:,3) ;  % Ffx
%        Frx = AccelSimResults(:,4) ;  % Frx
%        TracLimFfx = AccelSimResults(:,5) ;
%        TracLimFrx = AccelSimResults(:,6) ;
%        Tr = AccelSimResults(:,7) ;
%        Tf = AccelSimResults(:,8) ;
%        Pf = AccelSimResults(:,9) ;
%        Pr = AccelSimResults(:,10) ;
%        vel = AccelSimResults(:,11) ;
%          
%        TracLimTr = TracLimFrx*CP.Rtire;
%        TracLimTf = TracLimFfx*CP.Rtire;
%        
%        figure
%        yyaxis left;
%        plot(vel(:),Tr(:),'r-',vel(:),Tf(:),'g-', vel(:), TracLimTr(:),'r--', vel(:), TracLimTf(:),'g--')
%        
%        xlabel('Velocity m/s')
%        ylabel('Torque Nm')
%        
%        
%        yyaxis right;
%        plot(vel(:),Pr(:),'r-.', vel(:), Pf(:),'g-.')
%        ylabel('Power W')
%        
%        legend('Rear Torque','Front Torque','Rear Traction Limit','Front Traction Limit','Rear Wheel Power','Front Wheel Power')
%          
         
                
 end
 
      
     
   
        
%         yyaxis left;
%        plot(vel(:),Tr(:),'r-',vel(:),Tf(:),'g-', vel(:), TracLimTr(:),'r--', vel(:), TracLimTf(:),'g--')
%        
%        xlabel('Velocity m/s')
%        ylabel('Torque Nm')
%        
%        
%        yyaxis right;
%        plot(vel(:),Pr(:),'r-.', vel(:), Pf(:),'g-.')
%        ylabel('Power W')
%        
%        legend('Rear Torque','Front Torque','Rear Traction Limit','Front Traction Limit','Rear Wheel Power','Front Wheel Power')
%        
%        
       
 end

 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
%  
%  rho = 1.225;
%      [CfdragT, CfdownT] = AeroMap(AP);
%      Fdrag1 = 1/2*rho*CfdragT;   %Calculates Fdrag prime which is simply the collection of constants such that Drag Force = Fdrag1*Velocity^2 
%      Fdown1 = 1/2*rho*CfdownT;
%    
%      dt = 0.01;
%      Distance_Max = 75; %m
%     
%      i = 1;
%      t(i) = 0;
%      Ffz(i) = 0;
%      Frz(i) = 0;
%      Ffx(i) = 0;
%      Frx(i) = 0;
%      Tr(i) = 0;
%      Tf(i) = 0;
%      
%      
%      Fdrag(i) = 0;
%      Fdown(i) = 0;
%      pos(i) = 0;
%      vel(i) = 0;
%      accel(i) = 0;
%      
%      TracLimFfx(i) = 0;   %Traction limit front wheel
%      TracLimFrx(i) = 0;   %Traction limit rear wheel
%    
% 
%     
% %          A = [ 2 2 CP.CarMass*9.81+vel(i)^2*Fdrag1; (2*(CP.WheelBase-CP.CG(1))+2*CP.TireCf*CP.CG(2)) (-2*CP.CG(1)+2*CP.TireCf*CP.CG(2)) -Fdown1*vel(i)^2*(CP.CG(1)-AP.CP(1)) - Fdrag1*vel(i)^2*(AP.CP(2) - CP.CG(2))];
% %          B = rref(A)
% %          Ffz(i) = B(1,3)
% %          Frz(i) = B(2,3)
% %          Ffx(i) = CP.TireCf*Ffz(i)
% %          Frx(i) = CP.TireCf*Frz(i)
% 
%      
%       while pos(i) < Distance_Max
%           
%          A = [ 2 2 CP.CarMass*9.81+vel(i)^2*Fdrag1; (2*(CP.WheelBase-CP.CG(1))+2*CP.TireCf*CP.CG(2)) (-2*CP.CG(1)+2*CP.TireCf*CP.CG(2)) -Fdown1*vel(i)^2*(CP.CG(1)-AP.CP(1)) - Fdrag1*vel(i)^2*(AP.CP(2) - CP.CG(2))];
%          B = rref(A);
%          
%          Ffz(i) = B(1,3);
%          Frz(i) = B(2,3);
%          Ffx(i) = CP.TireCf*Ffz(i); 
%          Frx(i) = CP.TireCf*Frz(i);
%          
%          TracLimFfx(i) = Ffx(i);
%          TracLimFrx(i) = Frx(i);
%          
%          OutputPower(i) = (Ffx(i)+Frx(i))*vel(i);
%          
%          if OutputPower(i) > CP.Pmax/2
%              
%              d = (CP.Pmax/2)/OutputPower(i);
%              
%              Ffx(i) = Ffx(i)*d;
%              Frx(i) = Frx(i)*d;
%                
%          end
%          
%          accel(i) = (-Fdrag1*vel(i)^2 + 2*Ffx(i) + 2*Frx(i))/CP.CarMass;
%          dvel = accel(i)*dt;
%          vel(i+1) = vel(i)+dvel;
%          dpos = vel(i+1)*dt;
%          pos(i+1) = pos(i)+dpos;
%          t(i+1) = t(i) + dt;
%          i = i+1;
%          
%       end
%       
%        Ffz(i) = Ffz(i-1);
%        Frz(i) = Frz(i-1);
%        Ffx(i) = Ffx(i-1);
%        Frx(i) = Frx(i-1);
%        TracLimFfx(i) = TracLimFfx(i-1);
%        TracLimFrx(i) = TracLimFrx(i-1);
%        
%        Tr = Frx*CP.Rtire;
%        Tf = Ffx*CP.Rtire;
%        
%        TracLimTr = TracLimFrx*CP.Rtire;
%        TracLimTf = TracLimFfx*CP.Rtire;
%        
%        Pf = Ffx.*vel;
%        Pr = Frx.*vel;
%        
%        
%        AccelSimResults(:,1) = Ffz(:);  % Ffz
%        AccelSimResults(:,2) = Frz(:);  % Frz
%        AccelSimResults(:,3) = Ffx(:);  % Ffx
%        AccelSimResults(:,4) = Frx(:);  % Frx
%        AccelSimResults(:,5) = TracLimFfx(:);
%        AccelSimResults(:,6) = TracLimFrx(:);
%        AccelSimResults(:,7) = Tr(:);
%        AccelSimResults(:,8) = Tf(:);
%        AccelSimResults(:,9) = Pf(:);
%        AccelSimResults(:,10) = Pr(:);