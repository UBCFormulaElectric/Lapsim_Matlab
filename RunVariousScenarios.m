 CP.TireCf = 1.5;
 CP.CarMass =  280;
 %CP.Rtire =  str2double(get(handles.Rtire_inp,'String'));
 %CP.Pmax =  str2double(get(handles.Pmax_inp,'String'));
 %CP.Tmax =  str2double(get(handles.Tmax_inp,'String'));
 %CP.Nratio =  str2double(get(handles.Nratio_inp,'String'));
 %CP.CG =  [str2double(get(handles.CGx_inp,'String')), str2double(get(handles.CGy_inp,'String'))] ;
 %CP.WheelBase = str2double(get(handles.WheelBase_inp,'String'));
 %CP.I = str2double(get(handles.MomentInertia_inp,'String'));
 %CP.CarTrack = str2double(get(handles.CarTrack_inp,'String'));
 CP.ResCf = 1.8;
 CP.MechEff = 0.75;
 
 AP.CfdragBdy = 1;
 AP.Afbdy =  0.2;
 AP.CfdragFW =  1.2;
 AP.CfdownFW =  3.5;
 AP.AfFW =  1.5;
 AP.CfdragRW =  1.8;
 AP.CfdownRW =  5;
 AP.AfRW =  2;
 AP.CP =  [0.7, 0.15];
 
 TP.Rcont1 = 5;
 TP.Rcont2 = 5;
 TP.Rcond1 = 7;
 TP.CellHeatCap = 950;
 TP.Cellrho = 2270;
 TP.BaseHeatCap = 921;
 TP.Baserho = 2710;
 TP.BaseArea = 0.024;
 TP.BaseVolume = 0.00015;
 TP.Tamb = 25;
 
 
 %PhysicsModel(TireCf,row, CarMass, Rtire, Pmax, Tmax, Nratio, CfdragBdy,Afbdy,CfdragFW, AfdragFW,CfdownFW,AfdownFW,CfdragRW,AfdragRW,CfdownRW,AfdownRW)
 [ThermalData, SectorData] = PhysicsModel_V3_1wheel(CP, AP);
 
 Lap_T3Cell(1) = TP.Tamb;
 Lap_Tbase(1) = TP.Tamb;
 All_T3Cell(1) = TP.Tamb;
 All_Tbase(1) = TP.Tamb;
 j=1;
 k=1;
 
 for i = 1:32
     
    [Lap_T3Cell(i+1,1), Lap_Tbase(i+1,1),T3cell, Tbase] = ThermalCalc(ThermalData, TP, Lap_T3Cell(i,1), Lap_Tbase(i,1), CP, SectorData);   
    
    All_T3Cell =[ All_T3Cell, T3cell];
    All_Tbase = [ All_Tbase, Tbase];
   
    
 end
 save("25C Convective - Aluminum Fins",'Lap_T3Cell', 'Lap_Tbase');
 %t = linspace(1,length(All_T3Cell),length(All_T3Cell));
 t = linspace(1,length(Lap_T3Cell),length(Lap_T3Cell));
 figure,plot(t, Lap_T3Cell(:,1),'g');
 hold on;
 plot(t,Lap_Tbase(:,1), 'r');
  title('Endurance Thermal Model','fontsize',20)
    xlabel('Lap','fontsize',20) % x-axis label
    ylabel('Temp (C)','fontsize',20) % y-axis label
    
Lap_Combined(:,1) = Lap_T3Cell;
Lap_Combined(:,2) =  Lap_Tbase;    
    
    
    
filename = '190529_ThermalData.xlsx';
xlswrite(filename,Lap_Combined,'AluminumFins_25C_NoCool');
    



 
 TP.Rcont1 = 5;
 TP.Rcont2 = 5;
 TP.Rcond1 = 7;
 TP.CellHeatCap = 950;
 TP.Cellrho = 2270;
 TP.BaseHeatCap = 921;
 TP.Baserho = 2710;
 TP.BaseArea = 0.024;
 TP.BaseVolume = 0.00015;
 TP.Tamb = 35;
 
 %PhysicsModel(TireCf,row, CarMass, Rtire, Pmax, Tmax, Nratio, CfdragBdy,Afbdy,CfdragFW, AfdragFW,CfdownFW,AfdownFW,CfdragRW,AfdragRW,CfdownRW,AfdownRW)
 [ThermalData, SectorData] = PhysicsModel_V3_1wheel(CP, AP);
 
 Lap_T3Cell(1) = TP.Tamb;
 Lap_Tbase(1) = TP.Tamb;
 All_T3Cell(1) = TP.Tamb;
 All_Tbase(1) = TP.Tamb;
 j=1;
 k=1;
 
 for i = 1:32
     
    [Lap_T3Cell(i+1,1), Lap_Tbase(i+1,1),T3cell, Tbase] = ThermalCalc(ThermalData, TP, Lap_T3Cell(i,1), Lap_Tbase(i,1), CP, SectorData);   
    
    All_T3Cell =[ All_T3Cell, T3cell];
    All_Tbase = [ All_Tbase, Tbase];
   
    
 end
 save("25C Convective - Aluminum Fins",'Lap_T3Cell', 'Lap_Tbase');
 %t = linspace(1,length(All_T3Cell),length(All_T3Cell));
 t = linspace(1,length(Lap_T3Cell),length(Lap_T3Cell));
 figure,plot(t, Lap_T3Cell(:,1),'g');
 hold on;
 plot(t,Lap_Tbase(:,1), 'r');
  title('Endurance Thermal Model','fontsize',20)
    xlabel('Lap','fontsize',20) % x-axis label
    ylabel('Temp (C)','fontsize',20) % y-axis label
    
Lap_Combined(:,1) = Lap_T3Cell;
Lap_Combined(:,2) =  Lap_Tbase;    
    
xlswrite(filename,Lap_Combined,'AluminumFins_35C_NoCool');
    