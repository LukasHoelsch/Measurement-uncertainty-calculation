% HSM_16_17_12_C01_fit.m
%%%%%%%%%%%%%%%
% Load generated fitted files for the HSM_16_17_12_C01 electrical machine

mach_spec.Psi_d = load([project_dir_FittedModels,'\HSM_16_17_12_C01','\fit_Psi_d.mat']);
mach_spec.Psi_q = load([project_dir_FittedModels,'\HSM_16_17_12_C01','\fit_Psi_q.mat']);
mach_spec.eta = load([project_dir_FittedModels,'\HSM_16_17_12_C01','\fit_eta.mat']);
mach_spec.torque = load([project_dir_FittedModels,'\HSM_16_17_12_C01','\fit_Torque.mat']);