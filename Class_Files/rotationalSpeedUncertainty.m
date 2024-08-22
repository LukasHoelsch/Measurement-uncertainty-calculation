classdef rotationalSpeedUncertainty
    
    properties
        device_spec
        OP
    end
    
    properties (Access = private)
        b_r = 1/sqrt(3);
    end
    
    properties (Dependent)   % parameters which should be calculated
       d_np_grad        % °
       d_ns_grad        % °
       d_n_grad         % °
       d_n_rel          % 1
       u_n1             % 1/min
       
    end
   
    methods
        % constructor
        function obj = rotationalSpeedUncertainty(device,OP)
            
            obj.device_spec = device;
            obj.OP = OP;
        end
        
        %% output functions
        function d_np_grad = get.d_np_grad(obj) % °
            
            d_np_grad = obj.device_spec.pulse*obj.device_spec.d_np/...
                (obj.device_spec.D*pi);
        end
        
        function d_ns_grad = get.d_ns_grad(obj) % °
            
            d_ns_grad = obj.device_spec.pulse*obj.device_spec.d_ns/...
                (obj.device_spec.D*pi);
        end
        
        function d_n_grad = get.d_n_grad(obj) % °
            
            d_n_grad = obj.d_np_grad+obj.d_ns_grad;
        end
        
        function d_n_rel = get.d_n_rel(obj) % 1
            
            d_n_rel = obj.d_n_grad/obj.device_spec.pulse;
        end
        
        function u_n1 = get.u_n1(obj) % 1/min
            
            u_n1 = obj.OP.n_op*obj.d_n_rel;
        end
        
    end
end           
            