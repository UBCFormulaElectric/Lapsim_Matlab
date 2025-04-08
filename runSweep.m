function [] = runSweep(SelectedParameter, SweepRange, CP, AP, CourseData_AC, CourseData_EN,SweepPoints, SaveDirectoryLocation, RunName)
            
            CPLocal = CP;
            APLocal = AP;
            
            CPStart = CP;
            APStart = AP;
            ParameterString = ["TireCf", "CarMass", "Rtire", "Pmax", "Tmax", "Nratio", "CGx", "CGz"];
            Multiplier = 1 - SweepRange/100;
            increment = (2*SweepRange/SweepPoints)/100;
            
            
            % [~, ~,RefT_AC,~, ~] = LapModel(CPLocal,APLocal,CourseData_AC);
            % [~, ~,RefT_EN,~, ~] = runEndurance(CPLocal,APLocal,CourseData_EN);
            % [~, ~, RefT_Acc] = AccelSim(CPLocal,APLocal,0.001,75);


            Score_AC = zeros(SweepPoints,1);
            Score_EN = zeros(SweepPoints,1); 
            Score_Acc = zeros(SweepPoints,1); 
        
            % Acc_MaxScore = 100;
            % AC_MaxScore = 125;
            % EN_MaxScore = 275;
            % Eff_MaxScore = 100;
            % 
            % TotalMaxScore = Acc_MaxScore + AC_MaxScore + EN_MaxScore;
            
            for i = 1 : SweepPoints
             
            switch SelectedParameter
                case ParameterString(1)
                    CPLocal.TireCf = (CPStart.TireCf)*Multiplier;
                    ParameterValues(i) = CPLocal.TireCf;
                    if(i == 1)
                        xAxisTitle = "Tire Coefficient of Friction";
                    end
                    
                case ParameterString(2)
                    CPLocal.CarMass = CPStart.CarMass*Multiplier; 
                    ParameterValues(i) = CPLocal.CarMass;
                    if(i == 1)
                        xAxisTitle = "Car Mass (kg)";
                    end

                case ParameterString(3)
                    CPLocal.Rtire = CPStart.Rtire*Multiplier; 
                    ParameterValues(i) = CPLocal.Rtire;
                    if(i == 1)
                        xAxisTitle = "Tire Radius (m)";
                    end

                case ParameterString(4)    
                    CPLocal.Pmax = CPStart.Pmax*Multiplier; 
                    ParameterValues(i) = CPLocal.Pmax;
                    if(i == 1)
                        xAxisTitle = "Tire Radius (m)";
                    end

                case ParameterString(5)
                    CPLocal.Tmax = CPStart.Tmax*Multiplier; 
                    ParameterValues(i) = CPLocal.Tmax;
                    if (i==1)
                        xAxisTitle = "Max Torque (N/m)";
                    end

                case ParameterString(6)
                    CPLocal.Nratio = CPStart.Nratio*Multiplier; 
                    ParameterValues(i) = CPLocal.Nratio;
                    if (i==1)
                        xAxisTitle = "Gear Ratio";
                    end

                case ParameterString(7)
                    CPLocal.CG(1) = CPStart.CG(1)*Multiplier;
                    ParameterValues(i) = CPLocal.CG(1);
                    if (i==1)
                        xAxisTitle = "X position of Center of Gravity (m)";
                    end
                case ParameterString(8)
                    CPLocal.CG(2) = CPStart.CG(2)*Multiplier; 
                    ParameterValues(i) = CPLocal.CG(2);
                    if (i==1)
                        xAxisTitle = "Y position of Center of Gravity (m)";
                    end
            end
            
            
            
                [~, ~,TotalT_AC,~, ~] = LapModel(CPLocal,APLocal,CourseData_AC);
                [~, ~, TotalT_EN, ~, ~, ~, ENScalar, ~, ~] = runEndurance(CPLocal,APLocal,CourseData_EN);
                [~, ~, TotalT_Acc] = AccelSim(CPLocal,APLocal,0.001,75);
                %SectorDataSave(:,:,i) = SectorDataC;

                Score_AC(i) = AutocrossCompScoreCalc(TotalT_AC);
                Score_EN(i) = EnduranceComScoreCalc(TotalT_EN*ENScalar); 
                Score_Acc(i) = AccelerationCompScoreCalc(TotalT_Acc);

                Multiplier = Multiplier + increment;
            
            end
            


 
            % RelScore_AC = TotalT_AC/RefT_AC;
            % RelScore_EN = TotalT_EN/RefT_EN;
            % RelScore_Acc = TotalT_Acc/RefT_Acc;
            % 
            % RelScore_AC = smooth(RelScore_AC);
            % RelScore_EN = smooth(RelScore_EN);
            % RelScore_Acc = smooth(RelScore_Acc);
            
            
            
            %RelScore_Total = RelScore_AC*AC_MaxScore/TotalMaxScore + RelScore_EN*EN_MaxScore/TotalMaxScore + RelScore_Acc*Acc_MaxScore/TotalMaxScore;
            
            TotalScore = Score_Acc + Score_EN + Score_Acc; 
            
            figure;
            plot(ParameterValues,Score_AC);
            title("Autocross");
            xlabel(xAxisTitle)
            ylabel("Event Score")
            figure;
            plot(ParameterValues,Score_EN);
            title("Endurance");
            xlabel(xAxisTitle)
            ylabel("Event Score")
            figure;
            plot(ParameterValues,Score_Acc);
            title("Acceleration");
            xlabel(xAxisTitle)
            ylabel("Event Score")
            figure;
            plot(ParameterValues,TotalScore);
            xlabel(xAxisTitle)
            ylabel("Total Competition Score")
            title("Total Score");



            if detectOS == "macos"
                FolderDir = append(SaveDirectoryLocation,'/',RunName);
                mkdir(FolderDir);
                
                SavedDir = append(SaveDirectoryLocation,'/',RunName,'/');
                save(append(SavedDir,RunName,'.mat'),'ParameterValues','Score_AC','Score_EN','Score_Acc','TotalScore');

            else
            
                FolderDir = append(SaveDirectoryLocation,'\',RunName);
                mkdir(FolderDir);
                
                SavedDir = append(SaveDirectoryLocation,'\',RunName,'\');
                save(append(SavedDir,RunName,'.mat'),'ParameterValues','Score_AC','Score_EN','Score_Acc','TotalScore');
            
            end
            
            
            
end