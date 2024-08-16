classdef torqueAmplifierUncertainty
    
   properties
       device_spec
       OP
       motor
   end
   
   properties (Access = private)
       b_r = 1/sqrt(3);
   end
   
   properties (Dependent)   % parameters which should be calculated

       u_T2             % Nm       
   end
   
   
   methods
       
       function obj = torqueAmplifierUncertainty(device,OP,motor) % constructor
           
           obj.device_spec = device;
           obj.OP = OP;
           obj.motor = motor;

       end
   
   
       % 
       function u_T2 = get.u_T2(obj) % Nm
           u_T2 = obj.device_spec.d_amp*obj.b_r*obj.motor.T_calc;
       end

   end
end