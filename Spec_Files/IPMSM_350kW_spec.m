%% 350 kW IPMSM
% The data for this machine is taken form the publication: Zou at all., "Airgap Length Analysis of a 350 kw PM-Assisted
% Syn-Rel Machine for Heavy Duty EV Traction", IEEE Trans. on ind.
% applications, vol.59 no.2, pp.1557-1570, 2023
% 


mach_spec.v_DC = 650; % V

mach_spec.p = 8; % pole pair number
mach_spec.Rs = 0.85; % Ohm % estimation, no available in the publication
mach_spec.P_max = 350000; % W
mach_spec.T_max_calc = 580; % Nm
mach_spec.i_dq_max_calc = 330; % A
mach_spec.T_calc_min = 10; % Nm

% inductance
mach_spec.L_d = 0.0009;    % H
mach_spec.L_q = 0.0024;     % H

% permanent magnet flux
mach_spec.psi_p = 0.24; % Vs