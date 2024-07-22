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


%%
number = 1;


%% Plot
% Basic initializations of the variables which will be plotted later
T_plot = zeros(1,length(i_d_MTPC)*length(i_q_MTPC));
n_plot = zeros(1,length(i_d_MTPC)*length(i_q_MTPC));
U_total_rel = zeros(length(n_ref),length(i_d_MTPC)*length(i_q_MTPC)); 
U_total_abs = zeros(length(n_ref),length(i_d_MTPC)*length(i_q_MTPC));
u_P_mech_rel = zeros(length(n_ref),length(i_d_MTPC)*length(i_q_MTPC));
u_P_mech_abs = zeros(length(n_ref),length(i_d_MTPC)*length(i_q_MTPC));
U_n_plot = zeros(length(n_ref),length(i_d_MTPC)*length(i_q_MTPC));
U_t_plot = zeros(length(n_ref),length(i_d_MTPC)*length(i_q_MTPC));
i_d_plot = zeros(length(n_ref),length(i_d_MTPC)*length(i_q_MTPC));
i_q_plot = zeros(length(n_ref),length(i_d_MTPC)*length(i_q_MTPC));
P_loss_plot = zeros(length(n_ref),length(i_d_MTPC)*length(i_q_MTPC));
U_power_rel = zeros(length(n_ref),length(i_d_MTPC)*length(i_q_MTPC));
U_power_abs = zeros(length(n_ref),length(i_d_MTPC)*length(i_q_MTPC));
P_motor_plot = zeros(length(n_ref),length(i_d_MTPC)*length(i_q_MTPC));
U_loss_rel = zeros(length(n_ref),length(i_d_MTPC)*length(i_q_MTPC));
u_T1_rel_plot = zeros(length(n_ref),length(i_d_MTPC)*length(i_q_MTPC));
u_T2_rel_plot = zeros(length(n_ref),length(i_d_MTPC)*length(i_q_MTPC));
u_T3_rel_plot = zeros(length(n_ref),length(i_d_MTPC)*length(i_q_MTPC));
Loss_inverter_plot = zeros(length(n_ref),length(i_d_MTPC)*length(i_q_MTPC));
U_power_abs = zeros(length(n_ref),length(i_d_MTPC)*length(i_q_MTPC));