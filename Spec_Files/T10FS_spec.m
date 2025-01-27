% T10FS_spec.m
%%%%%%%%%%%%%%%
% Specifications for the Hottinger Bruel & Kjaer T10FS torque flange

%% Torque
% Input parameter
T10FS.d_c = 0.001;              % sensitivity tolerance
T10FS.T_n = 2000;       % Nm    % nominal torque
T10FS.sigma_rel = 0.0002;       % rel. standard deviation of repeatability
T10FS.d_lh = 0.0003;            % linear deviation including hysteresis

%% Rotational speed
% Input prameter
T10FS.d_n_p = 0;    % non-linearity (voltage output)