% T10FS_spec.m
%%%%%%%%%%%%%%%
% Specifications for the Hottinger Bruel & Kjaer T10FS torque flange

%% Torque
% Input parameter
T10FS.d_c = 0.001;              % DS
T10FS.T_n = 2000;       % Nm    % DS
T10FS.sigma_rel = 0.0002;       % DS
T10FS.d_lh = 0.0003;            % DS
T10FS.F_a = 25;         % Nm    % BT
T10FS.F_r = 5;          % Nm    % BT
T10FS.M_b = 0.2;        % Nm    % BT
T10FS.F_ag = 39000;     % Nm    % BT
T10FS.F_rg = 9000;      % Nm    % BT
T10FS.M_bg = 560;       % Nm    % BT
T10FS.d_para2 = 0.003;  %       % BT
% 
% Output
% u_T1 % Nm

%% Rotational speed
% Input prameter
T10FS.d_np = 0.05;  % mm    % DS
T10FS.d_ns = 0.05;  % mm    % DS
T10FS.pulse = 360;  %       % DS
T10FS.D = 175;      % mm    % DS
%
% Output parameter
% u_n1 % 1/min