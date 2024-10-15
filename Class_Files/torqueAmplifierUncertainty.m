classdef torqueAmplifierUncertainty
    
   properties
       device_spec
       motor_T_calc
   end
   
   properties (Access = private)
       b_r = 1/sqrt(3);
   end
   
   properties (Dependent)   % parameters which should be calculated

       u_T2             % Nm       
   end
   
   
   methods
       
       function obj = torqueAmplifierUncertainty(device,motor_T_calc) % constructor
           
           obj.device_spec = device;
           obj.motor_T_calc = motor_T_calc;

       end
   
   
       % 
       function u_T2 = get.u_T2(obj) % Nm
           u_T2 = obj.device_spec.d_amp*obj.b_r*obj.motor_T_calc;
       end

   end
end