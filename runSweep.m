function [] = runSweep(SelectedParameter, SweepRange, CP, AP, CourseData_AC, CourseData_EN,SweepPoints)
            
            CPLocal = CP;
            APLocal = AP
            
            CPStart = CP;
            APStart = AP;
            ParameterString = ["TireCf", "CarMass", "Rtire", "Pmax", "Tmax", "Nratio", "CGx", "CGy"];
            Multiplier = 1 - SweepRange/100;
            increment = (2*SweepRange/SweepPoints)/100;
            
            for i = 1 : SweepPoints
             
            switch SelectedParameter
                case ParameterString(1)
                    CPLocal.TireCf = (CPStart.TireCf)*Multiplier;
                    ParameterValues(i) = CPLocal.TireCf;
                case ParameterString(2)
                    CPLocal.CarMass = CPStart.CarMass*Multiplier; 
                    ParameterValues(i) = CPLocal.CarMass;
                case ParameterString(3)
                    CPLocal.Rtire = CPStart.Rtire*Multiplier; 
                    ParameterValues(i) = CPLocal.Rtire;
                case ParameterString(4)    
                    CPLocal.Pmax = CPStart.Pmax*Multiplier; 
                    ParameterValues(i) = CPLocal.Pmax;
                case ParameterString(5)
                    CPLocal.Tmax = CPStart.Tmax*Multiplier; 
                    ParameterValues(i) = CPLocal.Tmax;
                case ParameterString(6)
                    CPLocal.Nratio = CPStart.Nratio*Multiplier; 
                    ParameterValues(i) = CPLocal.Nratio;
                case ParameterString(7)
                    CPLocal.CGx = CPStart.CGx*Multiplier;
                    ParameterValues(i) = CPLocal.CGx;
                case ParameterString(8)
                    CPLocal.CGy = CPStart.CGy*Multiplier; 
                    ParameterValues(i) = CPLocal.CGy;
            end
            
            
            
            [SectorData_AC, ForceData_AC,TotalT_AC(i),LapLength_AC(i), EnergyUsed_AC(i)] = LapModel(CPLocal,APLocal,CourseData_AC);
            [SectorData_EN, ForceData_EN,TotalT_EN(i),LapLength_EN(i), EnergyUsed_EN(i)] = runEndurance(CPLocal,APLocal,CourseData_EN);
            [AccelSimResults, AccelPowerResults, TotalT_Acc(i)] = AccelSim(CPLocal,APLocal);
            %SectorDataSave(:,:,i) = SectorDataC;

            Multiplier = Multiplier + increment;
            
            end
        

            figure;
            plot(ParameterValues,TotalT_AC);
            title("Autocross");
            figure;
            plot(ParameterValues,TotalT_EN);
            title("Endurance");
            figure;
            plot(ParameterValues,TotalT_Acc);
            title("Acceleration");
        returnStatus = 1;
end