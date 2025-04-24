% IPMSM_350kW_fit.m
%%%%%%%%%%%%%%%
% Load generated fitted files

mach_spec.Psi_d = load([project_dir_FittedModels,'\IPMSM_350kW','\fit_Psi_d.mat']);
mach_spec.Psi_q = load([project_dir_FittedModels,'\IPMSM_350kW','\fit_Psi_q.mat']);
mach_spec.eta = load([project_dir_FittedModels,'\IPMSM_350kW','\fit_eta.mat']);
mach_spec.torque = load([project_dir_FittedModels,'\IPMSM_350kW','\fit_Torque.mat']);



% eta = [90,90,90,90,90,90,90;
%        90,95,96,95,95,94,93;
%        90,96,97,97,96.5,96,95.5;
%        90,96.7,97.2,97,96.3,NaN,NaN;
%        90,96.7,97,95,NaN,NaN,NaN;
%        90,96.3,95.8,NaN,NaN,NaN,NaN;
%        90,96,NaN,NaN,NaN,NaN,NaN];