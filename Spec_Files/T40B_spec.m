% T40B_spec.m
%%%%%%%%%%%%%%%
% Specifications for the Hottinger Bruel & Kjaer T12HP torque flange
T40B.name = 'T40B';

% Input parameter
T40B.d_c = 0.001;             % sensitivity tolerance
T40B.T_n = 500;        % Nm    % nominal torque
T40B.sigma_rel = 0.0003;      % rel. standard deviation of repeatability
T40B.d_lh = 0.0002;            % linear deviation including hysteresis


%% output torque
T40B.f_T0 = 240000; % Hz
T40B.f_T_nom = 360000; % Hz

%% Rotational speed
T40B.d_inc = 360; % increments
T40B.d_n = 0;
