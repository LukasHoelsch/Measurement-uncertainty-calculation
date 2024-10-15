classdef torqueUncertainty
    
   properties
        device
        motor_T_calc
   end
   
   properties (Access = private)
       b_r = 1/sqrt(3);
   end
   
   
   properties (Dependent)   % parameters which should be calculated
       
       u_dC         % Nm
       u_dlh        % Nm
       u_sigma_rel  % Nm
       u_T1_rel     % Nm
       u_T1_abs     % Nm
   end
   
   
   methods
       % constructor
       function obj = torqueUncertainty(device,motor_T_calc)
           
           obj.device = device;
           obj.motor_T_calc = motor_T_calc;
       end
       
       
      %%  output functions

      % sensitivity tolerance
       function u_dC = get.u_dC(obj) % Nm
           u_dC = obj.b_r*obj.device.d_c*obj.device.T_n;
       end
       
       % lineartity and hysteresis
       function u_dlh = get.u_dlh(obj) % Nm
           u_dlh = obj.b_r*obj.device.d_lh*obj.device.T_n;
       end
       
       % repeatability
       function u_rep = get.u_sigma_rel(obj) % Nm

           u_rep = obj.device.sigma_rel*obj.motor_T_calc;
       end
      
                     
       % relativ torque measurement; see also Fig. 3 in the publication
       function u_T1_rel = get.u_T1_rel(obj) % Nm
           u_T1_rel = obj.u_sigma_rel;
       end
       
       % absolut torque measurement
       function u_T1_abs = get.u_T1_abs(obj) % Nm
           u_T1_abs = sqrt(obj.u_dC^2+obj.u_dlh^2+obj.u_sigma_rel^2);
       end
       
   end
    
end