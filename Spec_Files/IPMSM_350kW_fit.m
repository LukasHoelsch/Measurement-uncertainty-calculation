% IPMSM_350kW_fit.m
%%%%%%%%%%%%%%%
% Load generated fitted files

mach_spec.Psi_d = load([project_dir_FittedModels,'\IPMSM_350kW','\fit_Psi_d.mat']);
mach_spec.Psi_q = load([project_dir_FittedModels,'\IPMSM_350kW','\fit_Psi_q.mat']);
%mach_spec.eta = load([project_dir_FittedModels,'\IPMSM_350kW','\fit_eta.mat']);
mach_spec.torque = load([project_dir_FittedModels,'\IPMSM_350kW','\fit_Torque.mat']);