function [T] = Trq_Map(fit_Torque,i_d,i_q)




T = fit_Torque(i_d,i_q);

% i_q = (3/(2*machine.p))*T/(machine.psi_p + (fit_L));
% 
% 
% for zz=1:1:length(i_d)
%     T(zz) = (5*3/2)*3 *(fit_Psi_d(i_d(zz),i_q(zz))*i_q(zz) - fit_Psi_q(i_d(zz),i_q(zz))*i_d(zz));
% end