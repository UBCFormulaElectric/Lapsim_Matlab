% updated motor map demo with datasheet limits

clear; clc; close all;
% Datasheet constants
p       = 5;           % pole pairs
R_s     = 0.135;       % stator resistance [ohm]
Ld      = 0.24e-3;     % [H]
Lq      = 0.12e-3;     % [H]
kt      = 0.26;        % Nm/Arms
J       = 2.74e-4;     % [kg*m^2]

I_max   = 105;         % Arms
V_dc    = 350;         % V (nominal DC bus)
V_margin= 30;          % V reserve margin

% Load MAT files
data80  = load('A2370DD_T80C.mat');
data100 = load('A2370DD_T100C.mat');
data120 = load('A2370DD_T120C.mat');

% Axes setup (hopefully this is right)
rpm_vec = data100.Speed(:,1);          
T_vec   = data100.Shaft_Torque(1,:);   

% Build gridded interpolnts
fields = {'Shaft_Torque','Id_RMS','Iq_RMS','Stator_Current_Phase_RMS',...
          'Vd_RMS','Vq_RMS','Total_Loss','Stator_Copper_Loss',...
          'Iron_Loss','Magnet_Loss','Mechanical_Loss'};

maps80 = struct(); maps100 = struct(); maps120 = struct();

for i = 1:length(fields)
    f = fields{i};
    maps80.(f)  = griddedInterpolant({rpm_vec, T_vec}, data80.(f),  'linear','nearest');
    maps100.(f) = griddedInterpolant({rpm_vec, T_vec}, data100.(f), 'linear','nearest');
    maps120.(f) = griddedInterpolant({rpm_vec, T_vec}, data120.(f), 'linear','nearest');
end

% Temperature blending (temp solution... I think)
tempBlend = @(map80,map120,rpmq,Tq,Tm) ...
    ((max(0,min(1,(Tm-80)/(120-80)))) .* map120(rpmq,Tq) + ...
    (1-max(0,min(1,(Tm-80)/(120-80)))) .* map80(rpmq,Tq));

% Example query (test with limits)
rpm_q  = 8000;   % rpm
Tq_req = 15;     % requested torque [Nm]
Tmotor = 95;     % degC

% Interpolated values
Iq_val = tempBlend(maps80.Iq_RMS, maps120.Iq_RMS, rpm_q, Tq_req, Tmotor);
Id_val = tempBlend(maps80.Id_RMS, maps120.Id_RMS, rpm_q, Tq_req, Tmotor);
Iphase = tempBlend(maps80.Stator_Current_Phase_RMS, maps120.Stator_Current_Phase_RMS, rpm_q, Tq_req, Tmotor);
Vd_val = tempBlend(maps80.Vd_RMS, maps120.Vd_RMS, rpm_q, Tq_req, Tmotor);
Vq_val = tempBlend(maps80.Vq_RMS, maps120.Vq_RMS, rpm_q, Tq_req, Tmotor);
Ploss  = tempBlend(maps80.Total_Loss, maps120.Total_Loss, rpm_q, Tq_req, Tmotor);
Torque = tempBlend(maps80.Shaft_Torque, maps120.Shaft_Torque, rpm_q, Tq_req, Tmotor);

% Enforce current limit
if Iphase > I_max
    scale = I_max / Iphase;
    Iq_val = Iq_val*scale; 
    Id_val = Id_val*scale;
    Torque = Torque*scale;
    Iphase = I_max;
end

% Enforce voltage limit
V_lim = (V_dc - V_margin)/sqrt(3); % approximate phase RMS
V_req = sqrt(Vd_val^2 + Vq_val^2);
if V_req > V_lim
    Torque = Torque * (V_lim/V_req); % scale torque down
end

fprintf('At %.0f rpm, %.1f Nm req, %.0f °C:\n', rpm_q,Tq_req,Tmotor);
fprintf(' -> Torque=%.2f Nm, Iphase=%.1f A, Vreq=%.1f V, Loss=%.1f W\n',...
    Torque,Iphase,V_req,Ploss);

