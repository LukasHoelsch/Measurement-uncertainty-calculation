% HSM_16_17_12_C01_spec.m
%%%%%%%%%%%%%%%
% Specifications for the Brusa HSM_16_17_12_C01_spec electrical machine

mach_spec.v_DC = 400; % V

mach_spec.p = 3;
mach_spec.Rs = 0.018; % Ohm
mach_spec.P_max = 85000; % W
mach_spec.T_max_calc = 220; % Nm
mach_spec.i_dq_max_calc = 350; % A
mach_spec.T_calc_min = 19; % Nm

% spec to calculate the mechanical losses
mach_spec.D_r = 0.17;   % m
mach_spec.D_ri = 0.054; % m
mach_spec.l_r = 0.12;   % m
mach_spec.rho = 1.2041; % kg/m^3
mach_spec.k = 1;
mach_spec.l_delta = 0.001; % m
mach_spec.mu_f = 0.1;
mach_spec.mu_v = 3.178e-5; 



% inductance
% not necessary, measured flux maps are available
% mach_spec.L_d = ;    % H
% mach_spec.L_q = ;     % H
% 
% % permanent magnet flux
% mach_spec.psi_p = ; % Vs