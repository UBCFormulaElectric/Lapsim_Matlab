function runSweep(SelectedParameter, SweepRange, CP, AP, CourseData_AC, ...
    CourseData_EN, SweepPoints, SaveDirectoryLocation, RunName, ModelOptions)
%RUNSWEEP Sweep a vehicle parameter and calculate event scores.
% The optional tenth argument is the same options struct used by LapModel
% and runEndurance. Nine-argument dashboard calls remain supported.

    if nargin < 10 || isempty(ModelOptions)
        ModelOptions = struct('start_velocity', 0, 'stop_velocity', -1, ...
            'four_wheel_drive', false);
    end
    requiredOptions = {'start_velocity','stop_velocity','four_wheel_drive'};
    if ~isstruct(ModelOptions) || ~isscalar(ModelOptions) || ...
            ~all(isfield(ModelOptions, requiredOptions))
        error('runSweep:InvalidOptions', ...
            'ModelOptions must contain start_velocity, stop_velocity and four_wheel_drive.');
    end
    validateattributes(SweepPoints, {'numeric'}, ...
        {'scalar','integer','positive','finite'});
    validateattributes(SweepRange, {'numeric'}, ...
        {'scalar','real','nonnegative','finite'});

    SelectedParameter = string(SelectedParameter);
    parameterNames = ["TireCf", "CarMass", "Rtire", "Pmax", "Tmax", ...
        "Nratio", "CGx", "CGz"];
    if ~isscalar(SelectedParameter) || ~any(SelectedParameter == parameterNames)
        error('runSweep:UnknownParameter', 'Unsupported sweep parameter.');
    end

    % Include both ends of the requested range. A single point is baseline.
    if SweepPoints == 1
        multipliers = 1;
    else
        multipliers = linspace(1-SweepRange/100, 1+SweepRange/100, SweepPoints);
    end

    if SelectedParameter == "Tmax"
        warning('runSweep:UnusedTorqueLimit', ...
            ['The current LapModel uses motor-map limits, not CP.Tmax. ', ...
             'Autocross and endurance may be insensitive to this sweep.']);
    elseif SelectedParameter == "TireCf"
        warning('runSweep:LimitedTireCf', ...
            ['The current LapModel uses CP.TireCf only below its low-speed ', ...
             'threshold; Pacejka parameters control grip at higher speeds.']);
    end

    ParameterValues = zeros(SweepPoints,1);
    Score_AC = zeros(SweepPoints,1);
    Score_EN = zeros(SweepPoints,1);
    Score_Acc = zeros(SweepPoints,1);
    Time_AC = zeros(SweepPoints,1);
    Time_EN = zeros(SweepPoints,1);
    Time_Acc = zeros(SweepPoints,1);
    Energy_AC = zeros(SweepPoints,1);
    ENScalars = zeros(SweepPoints,1);
    accelDistance = 75;
    accelDt = 0.001;

    for i = 1:SweepPoints
        % Every run begins from the original vehicle parameters.
        CPLocal = CP;
        APLocal = AP;
        multiplier = multipliers(i);

        switch SelectedParameter
            case "TireCf"
                CPLocal.TireCf = CP.TireCf*multiplier;
                ParameterValues(i) = CPLocal.TireCf;
                xAxisTitle = "Tire Coefficient of Friction";
            case "CarMass"
                CPLocal.CarMass = CP.CarMass*multiplier;
                ParameterValues(i) = CPLocal.CarMass;
                xAxisTitle = "Car Mass (kg)";
            case "Rtire"
                CPLocal.Rtire = CP.Rtire*multiplier;
                ParameterValues(i) = CPLocal.Rtire;
                xAxisTitle = "Tire Radius (m)";
            case "Pmax"
                CPLocal.Pmax = CP.Pmax*multiplier;
                ParameterValues(i) = CPLocal.Pmax;
                xAxisTitle = "Maximum Power (W)";
            case "Tmax"
                CPLocal.Tmax = CP.Tmax*multiplier;
                ParameterValues(i) = CPLocal.Tmax;
                xAxisTitle = "Maximum Torque (Nm)";
            case "Nratio"
                CPLocal.Nratio = CP.Nratio*multiplier;
                ParameterValues(i) = CPLocal.Nratio;
                xAxisTitle = "Gear Ratio";
            case "CGx"
                CPLocal.CG(1) = CP.CG(1)*multiplier;
                ParameterValues(i) = CPLocal.CG(1);
                xAxisTitle = "Longitudinal CG Position (m)";
            case "CGz"
                CPLocal.CG(2) = CP.CG(2)*multiplier;
                ParameterValues(i) = CPLocal.CG(2);
                xAxisTitle = "CG Height (m)";
        end

        if CPLocal.CarMass <= 0 || CPLocal.Rtire <= 0 || ...
                CPLocal.Nratio <= 0 || CPLocal.CG(1) <= 0 || ...
                CPLocal.CG(1) >= CPLocal.WheelBase || CPLocal.CG(2) < 0 || ...
                CPLocal.Pmax < 0 || CPLocal.TireCf < 0 || CPLocal.Tmax < 0
            error('runSweep:InvalidVehicle', ...
                'Sweep point %d produces invalid vehicle parameters.', i);
        end

        fprintf('Sweep %d/%d: %s = %.6g\n', i, SweepPoints, ...
            char(SelectedParameter), ParameterValues(i));

        % Updated four-argument lap and endurance interfaces.
        [~, ~, Time_AC(i), ~, Energy_AC(i)] = ...
            LapModel(CPLocal, APLocal, CourseData_AC, ModelOptions);
        [~, ~, Time_EN(i), ~, ~, ~, ENScalars(i), ~, ~] = ...
            runEndurance(CPLocal, APLocal, CourseData_EN, ModelOptions);

        % AccelSim's first output is the result matrix used by the app:
        % column 12 = distance (m); column 13 = time (s).
        if nargout('AccelSim') >= 3
            % Preserve the explicit elapsed-time output when available.
            [~, ~, Time_Acc(i)] = AccelSim(CPLocal, APLocal, accelDt, accelDistance);
        else
            accelResults = AccelSim(CPLocal, APLocal, accelDt, accelDistance);
            if size(accelResults,2) < 13 || isempty(accelResults)
                error('runSweep:InvalidAccelResults', ...
                    'AccelSim must return a matrix with distance and time in columns 12 and 13.');
            end
            pos = accelResults(:,12);
            t = accelResults(:,13);
            finish = find(pos >= accelDistance, 1, 'first');
            if isempty(finish)
                error('runSweep:AccelerationIncomplete', ...
                    'AccelSim did not reach %.1f m at sweep point %d.', accelDistance, i);
            elseif finish == 1 || pos(finish) == pos(finish-1)
                Time_Acc(i) = t(finish);
            else
                Time_Acc(i) = t(finish-1) + (t(finish)-t(finish-1))* ...
                    (accelDistance-pos(finish-1))/(pos(finish)-pos(finish-1));
            end
        end

        Score_AC(i) = CompScoring.AutocrossCompScoreCalc(Time_AC(i));
        Score_EN(i) = CompScoring.EnduranceComScoreCalc(Time_EN(i)*ENScalars(i));
        Score_Acc(i) = CompScoring.AccelerationCompScoreCalc(Time_Acc(i));
    end

    % Include each event exactly once. Efficiency scoring is not included.
    TotalScore = Score_AC + Score_EN + Score_Acc;

    plotScore(ParameterValues, Score_AC, xAxisTitle, "Autocross", "Event Score");
    plotScore(ParameterValues, Score_EN, xAxisTitle, "Endurance", "Event Score");
    plotScore(ParameterValues, Score_Acc, xAxisTitle, "Acceleration", "Event Score");
    plotScore(ParameterValues, TotalScore, xAxisTitle, "Total Score", ...
        "Total Competition Score");

    FolderDir = fullfile(SaveDirectoryLocation, RunName);
    if ~isfolder(FolderDir)
        mkdir(FolderDir);
    end
    save(fullfile(FolderDir, string(RunName)+".mat"), ...
        'ParameterValues','Score_AC','Score_EN','Score_Acc','TotalScore', ...
        'Time_AC','Time_EN','Time_Acc','Energy_AC','ENScalars','ModelOptions', ...
        'SelectedParameter','SweepRange','SweepPoints');
end

function plotScore(x,y,xLabel,plotTitle,yLabel)
    figure;
    plot(x,y,'-o');
    title(plotTitle);
    xlabel(xLabel);
    ylabel(yLabel);
    grid on;
end
