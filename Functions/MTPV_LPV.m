%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% MTPV_LPV.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [i_d_MTPV,i_q_MTPV,T_MTPV,out] = MTPV_LPV(fit_Psi_d,i_max,U_max,n,p)


% assumption
L_s = 3e-4; % H


i_0 = fit_Psi_d(0,0)/L_s;


omega_0 = U_max/fit_Psi_d(0,0);

omega = 2*pi*n/60*p;

w = omega/omega_0;

% necessary field weakening current
i_d_MTPV = -i_0/2 *(1-1/w^2)-i_max^2/(2*i_0);


%
k = fit_Psi_d(0,0)/(L_s*i_max); 

% torque generating current
i_q_MTPV = i_max*sqrt(1-1/4*(1/k + k*(1-1/w^2))^2);


% resuting
% maximal torque in this area
T_MTPV = 3/2*p*fit_Psi_d(0,0)*i_max*sqrt(1-1/4*(1/k+k*(1-1/w^2))^2);


out = [i_0,omega_0,omega,w];