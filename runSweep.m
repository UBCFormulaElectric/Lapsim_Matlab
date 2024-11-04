function [] = runSweep(SelectedParameter, SweepRange, CP, AP, CourseData_AC, CourseData_EN,SweepPoints, SaveDirectoryLocation, RunName)
            
            CPLocal = CP;
            APLocal = AP
            
            CPStart = CP;
            APStart = AP;
            ParameterString = ["TireCf", "CarMass", "Rtire", "Pmax", "Tmax", "Nratio", "CGx", "CGz"];
            Multiplier = 1 - SweepRange/100;
            increment = (2*SweepRange/SweepPoints)/100;
            
            
            [~, ~,RefT_AC,~, ~] = LapModel(CPLocal,APLocal,CourseData_AC);
            [~, ~,RefT_EN,~, ~] = runEndurance(CPLocal,APLocal,CourseData_EN);
            [~, ~, RefT_Acc] = AccelSim(CPLocal,APLocal);
            
        
            Acc_MaxScore = 100;
            AC_MaxScore = 125;
            EN_MaxScore = 275;
            Eff_MaxScore = 100;
            
            TotalMaxScore = Acc_MaxScore + AC_MaxScore + EN_MaxScore;
            
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
                    CPLocal.CG(1) = CPStart.CG(1)*Multiplier;
                    ParameterValues(i) = CPLocal.CG(1);
                case ParameterString(8)
                    CPLocal.CG(2) = CPStart.CG(2)*Multiplier; 
                    ParameterValues(i) = CPLocal.CG(2);
            end
            
            
            
            [SectorData_AC, ForceData_AC,TotalT_AC(i),LapLength_AC(i), EnergyUsed_AC(i)] = LapModel(CPLocal,APLocal,CourseData_AC);
            [SectorData_EN, ForceData_EN,TotalT_EN(i),LapLength_EN(i), EnergyUsed_EN(i)] = runEndurance(CPLocal,APLocal,CourseData_EN);
            [AccelSimResults, AccelPowerResults, TotalT_Acc(i)] = AccelSim(CPLocal,APLocal);
            %SectorDataSave(:,:,i) = SectorDataC;

            Multiplier = Multiplier + increment;
            
            end
        
            RelScore_AC = TotalT_AC/RefT_AC;
            RelScore_EN = TotalT_EN/RefT_EN;
            RelScore_Acc = TotalT_Acc/RefT_Acc;
            
            RelScore_AC = smooth(RelScore_AC);
            RelScore_EN = smooth(RelScore_EN);
            RelScore_Acc = smooth(RelScore_Acc);
            
            
            
            RelScore_Total = RelScore_AC*AC_MaxScore/TotalMaxScore + RelScore_EN*EN_MaxScore/TotalMaxScore + RelScore_Acc*Acc_MaxScore/TotalMaxScore;
            
            
            
            figure;
            plot(ParameterValues,RelScore_AC*100);
            title("Autocross");
            xlabel("Parameter Value")
            ylabel("Relative Event Score")
            figure;
            plot(ParameterValues,RelScore_EN*100);
            title("Endurance");
            xlabel("Parameter Value")
            ylabel("Relative Event Score")
            figure;
            plot(ParameterValues,RelScore_Acc*100);
            title("Acceleration");
            xlabel("Parameter Value")
            ylabel("Relative Event Score")
            figure;
            plot(ParameterValues,RelScore_Total*100);
            xlabel("Parameter Value")
            ylabel("Relative Total Compeition Score")
            title("Total Score");
            
                FolderDir = append(SaveDirectoryLocation,'\',RunName);
                mkdir(FolderDir);
                
                SavedDir = append(SaveDirectoryLocation,'\',RunName,'\');
                save(append(SavedDir,RunName,'.mat'),'ParameterValues','RelScore_AC','RelScore_EN','RelScore_Acc','RelScore_Total');
            
            
            
            
end