function out = motor_map_model_function(rpm_q, Tq_req, maps100, limits)

%function out = motor_map_model_function(rpm_q, Tq_req, Tmotor, maps80, maps120, limits)

% Inputs:
%   rpm_q   - mechanical speed [rpm]
%   Tq_req  - torque request [Nm]
%   Tmotor  - motor temperature [°C] assume constant 100C
%   maps80  - struct of griddedInterpolants (80 °C)
%   maps120 - struct of griddedInterpolants (120 °C)
%   limits  - struct with fields:
%                I_max, V_dc, V_margin
% Outputs:
%   out struct with fields: Iq, Id, Iphase, Vd, Vq, Torque, Ploss
%   Iq = 

    %{
    alpha = max(0,min(1,(Tmotor-80)/(120-80)));
    % Interpolated values
    Iq_val = (1-alpha)*maps80.Iq_RMS(rpm_q,Tq_req)   + alpha*maps120.Iq_RMS(rpm_q,Tq_req);
    Id_val = (1-alpha)*maps80.Id_RMS(rpm_q,Tq_req)   + alpha*maps120.Id_RMS(rpm_q,Tq_req);
    Iphase = (1-alpha)*maps80.Stator_Current_Phase_RMS(rpm_q,Tq_req) ...
                    + alpha*maps120.Stator_Current_Phase_RMS(rpm_q,Tq_req);
    Vd_val = (1-alpha)*maps80.Vd_RMS(rpm_q,Tq_req)   + alpha*maps120.Vd_RMS(rpm_q,Tq_req);
    Vq_val = (1-alpha)*maps80.Vq_RMS(rpm_q,Tq_req)   + alpha*maps120.Vq_RMS(rpm_q,Tq_req);
    Torque = (1-alpha)*maps80.Shaft_Torque(rpm_q,Tq_req) + alpha*maps120.Shaft_Torque(rpm_q,Tq_req);
    Ploss  = (1-alpha)*maps80.Total_Loss(rpm_q,Tq_req)   + alpha*maps120.Total_Loss(rpm_q,Tq_req);
    %}
    %we already assume temp is always at 100 C
    Iq_val = maps100.Iq_RMS(rpm_q,Tq_req);
    Id_val = maps100.Id_RMS(rpm_q,Tq_req);
    Iphase = maps100.Stator_Current_Phase_RMS(rpm_q,Tq_req);
    Vd_val = maps100.Vd_RMS(rpm_q,Tq_req);
    Vq_val = maps100.Vq_RMS(rpm_q,Tq_req);
    Torque = maps100.Shaft_Torque(rpm_q,Tq_req);
    Ploss  = maps100.Total_Loss(rpm_q,Tq_req);


    % Current limit
    if Iphase > limits.I_max
        scale   = limits.I_max / Iphase;
        Iq_val  = Iq_val*scale; 
        Id_val  = Id_val*scale;
        Torque  = Torque*scale;
        Iphase  = limits.I_max;
    end

    % Voltage limit
    V_lim = (limits.V_dc - limits.V_margin)/sqrt(3);
    V_req = sqrt(Vd_val^2 + Vq_val^2);
    if V_req > V_lim
        Torque = Torque * (V_lim/V_req);
    end

    % Pack output
    out.Iq = Iq_val;
    out.Id = Id_val;
    out.Iphase = Iphase;
    out.Vd = Vd_val;
    out.Vq = Vq_val;
    out.Torque = Torque;
    out.Ploss = Ploss;
    out.Vreq = V_req;
end


