% T12HP_spec.m
%%%%%%%%%%%%%%%
% Specifications for the Hottinger Bruel & Kjaer T12HP torque flange

% Input parameter
T12HP.d_c = 0.0005;             % sensitivity tolerance
T12HP.T_n = 200;        % Nm    % nominal torque
T12HP.sigma_rel = 0.00005;      % rel. standard deviation of repeatability
T12HP.d_lh = 0.0001;            % linear deviation including hysteresis

%% Rotational speed
% Input prameter
T10FS.d_n_p = 0.05;  % mm    % DS
T10FS.d_n_s = 0.05;  % mm    % DS
T10FS.D = 175;      % mm    % DS