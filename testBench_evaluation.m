%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% File: testBench_evaluation.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Date: 24.11.2023
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Description: 1. Calculation of the measurement uncertainty for the
%                 measuring chain at the test bench
%              2. The calculation for each component is written down in a
%              own class, so an easy change of the devices is possible and
%              recomended.
%
% Abbreviations
% DS    = data sheet
% BT    = bachelor thesis (Knipping)
% nfw   = Nullflusswandler = current transducer


close all
clearvars -except;
clc;

% Get project directories
project_dir = [fileparts(mfilename('fullpath'))];



%% Setting the operation range
% number of current values
i_d_MTPC = zeros(6);
i_q_MTPC = zeros(6);

% maximal torque
T_max = 180; % Nm

% minimal speed
n_min = 2000;

% maximal speed
n_max = 11000;

n_ref = linspace(n_min,n_max,length(i_d_MTPC));

% maximal current of the machine
i_max = 340;



%% Initialization
run('init.m')


%% motor spec
run('HSM_16_17_12_C01_spec.m');

% Load fit_Torque
load([project_dir_FittedModels,'\fit_Torque.mat'])

% Load fit_Psi_dq
load([project_dir_FittedModels,'\fit_Psi_d.mat'])
load([project_dir_FittedModels,'\fit_Psi_q.mat'])



%% MTPC
% At the beginning, the MTPC values are calculated. With the calculated
% values, the uncertainty is determined.


[i_d_MTPC,i_q_MTPC] = MTPC_LPV_hoelsch(fit_Torque,i_max);

%% MTPV
% [i_d_MTPV,i_q_MTPV,T_MTPV,out] = MTPV_LPV(fit_Psi_d,240,600,7000,3)




%% Calcualtion of the operating points
% The operating points are calculated with the i_dq values and the
% rotational speed n
for ii = 1:1:length(i_d_MTPC)

    for nn = 1:1:length(n_ref)
    
        % select one OP from the vector
        OP.n_op = n_ref(nn);       % 1/min
        
        % Operating point
        OP.i_d = i_d_MTPC(ii);
        OP.i_q = i_q_MTPC(ii);
    
        % Calculate amplitude
        OP.i_dq = sqrt(OP.i_d^2+OP.i_q^2);
    
        % Calculate the motor parameters for the selected OP
        % e.g., torque, power
        motor = motorModel(HSM_16_17_12_C01,OP);
        

        % Test, if the motor is working in the safe operation range, otherwise
        % the calculation ends and NaN is taken for that OP
        if motor.T_calc == 0
            end_calculation = 1; % uncertainty calculation will end
        else
            end_calculation = 0; % uncertaitty calculation will start
        end
        
    if end_calculation == 0
    
        %% Inverter
        run('SkiiP_1242GB120_4D_spec')
        
        inverter = inverterModel(SkiiP_1242GB120_4D,OP);
        

        %% Power analyzer
        
        % Estimation of the DC-link power
        OP.P_dcLink = motor.P_mech + motor.P_loss + inverter.P_loss;
        
        % power measurement uncertainty
        OP.P_500Hz = motor.P_mech/3*0.99;    % W
        OP.P_5kHz = 0;          % W
        OP.P_50kHz = 0;         % W
        OP.P_1MHz = 0;          % W
        
        
        WT3000.I_phase = OP.i_dq/sqrt(2);   % current RMS in A
        WT3000.phi_phase = 45.483;          % angle in °
        WT3000.f_I_phase = OP.n_op/60*HSM_16_17_12_C01.p;   % Hz
        WT3000.f_I_dcLink = 0;              % Hz
        WT3000.phi_dcLink = 0       ;       % °, only active power from the DC-link
        WT3000.I_dcLink = OP.P_dcLink/400;  % A
        % 
        WT5000.I_phase = OP.i_dq/sqrt(2);   % current RMS in A
        WT5000.phi_phase = 45.483;          % angle in °
        WT5000.f_I_phase = OP.n_op/60*HSM_16_17_12_C01.p;   % Hz
        WT5000.f_I_dcLink = 0;              % Hz
        WT5000.phi_dcLink = 0;              % °, only active power from the DC-link
        WT5000.I_dcLink = OP.P_dcLink/400;  % A
        

        
        %% Load spec files
        %
        %% Torque sensor
        % HBM - T10FS
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        run('T10FS_spec.m')
        
        % HBM - T12HP
        %%%%%%%%%%%
        run('T12HP_spec.m')
        

        %% Torque measuring amplifier
        % ML60B
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %
        run('ML60B_spec.m')
        
        u_amplifierTorque = torqueAmplifierUncertainty(ML60B,OP,motor);
        

        %% Rotational speed
        % T10FS
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        %
        u_speed = rotationalSpeedUncertainty(T10FS,OP);
        
        
        %% Rotational speed measuring amplifier
        % ML60B
        %%%%%%%%%%%%%%%%%%%%%%%
        %
        u_amplifierSpeed = rotationalSpeedAmplifierUncertainty(ML60B,OP);
        
        
        %% Power analyzer
        % WT3000
        %%%%%%%%%%%%%%%%%%%%%%%
        %
        run('WT3000_spec.m')

        %%%%%%%%%%%%%%%%%%%%%
        % WT5000
        %
        run('WT5000_spec.m')

        %% Calculation 
        %%%%%%
        % torque flange
        
        % T10FS
        % T12HP
        
        torqueFlange = 'T12HP';
        
        if strcmp(torqueFlange,'T10FS')
            u_torqueFlange = torqueUncertainty(T10FS,OP);
        elseif strcmp(torqueFlange,'T12HP')
            u_torqueFlange = torqueUncertainty(T12HP,OP);
        end
        
        
        %%%%%%%
        % power analyzer
        
        % WT3000
        % WT5000
        
        powerAnalyzer = 'WT5000';
        
        if strcmp(powerAnalyzer,'WT3000')
            u_powerAnalyzer = powerAnalyzerUncertainty(WT3000,OP,motor);
        elseif strcmp(powerAnalyzer,'WT5000')
            u_powerAnalyzer = powerAnalyzerUncertainty(WT5000,OP,motor);
        end
        
        
        
        %% coverage factor
        % k_p = 1 -> 68.27 % level of confidence
        % k_p = 2 -> 95.00 % -------"-----------
        % k_p = 3 -> 99.73 % -------"-----------
        
        k_p = 2;
        
        
        %% Torque uncertainty
        % uncertainty calculation for comparison between two measurements which are
        % done directly after each other (shot time)
        u_T_total_rel = sqrt(u_torqueFlange.u_T1_rel^2+u_amplifierTorque.u_T2^2+u_powerAnalyzer.u_T3^2); % Nm
        
        
        % uncertainty calculation for the measurement of absolute values
        u_T_total_abs = sqrt(u_torqueFlange.u_T1_abs^2+u_amplifierTorque.u_T2^2+u_powerAnalyzer.u_T3^2); % Nm
        
           
        %% Speed uncertainty
        u_n_total = sqrt(u_speed.u_n1^2+u_amplifierSpeed.u_n2^2+u_powerAnalyzer.u_n3^2); % 1/min
        
        
        %% Mechanical power uncertainty
        % relative
        u_p_mech_rel = sqrt((2*pi*OP.n_op/60)^2*u_T_total_rel^2+(motor.T_calc*2*pi)^2*(u_n_total/60)^2); % W
        
        % uncertainty calculation for the measurement of absolute values
        u_p_mech_abs = sqrt((2*pi*OP.n_op/60)^2*u_T_total_abs^2+(motor.T_calc*2*pi)^2*(u_n_total/60)^2); % W
        
        
        
        
        %% Efficiency uncertainty
        u_eta_rel = sqrt((1/OP.P_dcLink)^2*u_p_mech_rel^2+(-motor.P_mech/(OP.P_dcLink)^2)^2*u_powerAnalyzer.u_total_dcLink^2); % 1
        
        % absolut
        u_eta_abs = sqrt((1/OP.P_dcLink)^2*u_p_mech_abs^2+(-motor.P_mech/(OP.P_dcLink)^2)^2*u_powerAnalyzer.u_total_dcLink^2); % 1
        
        
        
        %% Efficiency uncertainty
        % Area of trust 95 %
        U_eta_rel(nn,number) = u_eta_rel*k_p*100; % 1
        
        % absolut
        U_eta_abs(nn,number) = u_eta_abs*k_p*100; % 1
        
        
        
        %% Uncertainty in W
        U_power_rel(nn,number) = (motor.P_loss+inverter.P_loss)*(U_eta_rel(nn,number)/100);
        
        U_power_abs(nn,number) = (motor.P_loss+inverter.P_loss)*(U_eta_abs(nn,number)/100);
        

        
        %% relative uncertainty, motor loss
        U_loss_rel(nn,number) = U_power_rel(nn,number)/(motor.P_loss+inverter.P_loss)*100;
        

        %% Plot
        % save some data for grafical visualization
        T_plot(nn,number) = motor.T_calc;  % Nm
        n_plot(nn,number) = OP.n_op;  % 1/min
        i_d_plot(nn,number) = OP.i_d;   % A
        i_q_plot(nn,number) = OP.i_q;   % A
        P_loss_plot(nn,number) = motor.P_loss; % W
        
        % Area of trust 95 %
        % mechanical power
        U_P_mech_rel(nn,number) = k_p*u_p_mech_rel;    % W
        U_P_mech_abs(nn,number) = k_p*u_p_mech_abs;    % W
        
        % rotational speed
        U_n_plot(nn,number) = k_p*u_n_total;      % 1/min
        
        % torque
        U_t_plot(nn,number) = k_p*u_T_total_rel;    % Nm
        
        
        %%
        
        P_motor_plot(nn,number) = motor.P;
        
        %% sesitivity
        u_T1_rel_plot(nn,number) = u_torqueFlange.u_T1_rel;
        u_T2_rel_plot(nn,number) = u_amplifierTorque.u_T2;
        u_T3_rel_plot(nn,number) = u_powerAnalyzer.u_T3;
        
        %% inverter loss
        Loss_inverter_plot(nn,number) = inverter.P_loss;
        
        
        
        
        % if calculation
        % uncertainty calculation is not started
        else
            T_plot(nn,number) = NaN;
            n_plot(nn,number) = NaN;
            U_eta_rel(nn,number) = NaN;
        
        % end statement from if calculation
        end


end

number = number +1;
end




%% Plot uncertainty
figure(1);
[~,h] = contourf(n_plot,T_plot,U_eta_rel);
xlabel('$n$ in 1/min','interpreter','latex');
ylabel('$T$ in Nm','interpreter','latex');
colorbar;
title('Efficiency uncertainty (rel) in \%, kp=2','interpreter','latex');
h.LevelListMode = 'manual';
h.LevelStepMode = 'manual';
h.LevelStep = 5;
h.ShowText = 'on';
h.LineStyle = 'none';



%% Sensitivity analysis torque measurement
% figure(2);
% [~,h] = contourf(n_plot,T_plot,u_T1_rel_plot);
% xlabel('$n$ in 1/min','interpreter','latex');
% ylabel('$T$ in Nm','interpreter','latex');
% colorbar;
% title('u_T1_rel','interpreter','latex');
% h.LevelListMode = 'manual';
% h.LevelStepMode = 'manual';
% h.LevelStep = 5;
% h.ShowText = 'on';
% h.LineStyle = 'none';
% 
% figure(3);
% [~,h] = contourf(n_plot,T_plot,u_T2_rel_plot);
% xlabel('$n$ in 1/min','interpreter','latex');
% ylabel('$T$ in Nm','interpreter','latex');
% colorbar;
% title('u_T2_rel','interpreter','latex');
% h.LevelListMode = 'manual';
% h.LevelStepMode = 'manual';
% h.LevelStep = 5;
% h.ShowText = 'on';
% h.LineStyle = 'none';
% 
% figure(4);
% [~,h] = contourf(n_plot,T_plot,u_T3_rel_plot);
% xlabel('$n$ in 1/min','interpreter','latex');
% ylabel('$T$ in Nm','interpreter','latex');
% colorbar;
% title('u_T3_rel','interpreter','latex');
% h.LevelListMode = 'manual';
% h.LevelStepMode = 'manual';
% h.LevelStep = 5;
% h.ShowText = 'on';
% h.LineStyle = 'none';
% 
% 




