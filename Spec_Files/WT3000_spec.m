% WT3000_spec.m
%%%%%%%%%%%%%%%
% Specifications for the Yokogawa WT3000 power analyzer

% Input parameter

% % Torque and rotational speed signal
% This data are taken from the WT3000 manual 3/3 special functions, 1.10
% Specifications of the Motor Evaluation Function (for DC voltage)
WT3000.d_A = 0.001;             % display value error
WT3000.d_a_MR = 0.001;            % measuring range error


%% current transducer
% model: PM-867-700I
WT5000.d_CT_lin = 0.00001;        % linearity
WT5000.d_CT_f = 0.0000012;        % frequency influence in 1/kHz
WT5000.d_CT_offset = 0.00004;     % offset
WT5000.d_CT_phi_fix = 0.01;       % angle influence in °
WT5000.d_CT_phi_var = 0.00012;    % angle influence in °/Hz
WT5000.I_CT_MR = 700;             % measuring range in A

% % accuracy PA 
% This data are taken from the WT3000 manual; Section for the power
% measurement accuracy
WT3000.d_1kHz = 0.0005;     % uncertainty factor for the specified frequency
WT3000.d_10kHz = 0.0015;    %
WT3000.d_50kHz = 0.003;     %
WT3000.d_1MHz = 0.05;       %
%
WT3000.U_MB = 400;      % V, measuring range end value
WT3000.delta_theta = 7; % K, temperatur variation

WT3000.T_MR = 200;
WT3000.n_ME = 12000;
