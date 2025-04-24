% Kistler_4551A_spec.m
%%%%%%%%%%%%%%%
% Specifications for the Kistler 4551A torque flange

%% Torque
% Input parameter
Kistler_4551A.d_c = 0.0000;             % sensitivity tolerance
Kistler_4551A.T_n = 50;        % Nm     % nominal torque
Kistler_4551A.sigma_rel = 0.0003;       % rel. standard deviation of repeatability
Kistler_4551A.d_lh = 0.0002;            % linear deviation including hysteresis


%% output torque
Kistler_4551A.f_T0 = 240000; % Hz
Kistler_4551A.f_T_nom = 360000; % Hz


%% Rotational speed
% Input prameter
Kistler_4551A.d_inc = 360; % increments, up to 8192 possible
Kistler_4551A.d_n = 0;
