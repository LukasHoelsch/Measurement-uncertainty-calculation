% CreateTorqueFitFunction.m
%% CreateTorqueFit
% This script is used to calculate a fitted model of the torque.

%% 
clear;
clc;

%% load
load('C:\Users\lhoelsch\sciebo\Publikationen\02_MeasurementUncertainty\Berechnung_matlab\Archive\fit_Ldd.mat');
load('C:\Users\lhoelsch\sciebo\Publikationen\02_MeasurementUncertainty\Berechnung_matlab\Archive\fit_Lqq.mat');
load('C:\Users\lhoelsch\sciebo\Publikationen\02_MeasurementUncertainty\Berechnung_matlab\Archive\LUT_data.mat');

load('C:\Users\lhoelsch\sciebo\Publikationen\02_MeasurementUncertainty\Berechnung_matlab\Fitted_Models\fit_Psi_d.mat');
load('C:\Users\lhoelsch\sciebo\Publikationen\02_MeasurementUncertainty\Berechnung_matlab\Fitted_Models\fit_Psi_q.mat');




%%
pmsm.p = 3;
pmsm.L_dd = L_dd;
pmsm.L_qq = L_qq;
pmsm.psi_p = 0.068; % Vs

%% 

for ii=1:1:length(i_q_vec)
    for zz=1:1:length(i_d_vec)
   
        % use the following torque calculation
        T_psi(ii,zz) = (3/2) * pmsm.p * (fit_Psi_d(i_d_vec(zz),i_q_vec(ii)) * i_q_vec(ii) - fit_Psi_q(i_d_vec(zz),i_q_vec(ii)) * i_d_vec(zz));
    end

end

%% 
% The following calculation for the torque T does not work. Maybe due to
% the cross coupling of the machine
%
% T(ii,zz) = (3/2)*pmsm.p*(fit_Ldd(i_d_vec(zz),i_q_vec(ii))-fit_Lqq(i_d_vec(zz),i_q_vec(ii)))*i_d_vec(zz)*i_q_vec(ii) + ...
%             (3/2) * pmsm.p *pmsm.psi_p*i_q_vec(ii);
% 
% T_reluktanz(ii,zz) =  3*pmsm.p/2*(fit_Ldd(i_d_vec(zz),i_q_vec(ii))-fit_Lqq(i_d_vec(zz),i_q_vec(ii)))*i_d_vec(zz)*i_q_vec(ii);
%
% The calculation of the Lorentz force looks good
% T_lorentz(ii,zz) =  3*pmsm.p/2*pmsm.psi_p*i_q_vec(ii);

