% HSM_16_17_12_C01_spec.m
%%%%%%%%%%%%%%%
% Specifications for the Brusa HSM_16_17_12_C01_spec electrical machine


HSM_16_17_12_C01.Psi_d = load([project_dir_FittedModels,'\fit_Psi_d.mat']);
HSM_16_17_12_C01.Psi_q = load([project_dir_FittedModels,'\fit_Psi_q.mat']);
HSM_16_17_12_C01.losses = load([project_dir_FittedModels,'\fit_lossBrusa.mat']);


HSM_16_17_12_C01.p = 3;
HSM_16_17_12_C01.Rs = 0.018; % Ohm
HSM_16_17_12_C01.P_max = 85000; % W
HSM_16_17_12_C01.T_max_calc = 220; % Nm
HSM_16_17_12_C01.i_dq_max_calc = 350; % A
HSM_16_17_12_C01.T_calc_min = 19; % Nm