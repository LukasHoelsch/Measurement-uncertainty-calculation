% T12HP_Tn500Nm_spec.m
%%%%%%%%%%%%%%%
% Specifications for the Hottinger Bruel & Kjaer T12HP torque flange
T12HP_Tn500Nm.name = 'T12HP_Tn500Nm';

% Input parameter
T12HP_Tn500Nm.d_c = 0.0005;             % sensitivity tolerance
T12HP_Tn500Nm.T_n = 500;        % Nm    % nominal torque
T12HP_Tn500Nm.sigma_rel = 0.00005;      % rel. standard deviation of repeatability
T12HP_Tn500Nm.d_lh = 0.0001;            % linear deviation including hysteresis


%% output torque
T12HP_Tn500Nm.f_T0 = 60000; % Hz
T12HP_Tn500Nm.f_T_nom = 90000; % Hz

%% Rotational speed
T12HP_Tn500Nm.d_inc = 360; % increments
T12HP_Tn500Nm.d_n = 0;
