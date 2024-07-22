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
       u_sigma_rel  % Nm
       d_para       % 1
       u_para       % Nm
       u_T1_rel     % Nm
       u_T1_abs     % Nm
   end
   
   
   methods
       % constructor
       function obj = torqueUncertainty(device,OP)
           
           obj.device = device;
           obj.OP = OP;
       end
       
       
      % output functions

      % standard deviation
       function u_dc = get.u_dc(obj) % Nm
           u_dc = obj.c_R*obj.device.d_c*obj.device.T_n;
       end
       
       % lineartity
       function u_dlh = get.u_dlh(obj) % Nm
           u_dlh = obj.c_R*obj.device.d_lh*obj.device.T_n;
       end
       
       % repeatability
       % the repeatability is manually set to zero, because the difference
       % in the torque measurement between to OPs is assumed to be zero,
       % due to the torque controller
       function u_sigma_rel = get.u_sigma_rel(obj) % Nm
           u_sigma_rel = obj.device.sigma_rel*obj.OP.T_max*0;
       end
       
       % calculation factor parasitic loads
       function d_para = get.d_para(obj) % 1
           d_para = obj.device.F_a/obj.device.F_ag + obj.device.F_r/obj.device.F_rg + ...
               obj.device.M_b/obj.device.M_bg;
       end
       
       % parasitic loads
       function u_para = get.u_para(obj) % Nm
           u_para = obj.c_R*obj.d_para*obj.device.T_n* obj.device.d_para2;
           
       end
       
       % relativ
       function u_T1_rel = get.u_T1_rel(obj) % Nm
           u_T1_rel = sqrt(obj.u_dc^2+obj.u_sigma_rel^2+obj.u_para^2);
       end
       
       % absolut
       function u_T1_abs = get.u_T1_abs(obj) % Nm
           u_T1_abs = sqrt(obj.u_dc^2+obj.u_dlh^2+obj.u_sigma_rel^2+obj.u_para^2);
       end
       
   end
    
end