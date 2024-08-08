% WT5000_spec.m
%%%%%%%%%%%%%%%
% Specifications for the Yokogawa WT5000 power analyzer

WT5000.d_A = 0.00045;           % display value error
WT5000.d_ME = 0.0003;           % measuring range error

% current transducer
WT5000.d_nfw_lin = 0.00001;     % linearity error
WT5000.d_nfw_fre = 0.0000012;   % frequency error
WT5000.d_nfw_off = 0.00004;     % offset error
WT5000.d_nfw_win1 = 0.01;       % angle error in °
WT5000.d_nfw_win2 = 0.00012;    % angle error in °/Hz
WT5000.I_nfw_MB = 700;          % measuring range end value in A

% % accuracy power analyzer
% This data are taken from the WT3000 manual; Section for the power
% measurement accuracy
WT5000.d_1kHz = 0.0005;     % uncertainty factor for the specified frequency
WT5000.d_10kHz = 0.0015;    %
WT5000.d_50kHz = 0.003;     %
WT5000.d_1MHz = 0.05;       %
%
WT5000.U_MB = 400;      % V, measuring range end value
WT5000.delta_theta = 7; % K, temperatur variation

WT5000.T_ME = 200;
WT5000.n_ME = 12000;


%% New current transducer CT 400 from Signaltec
% WT5000.d_nfw_lin = 0.00000;     % linearity error
% WT5000.d_nfw_fre = 0.000000 ;   % frequency error
% WT5000.d_nfw_off = 0.00000;     % offset error
% WT5000.d_nfw_win1 = 0.01;       % angle error in °
% WT5000.d_nfw_win2 = 0.00000;    % angle error in °/Hz
% WT5000.I_nfw_MB = 400;          % measuring range end value in A