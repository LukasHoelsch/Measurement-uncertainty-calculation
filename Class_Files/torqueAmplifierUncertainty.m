classdef torqueAmplifierUncertainty
    
   properties
       device_spec
       OP
       motor
   end
   
   properties (Access = private)
       c_R = 1/sqrt(3);
   end
   
   properties (Dependent)   % parameters which should be calculated
       u_T              % Nm
       u_T_theta        % Nm
       u_T2             % Nm
       
   end
   
   
   methods
       
       function obj = torqueAmplifierUncertainty(device,OP,motor) % constructor
           
           obj.device_spec = device;
           obj.OP = OP;
           obj.motor = motor;

       end
   
   
       function u_T = get.u_T(obj) % Nm
           u_T = obj.device_spec.d_amplifier*obj.c_R*obj.motor.T_calc;
       end
       
       function u_T_theta = get.u_T_theta(obj) % Nm
           u_T_theta = obj.c_R*obj.device_spec.d_theta*...
               obj.device_spec.delta_theta*obj.motor.T_calc;
       end
   
       
       function u_T2 = get.u_T2(obj) % Nm
           if strcmp(obj.device_spec.temperature,'yes')
               new_temperature = sqrt(obj.u_T^2+obj.u_T_theta^2);
           elseif strcmp(obj.device_spec.temperature,'no')
               new_temperature = obj.u_T;
           else
               new_temperature = 'Cannot calculate with given values';
           end
           u_T2 = new_temperature;
       end
   end
end