% WT3000_spec.m
%%%%%%%%%%%%%%%
% Specifications for the Yokogawa WT3000 power analyzer

% Input parameter

% % Torque and rotational speed signal
% This data are taken from the WT3000 manual 3/3 special functions, 1.10
% Specifications of the Motor Evaluation Function (for DC voltage)
WT3000.d_A = 0.001;             % display value error
WT3000.d_ME = 0.001;            % measuring range error


% % current transducer
% The following information are taken from the current transducer manual
% (Danfysik Ultrastab) and presentations ( not from the WT3000 manual)
WT3000.d_nfw_lin = 0.00001;     % linearity error
WT3000.d_nfw_fre = 0.0000012;   % frequency error
WT3000.d_nfw_off = 0.00004;     % offset error
WT3000.d_nfw_win1 = 0.01;       % angle error in °
WT3000.d_nfw_win2 = 0.00012;    % angle error in °/Hz
WT3000.I_nfw_MB = 700;          % measuring range end value in A

% % accuracy PA 
% This data are taken from the WT3000 manual; Section for the power
% measurement accuracy
WT3000.d_1kHz = 0.0005;     % uncertainty factor for the specified frequency
WT3000.d_10kHz = 0.0015;    %
WT3000.d_50kHz = 0.003;     %
WT3000.d_1MHz = 0.05;       %
%
WT3000.U_MB = 400;      % V, measuring range end value
%


%
% This parameter must maybe controlled global
WT3000.delta_theta = 7; % K, temperatur variation