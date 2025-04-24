% T12HP_spec.m
%%%%%%%%%%%%%%%
% Specifications for the Hottinger Bruel & Kjaer T12HP torque flange
T12HP.name = 'T12HP';

% Input parameter
T12HP.d_c = 0.0005;             % sensitivity tolerance
T12HP.T_n = 500;        % Nm    % nominal torque
T12HP.sigma_rel = 0.00005;      % rel. standard deviation of repeatability
T12HP.d_lh = 0.0001;            % linear deviation including hysteresis


%% output torque
T12HP.f_T0 = 60000; % Hz
T12HP.f_T_nom = 90000; % Hz

%% Rotational speed
T12HP.d_inc = 360; % increments
T12HP.d_n = 0;
