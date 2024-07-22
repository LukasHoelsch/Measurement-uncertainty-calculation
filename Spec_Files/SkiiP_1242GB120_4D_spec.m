% SkiiP_1242GB120_4D_spec.m
%%%%%%%%%%%%%%%
% Specifications of the IGBT inverter module

%% Inverter
% Basic initializations for the inverter model
SkiiP_1242GB120_4D.f_sw = 8000; % Hz

% In the data sheet only the sum of these two values (E_sum) are given.
% Therfore, the following values are only assumptions
SkiiP_1242GB120_4D.E_on = 15e-3; % J
SkiiP_1242GB120_4D.E_off = 15e-3; % J

SkiiP_1242GB120_4D.E_sum = SkiiP_1242GB120_4D.E_on + SkiiP_1242GB120_4D.E_off;

% Collector Emitter voltage
SkiiP_1242GB120_4D.U_ce = 2.6; % V

% Collector Emitter resistance
SkiiP_1242GB120_4D.r_ce = 1.3e-3; % Ohm