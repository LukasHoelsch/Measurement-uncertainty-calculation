classdef torqueUncertainty
    
   properties
        device
        OP
   end
   
   properties (Access = private)
       c_R = 1/sqrt(3);
   end
   
   
   properties (Dependent)   % parameters which should be calculated
       
       u_dc         % Nm
       u_dlh        % Nm
       u_T1_rel     % Nm
       u_T1_abs     % Nm
   end
   
   
   methods
       % constructor
       function obj = torqueUncertainty(device,OP)
           
           obj.device = device;
           obj.OP = OP;
       end
       
       
      %%  output functions

      % standard deviation
       function u_dc = get.u_dc(obj) % Nm
           u_dc = obj.c_R*obj.device.d_c*obj.device.T_n;
       end
       
       % lineartity error
       function u_dlh = get.u_dlh(obj) % Nm
           u_dlh = obj.c_R*obj.device.d_lh*obj.device.T_n;
       end
       
      
                     
       % relativ torque measurement
       function u_T1_rel = get.u_T1_rel(obj) % Nm
           u_T1_rel = obj.u_dc;
       end
       
       % absolut torque measurement
       function u_T1_abs = get.u_T1_abs(obj) % Nm
           u_T1_abs = sqrt(obj.u_dc^2+obj.u_dlh^2);
       end
       
   end
    
end