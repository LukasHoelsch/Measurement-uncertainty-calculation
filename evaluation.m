% evaluation.m

% Main file in the future

close all
clearvars -except;
clc;

% Get project directories
project_dir = [fileparts(mfilename('fullpath'))];

%% Initialization
run('init.m')

%% Settings for the calculation
% rotational speed sampling points
n_samplingPoints = 20;

% maximal torque
T_max = 20; % Nm

% minimal speed
n_min = 2000; % 1/min

% maximal speed
n_max = 8000; % 1/min

% maximal current of the machine
i_max = 25; % A

% DC-link voltage
v_DC = 400; % V

% torque flange
% select between
%   T10FS
%   T12HP
torqueFlange_selected = T12HP;

% power analyzer
% select between
%   WT3000
%   WT5000
powerAnalyzer_selected = WT5000;

% machine,
motor_selected = IPMSM;
% motor_selected = HSM_16_17_12_C01;

% semiconductor
semiconductor_selected = FS02MR12A8MA2B;

% coverage factor
% k_p = 1 -> 68.27 % level of confidence
% k_p = 2 -> 95.00 % -------"-----------
% k_p = 3 -> 99.73 % -------"-----------
k_p = 2;

%% load the data

% sampling points for the rotational speed
n_ref = linspace(n_min,n_max,n_samplingPoints);


%% MTPC
% At the beginning, the MTPC values are calculated. With the calculated
% values, the uncertainty is determined.
[i_d_MTPC,i_q_MTPC] = MTPC_LPV(motor_selected.torque.fit_Torque,i_max);

% preallocation
[n_op,i_d,i_q,i_dq,motor_T_calc,end_calculation] = preallocation(n_samplingPoints,i_d_MTPC);

length_id = length(i_d_MTPC);


%% Counter
f_sample = 100e3; % sample frequency (resolution)
f_switchingFrequency = 10e3; % Hz
[OP.counter] = Determination_Counter(f_sample,f_switchingFrequency);



%% Calcualtion of the operating points
% The operating points are calculated with the i_dq values and the
% rotational speed n

idx = 0;

%for ii = 1:1:length(i_d_MTPC)

for nn = 1:1:length(n_ref)

    for ii = 1:1:length(i_d_MTPC)

        idx = idx+1;
    
        % select one OP from the vector
        n_op(idx) = n_ref(nn);       % 1/min
        
        % Operating point
        i_d(idx) = i_d_MTPC(ii);
        i_q(idx) = i_q_MTPC(ii);
    
        % Calculate amplitude
        i_dq(idx) = sqrt(i_d(idx)^2+i_q(idx)^2);
    
        % Calculate the motor parameters for the selected OP
        motor_T_calc(idx) = motorModel(motor_selected,OP,n_op(idx),i_d(idx),i_q(idx),i_dq(idx)).T_calc;
        

        % Test, if the motor is working in the safe operation range, otherwise
        % the calculation ends and NaN is taken for that OP
        if motor_T_calc(idx) == 0
            end_calculation(idx) = 1; % uncertainty calculation will end
        else
            end_calculation(idx) = 0; % uncertaitty calculation will start
        end
    end
end


%% Evaluation

%% broadcast variables
% defining these variables outside of parfor to reduce the communication
% effort
motor_polePairNumber = motor_selected.p;
counter = OP.counter;

tic
parfor zz=1:idx

    if end_calculation(zz) == 1
        motor_P_loss(zz) = NaN;
        motor_P_mech(zz) = NaN;
        inverter_P_loss(zz) = NaN;
        inverter_P_sw(zz) = NaN;
        P_dcLink(zz) = NaN;
        u_T2(zz) = NaN;
        u_n1(zz) = NaN;
        u_n2(zz) = NaN;
        u_n3(zz) = NaN;
        u_n(zz) = NaN;
        u_T1_MM(zz) = NaN;
        u_T1_SM(zz) = NaN;
        u_el_abc_MM(zz) = NaN;
        u_T_MM(zz) = NaN;
        u_T_SM(zz) = NaN;
        Up_eta_MM(zz) = NaN;
        Up_eta_SM(zz) = NaN;
        Up_eta_watt_MM(zz) = NaN;
        Up_eta_watt_SM(zz) = NaN;
        electricDrive_P_loss(zz) = NaN;
        electricDrive_efficiency(zz) = NaN;
        u_P_mech_MM(zz) = NaN;
        u_P_mech_SM(zz) = NaN;
        Up_T_SM(zz) = NaN;
        Up_T_MM(zz) = NaN;
        Up_mech_SM(zz) = NaN;
        Up_mech_MM(zz) = NaN;
        Up_n(zz) = NaN;
        Up_el_abc_MM(zz) = NaN;
        Up_el_dcLink_MM(zz) = NaN;
    else

        motor_P_loss(zz) = motorModel(motor_selected,OP,n_op(zz),i_d(zz),i_q(zz),i_dq(zz)).P_loss;
        motor_P_mech(zz) = motorModel(motor_selected,OP,n_op(zz),i_d(zz),i_q(zz),i_dq(zz)).P_mech;
        motor_P_calc_bound(zz) = motorModel(motor_selected,OP,n_op(zz),i_d(zz),i_q(zz),i_dq(zz)).P_calc_bound;
        motor_v_abc(zz,:) = motorModel(motor_selected,OP,n_op(zz),i_d(zz),i_q(zz),i_dq(zz)).v_abc(1,:);
        motor_i_abc(zz,:) = motorModel(motor_selected,OP,n_op(zz),i_d(zz),i_q(zz),i_dq(zz)).i_abc(1,:);
        motor_v_dq(zz,:) = motorModel(motor_selected,OP,n_op(zz),i_d(zz),i_q(zz),i_dq(zz)).v_dq(1,:);
    
        % operating variables
        f_el(zz) = n_op(zz)/60*motor_polePairNumber; % Hz
        T_el(zz) = 1/n_op(zz); % s
    
        % sampling frequency and time


        %% Inverter
        inverter_P_loss(zz) = inverterModel(semiconductor_selected,motor_selected,v_DC,counter,f_el(zz),T_el(zz),i_dq(zz),...
            motor_v_abc(zz,:),motor_i_abc(zz,:)).P_loss;
        inverter_P_sw(zz) = inverterModel(semiconductor_selected,motor_selected,v_DC,counter,f_el(zz),T_el(zz),i_dq(zz),...
            motor_v_abc(zz,:),motor_i_abc(zz,:)).P_sw;
    
    
        % Estimation of the DC-link power
        P_dcLink(zz) = motor_P_mech(zz) + motor_P_loss(zz) + inverter_P_loss(zz);
        I_dcLink(zz) = P_dcLink(zz)/v_DC;
    
        % abc currents
        I_abc_fund(zz) = ((motor_P_mech(zz)/3*0.99)/v_DC)*0.95;
        I_abc_harm(zz) = ((motor_P_mech(zz)/3*0.99)/v_DC)*0.05;
    
        % power analyzer
        % WT5000.I_phase = OP.i_dq/sqrt(2);   % current RMS in A
        angle_phi(zz) = motorModel(motor_selected,OP,n_op(zz),i_d(zz),i_q(zz),i_dq(zz)).phi; % angle in °
        f_I_abc_fund(zz) = n_op(zz)/60*motor_polePairNumber;   % Hz
    
    
        % torque amplifier
        u_T2(zz) = torqueAmplifierUncertainty(ML60B,motor_T_calc(zz)).u_T2;
    
        % rotational speed
        u_n1(zz) = rotationalSpeedUncertainty(T10FS,n_op(zz)).u_n1_SM_MM;
                
        % amplifier speed
        u_n2(zz) = rotationalSpeedAmplifierUncertainty(ML60B,n_op(zz)).u_n2;
    
        % torque
        u_T1_MM(zz) = torqueUncertainty(torqueFlange_selected,motor_T_calc(zz)).u_T1_MM;
        u_T1_SM(zz) = torqueUncertainty(torqueFlange_selected,motor_T_calc(zz)).u_T1_SM;

    

        % power analyzer, el, abc
        u_el_abc_MM(zz) = powerAnalyzerUncertainty(powerAnalyzer_selected,n_op(zz),...
            motor_T_calc(zz),I_abc_fund(zz),f_I_abc_fund(zz),angle_phi(zz),...
            I_abc_harm(zz),motor_v_dq(zz,:),I_dcLink(zz),v_DC).u_el_abc_MM;

        % power analyzer, T
        u_T3(zz) = powerAnalyzerUncertainty(powerAnalyzer_selected,n_op(zz),...
            motor_T_calc(zz),I_abc_fund(zz),f_I_abc_fund(zz),angle_phi(zz),...
            I_abc_harm(zz),motor_v_dq(zz,:),I_dcLink(zz),v_DC).u_T3;
        
        % power analyzer, n
        u_n3(zz) = powerAnalyzerUncertainty(powerAnalyzer_selected,n_op(zz),...
            motor_T_calc(zz),I_abc_fund(zz),f_I_abc_fund(zz),angle_phi(zz),...
            I_abc_harm(zz),motor_v_dq(zz,:),I_dcLink(zz),v_DC).u_n3;

        % power analyzer, dc
        u_el_dcLink_MM(zz) = powerAnalyzerUncertainty(powerAnalyzer_selected,n_op(zz),...
            motor_T_calc(zz),I_abc_fund(zz),f_I_abc_fund(zz),angle_phi(zz),...
            I_abc_harm(zz),motor_v_dq(zz,:),I_dcLink(zz),v_DC).u_c_el_dcLink_MM;

        u_el_dcLink_SM(zz) = powerAnalyzerUncertainty(powerAnalyzer_selected,n_op(zz),...
            motor_T_calc(zz),I_abc_fund(zz),f_I_abc_fund(zz),angle_phi(zz),...
            I_abc_harm(zz),motor_v_dq(zz,:),I_dcLink(zz),v_DC).u_c_el_dcLink_SM;

        %% Torque uncertainty
        % uncertainty calculation for comparison between two measurements which are
        % done directly after each other (short time)
        u_T_MM(zz) = sqrt(u_T1_MM(zz)^2+u_T2(zz)^2+u_T3(zz)^2); % Nm

        % uncertainty calculation for the single measurement case
        u_T_SM(zz) = sqrt(u_T1_SM(zz)^2+u_T2(zz)^2+u_T3(zz)^2); % Nm

        %% Speed uncertainty
        u_n(zz) = sqrt(u_n1(zz)^2+u_n2(zz)^2+u_n3(zz)^2); % 1/min


        %% Mechanical power uncertainty
        % relative
        u_P_mech_MM(zz) = sqrt((2*pi*n_op(zz)/60)^2*u_T_MM(zz)^2+(motor_T_calc(zz)*2*pi/60)^2*(u_n(zz)/60)^2); % W
            
        % uncertainty calculation for the measurement of absolute values
        u_P_mech_SM(zz) = sqrt((2*pi*n_op(zz)/60)^2*u_T_SM(zz)^2+(motor_T_calc(zz)*2*pi/60)^2*(u_n(zz)/60)^2); % W


        %% Efficiency uncertainty
        % multiple
        u_eta_MM(zz) = sqrt((1/P_dcLink(zz))^2*u_P_mech_MM(zz)^2+(-motor_P_mech(zz)/(P_dcLink(zz))^2)^2*u_el_dcLink_MM(zz)^2); % 1
            
        % single
        u_eta_SM(zz) = sqrt((1/P_dcLink(zz))^2*u_P_mech_SM(zz)^2+(-motor_P_mech(zz)/(P_dcLink(zz))^2)^2*u_el_dcLink_SM(zz)^2); % 1
        

        %% level of convidence
        Up_eta_MM(zz) = u_eta_MM(zz)*k_p*100; % 1
        Up_eta_SM(zz) = u_eta_SM(zz)*k_p*100; % 1

        %% Uncertainty in W
        Up_eta_watt_MM(zz) = (motor_P_mech(zz) + motor_P_loss(zz)+inverter_P_loss(zz))*(Up_eta_MM(zz)/100);
        Up_eta_watt_SM(zz) = (motor_P_mech(zz) + motor_P_loss(zz)+inverter_P_loss(zz))*(Up_eta_SM(zz)/100);

        %% Sensitivity coefficients
        % torque
        Up_T_SM(zz) = u_T_SM(zz) * k_p;
        Up_T_MM(zz) = u_T_MM(zz) * k_p;

        % mechanical power
        Up_mech_SM(zz) = u_P_mech_SM(zz) * k_p;
        Up_mech_MM(zz) = u_P_mech_MM(zz) * k_p;

        % power analyzer
        Up_el_abc_MM(zz) = u_el_abc_MM(zz) * k_p;

        % rotational speed
        Up_n(zz) = u_n(zz)*k_p;

        % power analyzer
        Up_el_dcLink_MM(zz) = u_el_dcLink_MM(zz)*k_p;


        %%
        electricDrive_P_loss(zz) = (inverter_P_loss(zz) + motor_P_loss(zz));

        electricDrive_efficiency(zz) = motor_P_mech(zz)/(electricDrive_P_loss(zz)+motor_P_mech(zz))*100;


    end % if end_calculation
end
toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Reshape for visualization %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
plot_T_calc = reshape(motor_T_calc,[length_id,n_samplingPoints]);
plot_n = reshape(n_op,[length_id,n_samplingPoints]);

%% Motor loss
plot_motor_P_loss = reshape(motor_P_loss,[length_id,n_samplingPoints]);

%% Inverter loss
plot_inverter_P_loss = reshape(inverter_P_loss,[length_id,n_samplingPoints]);

%% Electric drive loss
plot_electricDrive_P_loss = reshape(electricDrive_P_loss,[length_id,n_samplingPoints]);

%% Electric drive efficiency
plot_electricDrive_efficiency = reshape(electricDrive_efficiency,[length_id,n_samplingPoints]);

%% Efficency uncertainty
plot_Up_eta_MM = reshape(Up_eta_MM,[length_id,n_samplingPoints]);
plot_Up_eta_SM = reshape(Up_eta_SM,[length_id,n_samplingPoints]);

%% Efficiency uncertainty given in W for a better understanding
plot_Up_eta_watt_MM = reshape(Up_eta_watt_MM,[length_id,n_samplingPoints]);
plot_Up_eta_watt_SM = reshape(Up_eta_watt_SM,[length_id,n_samplingPoints]);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sensitivity coefficients %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% mechanical power
plot_Up_mech_SM = reshape(Up_mech_SM,[length_id,n_samplingPoints]);
plot_Up_mech_MM = reshape(Up_mech_MM,[length_id,n_samplingPoints]);

% torque
plot_Up_T_SM = reshape(Up_T_SM,[length_id,n_samplingPoints]);
plot_Up_T_MM = reshape(Up_T_MM,[length_id,n_samplingPoints]);

% power analyzer
plot_Up_powerAnalyzer_MM = reshape(Up_el_abc_MM,[length_id,n_samplingPoints]);

% rotational speed
plot_Up_n = reshape(Up_n,[length_id,n_samplingPoints]);

% power analyzer
plot_Up_el_dcLink_MM = reshape(Up_el_dcLink_MM,[length_id,n_samplingPoints]);


% amplifier




























