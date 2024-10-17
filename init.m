% init.m
%
% Initializing the simulation
project_dir_classFiles = [project_dir, '\Class_Files'];
project_dir_Figures = [project_dir, '\Figures'];
project_dir_FittedModels = [project_dir, '\Fitted_Models'];
project_dir_PlotScrips = [project_dir, '\Plot_Scripts'];
project_dir_SpecFiles = [project_dir, '\Spec_Files'];
project_dir_Functions = [project_dir, '\Functions']

% add path to search path
addpath(project_dir_classFiles,'-end');
addpath(project_dir_FittedModels,'-end');
addpath(project_dir_PlotScrips,'-end');
addpath(project_dir_SpecFiles,'-end');
addpath(project_dir_Functions,'-end')


%% Loading all available spec files
%% Torque sensor
% HBM - T10FS
run('T10FS_spec.m')

% HBM - T12HP
run('T12HP_spec.m')


%% Torque measuring amplifier
% ML60B
run('ML60B_spec.m')

%% Power analyzer
% WT3000
run('WT3000_spec.m')

% WT5000
run('WT5000_spec.m')

%% Inverter
run('SkiiP_1242GB120_4D_spec')
run('FS02MR12A8MA2B_spec')

load([project_dir_FittedModels,'\fit_E_on.mat'])
load([project_dir_FittedModels,'\fit_E_off.mat'])


%% motor spec
run('HSM_16_17_12_C01_spec.m');

% Load fit_Torque
load([project_dir_FittedModels,'\fit_Torque.mat'])

% Load fit_Psi_dq
load([project_dir_FittedModels,'\fit_Psi_d.mat'])
load([project_dir_FittedModels,'\fit_Psi_q.mat'])