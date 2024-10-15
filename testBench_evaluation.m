%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% File: testBench_evaluation.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Main file for the evaluation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


close all
clearvars -except;
clc;

% Get project directories
project_dir = [fileparts(mfilename('fullpath'))];

%% Hardware settings
% check if the parallel computing toolbox is available

parallelComputing = 'True';



%% Settings for the calculation
% Please fill out the following fields.

% number of sampling points for the d current, the q current has the same
% size
n_samplingPoints = 5;

% maximal torque
T_max = 180; % Nm

% minimal speed
% OPPs are often used in the high-speed range, therefore, the min. speed is
% limited
n_min = 2000;

% maximal speed
n_max = 11000;



% maximal current of the machine
OP.i_max = 340;
i_max = 340;

% DC-link voltage
OP.u_DC = 400; % V

% switching frequency 
OP.f_sw = 8000; % Hz



% torque flange
% select between
%   T10FS
%   T12HP
torqueFlange_selected = 'T12HP';


% power analyzer
% select between
%   WT3000
%   WT5000
powerAnalyzer_selected = 'WT5000';


% coverage factor
% k_p = 1 -> 68.27 % level of confidence
% k_p = 2 -> 95.00 % -------"-----------
% k_p = 3 -> 99.73 % -------"-----------
k_p = 2;


%% load the data
% number of current values
i_d_MTPC = zeros(n_samplingPoints);
i_q_MTPC = zeros(length(i_d_MTPC));

% sampling points for the rotational speed
n_ref = linspace(n_min,n_max,length(i_d_MTPC));

%% Initialization
run('init.m')


%% MTPC
% At the beginning, the MTPC values are calculated. With the calculated
% values, the uncertainty is determined.


[i_d_MTPC,i_q_MTPC] = MTPC_LPV(fit_Torque,i_max);

%% MTPV
% MTPV strategy is for this machine not necessary

%% Counter
[OP.counter] = Determination_Counter(100000);

%% Calcualtion of the operating points
% The operating points are calculated with the i_dq values and the
% rotational speed n
for ii = 1:1:length(i_d_MTPC)
%for ii = 1:1:77

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
        motorStruckt.motor_spec = motorModel(HSM_16_17_12_C01,OP).motor_spec;
        motorStruckt.T_calc = motorModel(HSM_16_17_12_C01,OP).T_calc;
        motorStruckt.P_mech = motorModel(HSM_16_17_12_C01,OP).P_mech;
        motorStruckt.P_loss = motorModel(HSM_16_17_12_C01,OP).P_loss;


        % Test, if the motor is working in the safe operation range, otherwise
        % the calculation ends and NaN is taken for that OP
        if motorStruckt.T_calc == 0
            end_calculation = 1; % uncertainty calculation will end
        else
            end_calculation = 0; % uncertaitty calculation will start
        end
     

        %% Calculation
        if end_calculation == 0
            
            % operating point dependant variables

            % electrical frequency and time
            OP.f_el = OP.n_op/60*motorStruckt.motor_spec.p; % Hz
            OP.T_el = 1/OP.f_el; % s

            % sampling frequency and time
            OP.f_sampling = 5e4; % Hz
            OP.t_sampling = 1/OP.f_sampling; % s


            % Inverter
            %inverter = inverterModel(FS02MR12A8MA2B,motor,OP);
            
            inv.P_loss = inverterModel(FS02MR12A8MA2B,motor,OP).P_loss;
            inv.P_sw = inverterModel(FS02MR12A8MA2B,motor,OP).P_sw;
    
            % Estimation of the DC-link power
            OP.P_dcLink = motorStruckt.P_mech + motorStruckt.P_loss + inv.P_loss;
            OP.I_dcLink = OP.P_dcLink/OP.u_DC;

            % abc currents
            OP.I_abc_fund = ((motorStruckt.P_mech/3*0.99)/OP.u_DC)*0.95;
            OP.I_abc_harm = ((motorStruckt.P_mech/3*0.99)/OP.u_DC)*0.05;
            
            % power measurement uncertainty
            % OP.P_500Hz = motor.P_mech/3*0.99;    % W
            % OP.P_5kHz = 0;          % W
            % OP.P_50kHz = 0;         % W
            % OP.P_1MHz = 0;          % W
            
            
            % WT3000.I_phase = OP.i_dq/sqrt(2);   % current RMS in A
            % WT3000.phi_phase = motor.phi;       % power factor angle in °
            % WT3000.f_I_phase = OP.n_op/60*HSM_16_17_12_C01.p;   % Hz
            % 
            % WT3000.f_I_dcLink = 0;              % Hz
            % WT3000.phi_dcLink = 0       ;       % °, only active power from the DC-link
            % WT3000.I_dcLink = OP.P_dcLink/OP.u_DC;  % A
            % 
            WT5000.I_phase = OP.i_dq/sqrt(2);   % current RMS in A
            WT5000.phi_phase = motor.phi;          % angle in °
            WT5000.f_I_phase = OP.n_op/60*HSM_16_17_12_C01.p;   % Hz
            % WT5000.f_I_dcLink = 0;              % Hz
            % WT5000.phi_dcLink = 0;              % °, only active power from the DC-link
            % WT5000.I_dcLink = OP.P_dcLink/OP.u_DC;  % A
            
            
            
            
            % torque amplifier
            amplifierTorque = torqueAmplifierUncertainty(ML60B,OP,motor);

            % rotational speed
            speed = rotationalSpeedUncertainty(T10FS,OP);
            
            % amplifier speed
            amplifierSpeed = rotationalSpeedAmplifierUncertainty(ML60B,OP);

            % torque            
            if strcmp(torqueFlange_selected,'T10FS')
                torqueFlange = torqueUncertainty(T10FS,OP,motor);
            elseif strcmp(torqueFlange_selected,'T12HP')
                torqueFlange = torqueUncertainty(T12HP,OP,motor);
            end

            % power analyzer
            if strcmp(powerAnalyzer_selected,'WT3000')
                powerAnalyzer = powerAnalyzerUncertainty(WT3000,OP,motor);
            elseif strcmp(powerAnalyzer_selected,'WT5000')
                powerAnalyzer = powerAnalyzerUncertainty(WT5000,OP,motor);
            end
                    

            
            %% Torque uncertainty
            % uncertainty calculation for comparison between two measurements which are
            % done directly after each other (shot time)
            u_c.T_rel = sqrt(torqueFlange.u_T1_rel^2+amplifierTorque.u_T2^2+powerAnalyzer.u_T3^2); % Nm
            
            
            % uncertainty calculation for the measurement of absolute values
            u_c.T_abs = sqrt(torqueFlange.u_T1_abs^2+amplifierTorque.u_T2^2+powerAnalyzer.u_T3^2); % Nm
            
               
            %% Speed uncertainty
            u_c.n = sqrt(speed.u_n1^2+amplifierSpeed.u_n2^2+powerAnalyzer.u_n3^2); % 1/min
            
            
            %% Mechanical power uncertainty
            % relative
            u_c.p_mech_rel = sqrt((2*pi*OP.n_op/60)^2*u_c.T_rel^2+(motorStruckt.T_calc*2*pi)^2*(u_c.n/60)^2); % W
            
            % uncertainty calculation for the measurement of absolute values
            u_c.p_mech_abs = sqrt((2*pi*OP.n_op/60)^2*u_c.T_abs^2+(motorStruckt.T_calc*2*pi)^2*(u_c.n/60)^2); % W
            
            
            
            
            %% Efficiency uncertainty
            u_c.eta_rel = sqrt((1/OP.P_dcLink)^2*u_c.p_mech_rel^2+(-motorStruckt.P_mech/(OP.P_dcLink)^2)^2*powerAnalyzer.u_rel_dcLink^2); % 1
            
            % absolut
            u_c.eta_abs = sqrt((1/OP.P_dcLink)^2*u_c.p_mech_abs^2+(-motorStruckt.P_mech/(OP.P_dcLink)^2)^2*powerAnalyzer.u_abs_dcLink^2); % 1
            
            
            
            
            %% Efficiency uncertainty
            % Area of trust 95 %
            Up.eta_rel(nn,number) = u_c.eta_rel*k_p*100; % 1
                    
            % absolut
            Up.eta_abs(nn,number) = u_c.eta_abs*k_p*100; % 1
            
            
            %% Uncertainty in W
            Up.power_rel(nn,number) = (motorStruckt.P_loss+inv.P_loss)*(Up.eta_rel(nn,number)/100);
            
            Up.power_abs(nn,number) = (motorStruckt.P_loss+inv.P_loss)*(Up.eta_abs(nn,number)/100);
            
    
            
            %% relative uncertainty, motor loss
            Up.loss_rel(nn,number) = Up.power_rel(nn,number)/(motorStruckt.P_loss+inv.P_loss)*100;
            
    
            %% Plot
            % save some data for grafical visualization
            result.T_motor(nn,number) = motorStruckt.T_calc;  % Nm
            result.n_motor(nn,number) = OP.n_op;  % 1/min
            result.i_d_op(nn,number) = OP.i_d;   % A
            result.i_q_op(nn,number) = OP.i_q;   % A
            result.P_loss_motor(nn,number) = motorStruckt.P_loss; % W
            result.u_d(nn,number) = motor.u_dq(1);
            
            % Area of trust 95 %
            % mechanical power
            Up.P_mech_rel(nn,number) = k_p*u_c.p_mech_rel;    % W
            Up.P_mech_abs(nn,number) = k_p*u_c.p_mech_abs;    % W
            
            % rotational speed
            Up.n(nn,number) = k_p*u_c.n;      % 1/min
            
            % torque
            Up.T_rel(nn,number) = k_p*u_c.T_rel;    % Nm
            
            

            %%
            % inverter, switching loss
            result.P_loss_sw(nn,number) = inv.P_sw;

            % inverter loss
            result.P_loss_inverter(nn,number) = inv.P_loss;
            
            % electric drive loss
            result.electricDrive_loss(nn,number) = (inv.P_loss + motorStruckt.P_loss);

            % electric drive power
            result.electricDrive_power(nn,number) = motorStruckt.P_mech;


            % electric drive efficiency
            result.electricDrive_efficiency(nn,number) = motorStruckt.P_mech/(result.electricDrive_loss(nn,number)+motorStruckt.P_mech)*100;


            % load angle
            result.loadAngle(nn,number) = motor.theta;

           

            %% sesitivity
            u_T1_rel_plot(nn,number) = torqueFlange.u_T1_rel;
            u_T2_rel_plot(nn,number) = amplifierTorque.u_T2;
            u_T3_rel_plot(nn,number) = powerAnalyzer.u_T3;
            
            
            
        % if calculation
        % uncertainty calculation is not started
        else
            result.T_motor(nn,number) = NaN;
            result.n_motor(nn,number) = NaN;
            Up.eta_rel(nn,number) = NaN;
        
        % end statement from if calculation
        end
    
    % end for n 
    end


number = number +1;

% end calculation
end

%% Plot the calculation settings
fprintf('Selected settings:\n')
fprintf('Number of samping points for id and iq: %d \n',n_samplingPoints)
fprintf('Torque flange: %s\n',torqueFlange_selected)
fprintf('Power analyzer: %s\n',powerAnalyzer_selected)
fprintf('Coverage factor: %d\n',k_p)



%% plot
% t = linspace(0,0.2,49);
% 
% figure(1);
% plot(t,result.u_ab(1,:));
% hold on;
% plot(t,result.u_ab(2,:));

% 
% figure(2);
% plot(t,result.u_abc(1,:));
% hold on;
% plot(t,result.u_abc(2,:));
% plot(t,result.u_abc(3,:));

%% Plot uncertainty
% figure(1);
% [~,h] = contourf(result.n_motor,result.T_motor,2*Up.eta_rel);
% xlim([2000 11000])
% xlabel('$n$ in 1/min','interpreter','latex');
% ylabel('$T$ in Nm','interpreter','latex');
% colorbar;
% title('Efficiency uncertainty (rel) in \%, kp=2','interpreter','latex');
% h.LevelListMode = 'manual';
% h.LevelStepMode = 'manual';
% h.LevelStep = 5;
% h.ShowText = 'on';
% h.LineStyle = 'none';
% 
% 
% figure(2);
% [~,h] = contourf(result.n_motor,result.T_motor,result.electricDrive_efficiency);
% xlim([2000 11000])
% xlabel('$n$ in 1/min','interpreter','latex');
% ylabel('$T$ in Nm','interpreter','latex');
% colorbar;
% title('Efficiency electric drive in \%, kp=2','interpreter','latex');
% h.LevelListMode = 'manual';
% h.LevelStepMode = 'manual';
% h.LevelStep = 5;
% h.ShowText = 'on';
% h.LineStyle = 'none';
% 
% figure(3);
% [~,h] = contourf(result.n_motor,result.T_motor,result.electricDrive_power);
% xlim([2000 11000])
% xlabel('$n$ in 1/min','interpreter','latex');
% ylabel('$T$ in Nm','interpreter','latex');
% colorbar;
% title('Power electric drive in W','interpreter','latex');
% h.LevelListMode = 'manual';
% h.LevelStepMode = 'manual';
% h.LevelStep = 5;
% h.ShowText = 'on';
% h.LineStyle = 'none';
% 
% 
% figure(4);
% [~,h] = contourf(result.n_motor,result.T_motor,result.electricDrive_loss);
% xlim([2000 11000])
% xlabel('$n$ in 1/min','interpreter','latex');
% ylabel('$T$ in Nm','interpreter','latex');
% colorbar;
% title('Loss electric drive in W','interpreter','latex');
% h.LevelListMode = 'manual';
% h.LevelStepMode = 'manual';
% h.LevelStep = 5;
% h.ShowText = 'on';
% h.LineStyle = 'none';




% figure(6);
% [~,h] = contourf(result.n_motor,result.T_motor,result.u_dq(1,:));
% xlim([2000 11000])
% xlabel('$n$ in 1/min','interpreter','latex');
% ylabel('$T$ in Nm','interpreter','latex');
% colorbar;
% title('Loss electric drive in W','interpreter','latex');
% h.LevelListMode = 'manual';
% h.LevelStepMode = 'manual';
% h.LevelStep = 5;
% h.ShowText = 'on';
% h.LineStyle = 'none';
% 
% figure(7);
% [~,h] = contourf(result.n_motor,result.T_motor,result.loadAngle);
% xlim([2000 11000])
% xlabel('$n$ in 1/min','interpreter','latex');
% ylabel('$T$ in Nm','interpreter','latex');
% colorbar;
% title('Loss electric drive in W','interpreter','latex');
% h.LevelListMode = 'manual';
% h.LevelStepMode = 'manual';
% h.LevelStep = 5;
% h.ShowText = 'on';
% h.LineStyle = 'none';



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




