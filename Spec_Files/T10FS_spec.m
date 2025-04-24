% T10FS_spec.m
%%%%%%%%%%%%%%%
% Specifications for the Hottinger Bruel & Kjaer T10FS torque flange
T10FS.name='T10FS';

%% Torque
% Input parameter
T10FS.d_c = 0.001;              % sensitivity tolerance
T10FS.T_n = 2000;       % Nm    % nominal torque
T10FS.sigma_rel = 0.0002;       % rel. standard deviation of repeatability
T10FS.d_lh = 0.0003;            % linear deviation including hysteresis

%% output torque
T10FS.f_T0 = 10000; % Hz
T10FS.f_T_nom = 15000; % Hz

%% Rotational speed
T10FS.d_inc = 360; % increments
T10FS.d_n = 0;
