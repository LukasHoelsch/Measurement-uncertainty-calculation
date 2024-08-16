classdef rotationalSpeedAmplifierUncertainty
    
    properties
        device_spec
        OP
    end
    
   properties (Access = private)
       b_r = 1/sqrt(3);     % rectangular distribution
   end
   
   properties (Dependent)   % parameters which should be calculated
       
       u_n2       % 1/min
   end
   
   methods
       % constructor
       function obj = rotationalSpeedAmplifierUncertainty(device,OP)
           
           obj.device_spec = device;
           obj.OP = OP;
       end
       
       
       function u_n2 = get.u_n2(obj) % 1/min
           
           u_n2 = obj.b_r*obj.device_spec.d_amp*obj.OP.n_op;
       end
       
               
   end
end