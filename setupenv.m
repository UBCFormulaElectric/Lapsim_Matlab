CP.TireCf = 1.2;
CP.CarMass =  300;
CP.Rtire =  0.2286;
CP.Pmax =  80000;
CP.Tmax =  2000;
CP.Nratio =  12;
CP.CG =  [0.7, 0.3] ;
CP.WheelBase = 1.525;
CP.I = 2;
CP.CarTrack = 1.525;
CP.ResCf = 1.1;
CP.MechEff = 0.78;
CP.AvailableEnergy = 6.3;

AP.CfdragBdy = 1;
AP.Afbdy =  0.8;
AP.CfdragFW =  1.2;
AP.CfdownFW =  3;
AP.AfFW =  0.375;
AP.CfdragRW =  1.8;
AP.CfdownRW =  3;
AP.AfRW =  0.8;
AP.CP =  [0.7, 0.4];

[SectorDataC, ForceDataC, TotalT, LapLength, EnergyUsed, slipA, slipR, yaw] = LapModel(CP,AP,TrackSave);
yaw = yaw.';