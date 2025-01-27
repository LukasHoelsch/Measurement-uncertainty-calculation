% WT5000_spec.m
%%%%%%%%%%%%%%%
% Specifications for the Yokogawa WT5000 power analyzer
WT5000.name = 'WT5000';
WT5000.nameCT = 'PM-867-700I';

%% current transducer
% model: PM-867-700I
WT5000.d_CT_lin = 0.00001;      % linearity
WT5000.d_CT_f = 0.0000012;      % frequency influence in 1/Hz
WT5000.d_CT_offset = 0.00004;   % offset
WT5000.d_CT_phi_fix = 0.01;     % angle influence in °
WT5000.d_CT_phi_var = 0.0006;  % angle influence in °/Hz
WT5000.I_CT_MR = 400;           % measuring range in A


%% power analyzer
% This data are taken from the WT5000 manual; 
% 
% Section: Motor evaluation Function
% general accuracy
% WT5000.d_A = 0.0003;            % display value error
% WT5000.d_a_MR = 0.0003;         % measuring range error

% Section: Pulse input
WT5000.d_pulse_1 = 0.0003; % fix value
WT5000.d_pulse_2 = 10*10e8; % frequency dependant value



% Section: 760903 Current Sensor Element Specification
% current
% 
% DC
WT5000.d_current_DC = 0.0002;       % reading
WT5000.d_current_DC_MR = 0.0005;    % measurement range

% 66 Hz < f_el <= and 1 kHz
WT5000.d_current_fund = 0.0003;        % reading
WT5000.d_current_fund_MR = 0.0004;    % measurement range

% 1 kHz < f_el <= and 10 kHz
WT5000.d_current_harm = 0.001;        % reading
WT5000.d_current_harm_MR = 0.0005;    % measurement range

% voltage
%
% DC
WT5000.d_voltage_DC = 0.0002;       % reading
WT5000.d_voltage_DC_MR = 0.0005;    % measurement range
% 66 Hz < f_el <= and 1 kHz
WT5000.d_voltage_fund = 0.0003;        % reading
WT5000.d_voltage_fund_MR = 0.0003;    % measurement range

% 1 kHz < f_el <= and 10 kHz
WT5000.d_voltage_harm = 0.001;        % reading
WT5000.d_voltage_harm_MR = 0.0005;    % measurement range



% measurement range voltage
WT5000.U_MR = 400;     % V, measuring range end value

% measurement range current
WT5000.I_MR = 400;     % A, measuring range end value

% measurement range torque
%WT5000.T_MR = 200;

% measurement range speed
WT5000.n_ME = 11000;


%% New current transducer CT 400 from Signaltec

% WT5000.d_nfw_lin = 0.00000;     % linearity error
% WT5000.d_nfw_fre = 0.000000 ;   % frequency error
% WT5000.d_nfw_off = 0.00000;     % offset error
% WT5000.d_nfw_win1 = 0.01;       % angle error in °
% WT5000.d_nfw_win2 = 0.00000;    % angle error in °/Hz
% WT5000.I_nfw_MB = 400;          % measuring range end value in A