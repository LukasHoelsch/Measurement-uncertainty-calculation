classdef powerAnalyzerUncertainty
    
    properties
        device
        OP
        motor

    end
    
   properties (Access = private)
       c_R = 1/sqrt(3);
   end
   
   properties (Dependent)   % parameters which should be calculated
       u_T3                 % Nm
       u_n3                 % 1/min
       F_nfw_lin            % A,  nullflusswandler, linear
       F_nfw_off            % A,  offset 
       F_nfw_fre            % A,  frequenz
       F_rel_nfw_win        % 
       u_rel_nfw            % 
       F_nfw_lin_dcLink     % A, linear
       F_nfw_off_dcLink     % A, offset
       F_nfw_fre_dcLink     % A, frequenz
       F_rel_nfw_win_dcLink % A
       u_rel_nfw_dcLink     %
       F_d_dcLink           % relative display error
       u_nfw_P_dcLink
       F_TV                 % temperature variation
       F_SH                 % self heating
       F_PF                 % power factor
       F_TC                 % temperatur coefficient
       F_analyzer_dcLink    % power analyzer, e.g., WT3000
       u_analyzer_dcLink    % power analyzer
       u_total_dcLink       % total DC-Link
   end
   
   
   methods
       
       %% constructor
       function obj = powerAnalyzerUncertainty(device,OP,motor)
           
           obj.device = device;
           obj.OP = OP;
           obj.motor = motor;
       end
       
       
       %% output functions
       % display error troque
       function u_T3 = get.u_T3(obj) % Nm
           
           u_T3 = obj.c_R*(obj.device.d_A*obj.motor.T_calc*obj.device.d_ME*...
               obj.device.T_ME);
       end
       
       % display error speed
       function u_n3 = get.u_n3(obj) % 1/min
           
           u_n3 = obj.c_R*(obj.device.d_A*obj.OP.n_op+obj.device.d_ME*...
               obj.device.n_ME);
       end
       
       % Nullflusswandler
       function F_nfw_lin = get.F_nfw_lin(obj)
           
           F_nfw_lin = obj.device.d_nfw_lin*obj.device.I_phase;
       end
       
       function F_nfw_off = get.F_nfw_off(obj)
           
           F_nfw_off = obj.device.d_nfw_off*obj.device.I_nfw_MB;
       end
       
       function F_nfw_fre = get.F_nfw_fre(obj)
           
           F_nfw_fre = obj.device.d_nfw_fre*obj.device.I_phase*...
               obj.device.f_I_phase;
       end
       
       function F_rel_nfw_win = get.F_rel_nfw_win(obj)
           
           F_rel_nfw_win = 1-(cos((obj.device.phi_phase+...
               obj.device.d_nfw_win1+...
               obj.device.d_nfw_win2*obj.device.f_I_phase)/360*2*pi)/...
               (cos(obj.device.phi_phase/360*2*pi)));
       end
       
       % uncertainty Nullflusswandler i_abc
       function u_rel_nfw = get.u_rel_nfw(obj)
           
           u_rel_nfw = obj.c_R*((obj.F_nfw_lin+obj.F_nfw_off+...
               obj.F_nfw_fre)/obj.device.I_phase+...
               obj.F_rel_nfw_win);
       end
       
       %% DC-link
       % Nullflusswandler
       function F_nfw_lin_dcLink = get.F_nfw_lin_dcLink(obj)
           
           F_nfw_lin_dcLink = obj.device.d_nfw_lin*obj.device.I_dcLink;
       end
       
       function F_nfw_off_dcLink = get.F_nfw_off_dcLink(obj)
           
           F_nfw_off_dcLink = obj.device.d_nfw_off*obj.device.I_nfw_MB;
       end
       
       function F_nfw_fre_dcLink = get.F_nfw_fre_dcLink(obj)
           
           F_nfw_fre_dcLink = obj.device.d_nfw_fre*obj.device.I_dcLink*...
               obj.device.f_I_dcLink;
       end
       
       function F_rel_nfw_win_dcLink = get.F_rel_nfw_win_dcLink(obj)
           
           F_rel_nfw_win_dcLink = 1-(cos((obj.device.phi_dcLink+...
               obj.device.d_nfw_win1+...
               obj.device.d_nfw_win2*obj.device.f_I_dcLink)/360*2*pi)/...
               cos(obj.device.phi_dcLink/360*2*pi));
       end
       
       % uncertainty Nullflusswandler i_DC
       function u_rel_nfw_dcLink = get.u_rel_nfw_dcLink(obj)
           
           u_rel_nfw_dcLink = obj.c_R*((obj.F_nfw_lin_dcLink+...
               obj.F_nfw_off_dcLink+obj.F_nfw_fre_dcLink)/...
               obj.device.I_dcLink+obj.F_rel_nfw_win_dcLink);
       end
       
       %% specifications power analyzor
       
       % error specification power analyzor
       function F_d_dcLink = get.F_d_dcLink(obj) % W
                    
           F_d_dcLink = obj.OP.P_500Hz*obj.device.d_1kHz;
       end
       
       % uncertainty DC-link NFW
       function u_nfw_P_dcLink = get.u_nfw_P_dcLink(obj) % W
           u_nfw_P_dcLink = obj.OP.P_dcLink*obj.u_rel_nfw_dcLink;
       end
       
       
       % error power analyzor DC-link
       function F_analyzer_dcLink = get.F_analyzer_dcLink(obj) % W
          F_analyzer_dcLink = 1/2*obj.F_d_dcLink; 
       end
       
       % uncertainty power analyzor DC-link
       function u_analyzer_dcLink = get.u_analyzer_dcLink(obj) % W
           u_analyzer_dcLink = obj.c_R*obj.F_analyzer_dcLink;
       end
       
       % total uncertainty DC-link, NFW and power analyzor
       function u_total_dcLink = get.u_total_dcLink(obj) % W
           u_total_dcLink = sqrt(obj.u_nfw_P_dcLink^2 +...
               obj.u_analyzer_dcLink^2);
       end
       
       
       
   end
end