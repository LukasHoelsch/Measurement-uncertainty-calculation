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


% inductance
% not necessary, measured flux maps are available
% mach_spec.L_d = ;    % H
% mach_spec.L_q = ;     % H
% 
% % permanent magnet flux
% mach_spec.psi_p = ; % Vs