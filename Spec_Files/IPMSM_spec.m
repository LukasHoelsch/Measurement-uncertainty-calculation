% IPMSM_spec.m
%%%%%%%%%%%%%%%
% Specifications of the IPMSM

% not availabe before the first run of the "add_new_motor.m" file
IPMSM.Psi_d = load([project_dir_FittedModels,'\AMK_IPMSM','\fit_Psi_d.mat']);
IPMSM.Psi_q = load([project_dir_FittedModels,'\AMK_IPMSM','\fit_Psi_q.mat']);
IPMSM.eta = load([project_dir_FittedModels,'\AMK_IPMSM','\fit_eta.mat']);
IPMSM.torque = load([project_dir_FittedModels,'\AMK_IPMSM','\fit_Torque.mat']);



IPMSM.L_d = 0.00445;    % H
IPMSM.L_q = 0.0063;     % H

% permanent magnet flux
IPMSM.psi_p = 0.05; % Vs % estimati

IPMSM.p = 5; % pole pair number
IPMSM.Rs = 0.85; % Ohm
IPMSM.P_max = 15000; % W
IPMSM.T_max_calc = 40; % Nm
IPMSM.i_dq_max_calc = 25; % A
IPMSM.T_calc_min = 1; % Nm