classdef rotationalSpeedUncertainty
    
    properties
        device_spec
        n_op
    end
    
    properties (Access = private)
        b_r = 1/sqrt(3);
    end
    
    properties (Dependent)   % parameters which should be calculated
       d_n_position
       d_n_slot
       d_n
       u_n1_SM_MM % 1/min
       
    end
   
    methods
        % constructor
        function obj = rotationalSpeedUncertainty(device,n_op)
            
            obj.device_spec = device;
            obj.n_op = n_op;
        end
        
        %% output functions
        function u_n1_SM_MM = get.u_n1_SM_MM(obj)
            
            u_n1_SM_MM = obj.b_r * obj.device_spec.d_n_lin * obj.n_op;
        end
        
    end
end           
            