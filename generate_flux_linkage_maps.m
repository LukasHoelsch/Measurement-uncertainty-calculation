%% Generate flux linkage and torque maps
% Generate
% flux linkage and torque maps, when no ones are available.
%
%

%% How to
% 1. Change the name of the spec file
% 2. Change the save path
% 3. run the script



project_dir = [fileparts(mfilename('fullpath'))];
project_dir_SpecFiles = [project_dir, '\Spec_Files'];
addpath(project_dir_SpecFiles,'-end');

%% Select spec file
run('IPMSM_350kW_spec.m')


%% Parameters
p = mach_spec.p;
L_d = mach_spec.L_d;
L_q = mach_spec.L_q;
psi_p = mach_spec.psi_p;
i_dq_max_calc = mach_spec.i_dq_max_calc;
v_DC = mach_spec.v_DC;

%% Calculate MTPC
% fixed
dr=1; % A
dphi=1; % °

% create vector
r_vec=0:dr:i_dq_max_calc;
dphi=pi/2:pi/180*dphi:3/2*pi;


for ii=1:1:length(r_vec)
    i_d = r_vec(ii)*cos(dphi);
    i_q = r_vec(ii)*sin(dphi);

    T = 3/2*p*((L_d-L_q).*i_d+psi_p).*i_q;

    [~,idx_min]=min(T);
    [~,idx_max]=max(T);
    minTPC_meas(1:2,ii)=[i_d(idx_min);i_q(idx_min)];
    maxTPC_meas(1:2,ii)=[i_d(idx_max);i_q(idx_max)];

end

i_d_MTPC=[flip(minTPC_meas(1,:)),maxTPC_meas(1,:)];
i_q_MTPC=[flip(minTPC_meas(2,:)),maxTPC_meas(2,:)];


%% Calculation of psi_dq
psi_d = L_d * i_d + psi_p;
psi_q = L_q * i_q;

%% scatteredInterpolant part I
fit_Psi_d = scatteredInterpolant(i_d(1,:)',i_q(1,:)',psi_d(1,:)','linear','none');
fit_Psi_q = scatteredInterpolant(i_d(1,:)',i_q(1,:)',psi_q(1,:)','linear','none');

%% Loss calculation
R_DC = 0.85; % Ohm
P_l_motor = 3.*R_DC.*sqrt(i_d.^2.+i_q.^2).^2;

T_MPTC = 3/2*p*((L_d-L_q).*i_d_MTPC+psi_p).*i_q_MTPC;

%% MTPV
v_max = v_DC*2/pi;
n = 5000;
[i_d_MTPV,i_q_MTPV,T_MTPV,out] =  MTPV_LPV(fit_Psi_d,i_dq_max_calc,v_max,n,p)



%% ScatteredInterpolant part II
fit_Torque = scatteredInterpolant(i_d(1,:)',i_q(1,:)',T(1,:)','linear','none');


%% Save the generated maps
% Change the path here
save("Fitted_Models\IPMSM_350kW\fit_Psi_d","fit_Psi_d");
save("Fitted_Models\IPMSM_350kW\fit_Psi_q","fit_Psi_q");
save("Fitted_Models\IPMSM_350kW\fit_Torque","fit_Torque");



%% Generate meshgrid and LUTs for visualization
[I_d,I_q] = meshgrid(i_d,i_q);
LUT_psi_d = fit_Psi_d(I_d,I_q);
LUT_psi_q = fit_Psi_q(I_d,I_q);


% Visualization
figure(1)
surf(I_d,I_q,LUT_psi_d)
xlabel('$i_{\mathrm{d}}$ in A','Interpreter','latex');
ylabel('$i_{\mathrm{q}}$ in A','Interpreter','latex');
zlabel('$\psi_{\mathrm{d}}$ in Vs','Interpreter','latex');

figure(2)
surf(I_d,I_q,LUT_psi_q);
xlabel('$i_{\mathrm{d}}$ in A','Interpreter','latex');
ylabel('$i_{\mathrm{q}}$ in A','Interpreter','latex');
zlabel('$\psi_{\mathrm{q}}$ in Vs','Interpreter','latex');