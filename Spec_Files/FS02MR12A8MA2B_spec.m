% FS02MR12A8MA2B.m
%%%%%%%%%%%%%%%
% Specifications of the SiC inverter module
%
% generating of a fitted model with this data

%% General informations
% V_DSS = 1200 V
% I_DN = 390 A



FS02MR12A8MA2B.fit_E_on = load([project_dir_FittedModels,'\fit_E_on.mat']);
FS02MR12A8MA2B.fit_E_off = load([project_dir_FittedModels,'\fit_E_off.mat']);



%% Loss characteristic
% For the data extraction, T_vj = 125 °C is used.

% conduction loss
% FS02MR12A8MA2B.R_ds_on = 0.0032; % ohm
% 
% % current vector, sampling points
% FS02MR12A8MA2B.I_on = [44.82758620689655, 82.68199233716474, 125.51724137931033, 182.29885057471265, ...
%     243.06513409961684, 329.7318007662835, 398.46743295019155, 463.2183908045977, ...
%     523.9846743295019, 586.743295019157, 648.5057471264367, 706.2835249042146, ...
%     757.088122605364];
% 
% 
% FS02MR12A8MA2B.I_off = [41.839080459770116, 81.68582375478927, 119.54022988505747,165.3639846743295,...
%     204.21455938697318, 248.04597701149424, 297.8544061302682, 359.6168582375479, ...
%     422.37547892720306, 482.1455938697318, 539.9233716475096, 613.639846743295, ...
%     669.4252873563219, 717.2413793103448];
% 
% 
% 
% % switching loss
% FS02MR12A8MA2B.E_on = [0.5357142857142857, 1.5178571428571428, 2.767857142857143, 4.375, ...
%     6.607142857142858, 9.910714285714286, 12.589285714285715, 15.625, ...
%     18.482142857142858, 21.607142857142858, 24.821428571428573, ...
%     27.857142857142858,31.160714285714285]*10e-3; % J
% 
% FS02MR12A8MA2B.E_off = [3.758389261744967, 6.532438478747204, 9.395973154362416, 13.064876957494407, ...
%     16.107382550335572, 19.68680089485459, 23.71364653243848, 29.082774049217004, ...
%     34.45190156599553, 39.6420581655481, 45.19015659955257, 51.54362416107383, ...
%     56.7337807606264, 61.923937360178975]*10e-3; % J




