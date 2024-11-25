% createFluxLinkageMaps.m
%%%%%%%%%%%%%%%
% Function to create the flux linkage maps with given parameters in the data sheet.
%clear;
clc;

run([project_dir,'\Spec_Files\IPMSM_spec.m'])


% fixed
dr=1; % A
dphi=1; % °

% create vector
r_vec=0:dr:IPMSM.i_dq_max_calc;
dphi=pi/2:pi/180*dphi:3/2*pi;


for ii=1:1:length(r_vec)
    i_d = r_vec(ii)*cos(dphi);
    i_q = r_vec(ii)*sin(dphi);

    T = 3/2*IPMSM.p*((IPMSM.L_d-IPMSM.L_q).*i_d+IPMSM.psi_p).*i_q;

    [~,idx_min]=min(T);
    [~,idx_max]=max(T);
    minTPC_meas(1:2,ii)=[i_d(idx_min);i_q(idx_min)];
    maxTPC_meas(1:2,ii)=[i_d(idx_max);i_q(idx_max)];

end

i_d_MTPC=[flip(minTPC_meas(1,:)),maxTPC_meas(1,:)];
i_q_MTPC=[flip(minTPC_meas(2,:)),maxTPC_meas(2,:)];


%% Calculation of psi_dq
psi_d = IPMSM.L_d * i_d + IPMSM.psi_p;
psi_q = IPMSM.L_q * i_q;

%% scatteredInterpolant part I
fit_Psi_d = scatteredInterpolant(i_d(1,:)',i_q(1,:)',psi_d(1,:)','linear','none');
fit_Psi_q = scatteredInterpolant(i_d(1,:)',i_q(1,:)',psi_q(1,:)','linear','none');

%% Loss calculation
R_DC = 0.85; % Ohm
P_l_motor = 3.*R_DC.*sqrt(i_d.^2.*i_q.^2);

T_MPTC = 3/2*IPMSM.p*((IPMSM.L_d-IPMSM.L_q).*i_d_MTPC+IPMSM.psi_p).*i_q_MTPC;

%% MTPV
n = 5000;
[i_d_MTPV,i_q_MTPV,T_MTPV,out] =  MTPV_LPV(fit_Psi_d,IPMSM.i_dq_max_calc,v_DC,n,IPMSM.p)



%% ScatteredInterpolant part II
fit_Torque = scatteredInterpolant(i_d(1,:)',i_q(1,:)',T(1,:)','linear','none');
fit_eta = scatteredInterpolant(T_rand(1,:)',n_rand(1,:)',eta(1,:)','linear','none');

%% Save
save("Fitted_Models\AMK_IPMSM\fit_Psi_d","fit_Psi_d");
save("Fitted_Models\AMK_IPMSM\fit_Psi_q","fit_Psi_q");
save("Fitted_Models\AMK_IPMSM\fit_Torque","fit_Torque");
save("Fitted_Models\AMK_IPMSM\fit_eta","fit_eta");

%% Generate meshgrid and LUTs for visualization
[I_d,I_q] = meshgrid(i_d,i_q);
LUT_psi_d = fit_Psi_d(I_d,I_q);
LUT_psi_q = fit_Psi_q(I_d,I_q);


%% Visualization
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


% figure(3)
% surf(T_rand_,n_rand_,eta_);
% xlabel('$i_{\mathrm{d}}$ in A','Interpreter','latex');
% ylabel('$i_{\mathrm{q}}$ in A','Interpreter','latex');
% zlabel('$\eta$ in %','Interpreter','latex');
% 











