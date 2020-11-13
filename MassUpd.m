function [MassDist] = MassUpd(CarPar,AeroPar,ForceData,CurVel,Fdrag1,Fdown1,i)


Fdrag = Fdrag1*CurVel;
Fdown = Fdown1*CurVel;
A = [1, 1, (CarPar.CarMass+Fdown); CarPar.CG(1), -(CarPar.WheelBase-CarPar.CG(1)), (Fdrag*(CarPar.CG(2)-AeroPar.CP(2)) + Fdown*(CarPar.CG(1) - AeroPar.CP(1))-ForceData(i,4)*(CarPar.CG(1)+CarPar.Rtire))];

B = rref(A);

MassDist = [B(1,3), B(2,3)];   %Vector Containing wheel weights [Front, Rear]


end 
