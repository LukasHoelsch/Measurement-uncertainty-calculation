classdef rotationalSpeedAmplifierUncertainty
    
    properties
        device_spec
        OP
    end
    
   properties (Access = private)
       c_R = 1/sqrt(3);     % rectangular distribution
   end
   
   properties (Dependent)   % parameters which should be calculated
       u_n        % 1/min
       u_n_theta  % 1/min
       u_n2       % 1/min
       
   end
   
   methods
       % constructor
       function obj = rotationalSpeedAmplifierUncertainty(device,OP)
           
           obj.device_spec = device;
           obj.OP = OP;
       end
       
       
       function u_n = get.u_n(obj) % 1/min
           
           u_n = obj.c_R*obj.device_spec.d_amplifier*obj.OP.n_op;
       end
       
       function u_n_theta = get.u_n_theta(obj) % 1/min
           
           u_n_theta = obj.c_R*obj.device_spec.d_theta*...
               obj.OP.n_op*obj.device_spec.delta_theta;
       end
       
       function u_n2 = get.u_n2(obj) % 1/min
           
           if strcmp(obj.device_spec.temperature,'yes')
               new_temperature = sqrt(obj.u_n^2+obj.u_n_theta^2)
           elseif strcmp(obj.device_spec.temperature,'no')
               new_temperature = obj.u_n;
           else
               new_temperature = 'Cannot calculate with given values';
           end
           u_n2 = new_temperature;
       end
        
   end
end