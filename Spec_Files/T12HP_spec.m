% T12HP_spec.m
%%%%%%%%%%%%%%%
% Specifications for the Hottinger Bruel & Kjaer T12HP torque flange

% Input parameter
T12HP.d_c = 0.0005; % sensitivity tolerance
T12HP.T_n = 500;        % Nm    % nominal torque
T12HP.sigma_rel = 0.00005;      % rel. standard deviation of repeatability
T12HP.d_lh = 0.0001;            % linear deviation including hysteresis
%
% calculation parasitic loads
T12HP.F_a = 25;         % N    % estimation from BT
T12HP.F_r = 5;          % N    % estimation
T12HP.M_b = 0.2;        % Nm   % estimation
T12HP.F_ag = 16000;     % N    % data sheet
T12HP.F_rg = 4000;      % N    % data sheet
T12HP.M_bg = 200;       % Nm   % data sheet
T12HP.d_para2 = 0.001;  %      % data seeht, code W

% output
%torque_T12HP = torqueUncertainty(T12HP,OP);