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
       u_repeatability  % Nm
       u_T1_MM     % Nm
       u_T1_SM     % Nm
       f_T         % Hz
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
       function u_repeatability = get.u_repeatability(obj) % Nm

           u_repeatability = obj.device.sigma_rel*obj.motor_T_calc;
       end
      
                     
       % relativ torque measurement; see also Fig. 3 in the publication
       function u_T1_MM = get.u_T1_MM(obj) % Nm
           u_T1_MM = obj.u_repeatability;
       end
       
       % absolut torque measurement
       function u_T1_SM = get.u_T1_SM(obj) % Nm
           u_T1_SM = sqrt(obj.u_dC^2+obj.u_dlh^2);
       end

       % frequency output
       function f_T = get.f_T(obj) % Hz
           f_T = (obj.device.f_T_nom - obj.device.f_T0)/obj.device.T_n * obj.motor_T_calc + obj.device.f_T0;
       end
       
   end
    
end