classdef powerAnalyzerUncertainty
    
    properties
        device
        OP
        motor

    end
    
   properties (Access = private)
       b_r = 1/sqrt(3);
   end
   
   properties (Dependent)   %
       u_T3                 % Nm
       u_n3                 % 1/min
       %
       % dcLink
       u_CT_lin_abc         % A, CT, linearity
       u_CT_offset_abc      % A, CT, offset 
       u_CT_f_abc           % 1, CT, frequency influence
       u_CT_phi_rel_abc     % 1, CT, angular influence
       u_CT_rel_abc         % A, CT, relative
       %
       % abc
       u_CT_lin_dcLink      % A, CT, linearity
       u_CT_offset_dcLink   % A, CT, offset
       u_CT_f_dcLink        % A, CT, frequency influence
       u_CT_phi_dcLink      % 1, CT, angular influence
       u_CT_rel_dcLink      %A, CT, relative
       %
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
       
       
        %% power analyzer torque, rotational speed
        % input: values from the amplifier
        % 
        % troque
        function u_T3 = get.u_T3(obj) % Nm
           
            u_T3 = obj.b_r*(obj.device.d_A*obj.motor.T_calc+obj.device.d_a_MR*...
                obj.device.T_MR);
        end
       
        % rotational speed
        function u_n3 = get.u_n3(obj) % 1/min
           
            u_n3 = obj.b_r*(obj.device.d_A*obj.OP.n_op+obj.device.d_a_MR*...
                obj.device.n_ME);
        end
       
        %% current transducer; i_abc
        % input: measurement values

        % linearity
        function u_CT_lin_abc = get.u_CT_lin_abc(obj)
           
            u_CT_lin_abc = obj.device.d_CT_lin*obj.device.I_phase;
        end
       
        % offset
       function u_CT_offset_abc = get.u_CT_offset_abc(obj)
           
           u_CT_offset_abc = obj.device.d_CT_offset*obj.device.I_CT_MR;
       end
       
       % frequency influence
       function u_CT_f_abc = get.u_CT_f_abc(obj)
           
           u_CT_f_abc = obj.device.d_CT_f*obj.device.I_phase*...
               obj.device.f_I_phase;
       end
       
       % angular influence
       function u_CT_phi_rel_abc = get.u_CT_phi_rel_abc(obj)
           
           u_CT_phi_rel_abc = 1-(cos((obj.device.phi_phase+...
               obj.device.d_CT_phi_fix+...
               obj.device.d_CT_phi_var*obj.device.f_I_phase)/360*2*pi)/...
               (cos(obj.device.phi_phase/360*2*pi)));
       end
       
       % relativ; i_abc
       function u_CT_rel_abc = get.u_CT_rel_abc(obj)
           
           u_CT_rel_abc = obj.b_r*((obj.u_CT_lin_abc+obj.u_CT_offset_abc+...
               obj.u_CT_f_abc)/obj.device.I_phase+...
               obj.u_CT_phi_rel_abc);
       end
       
        %% current transducer; i_dcLink
        % input: measurement values

        % linearity
        function u_CT_lin_dcLink = get.u_CT_lin_dcLink(obj)
           
            u_CT_lin_dcLink = obj.device.d_CT_lin*obj.device.I_dcLink;
        end
       
        % offset
        function u_CT_offset_dcLink = get.u_CT_offset_dcLink(obj)
           
            u_CT_offset_dcLink = obj.device.d_CT_offset*obj.device.I_CT_MR;
        end
       
        % frequency influence
        function u_CT_f_dcLink = get.u_CT_f_dcLink(obj)
           
            u_CT_f_dcLink = obj.device.d_CT_f*obj.device.I_dcLink*...
                obj.device.f_I_dcLink;
        end
       
        % angular influence
        function u_CT_phi_dcLink = get.u_CT_phi_dcLink(obj)
           
            u_CT_phi_dcLink = 1-(cos((obj.device.phi_dcLink+...
                obj.device.d_CT_phi_fix+...
                obj.device.d_CT_phi_var*obj.device.f_I_dcLink)/360*2*pi)/...
                cos(obj.device.phi_dcLink/360*2*pi));
        end
       
        % relativ; i_dcLink
        function u_CT_rel_dcLink = get.u_CT_rel_dcLink(obj)
           
            u_CT_rel_dcLink = obj.b_r*((obj.u_CT_lin_dcLink+...
                obj.u_CT_offset_dcLink+obj.u_CT_f_dcLink)/...
                obj.device.I_dcLink+obj.u_CT_phi_dcLink);
        end
       
       
        %% power analyzor
        % input: values from the CT
        
        % 
        function F_d_dcLink = get.F_d_dcLink(obj) % W
                    
            F_d_dcLink = obj.OP.P_500Hz*obj.device.d_1kHz;
        end
       
        % uncertainty DC-link NFW
        function u_nfw_P_dcLink = get.u_nfw_P_dcLink(obj) % W
            u_nfw_P_dcLink = obj.OP.P_dcLink*obj.u_CT_rel_dcLink;
        end
       
       
        % error power analyzor DC-link
        function F_analyzer_dcLink = get.F_analyzer_dcLink(obj) % W
            F_analyzer_dcLink = 1/2*obj.F_d_dcLink; 
        end
       
        % uncertainty power analyzor DC-link
        function u_analyzer_dcLink = get.u_analyzer_dcLink(obj) % W
            u_analyzer_dcLink = obj.b_r*obj.F_analyzer_dcLink;
        end
       
        % total uncertainty DC-link, NFW and power analyzor
        function u_total_dcLink = get.u_total_dcLink(obj) % W
            u_total_dcLink = sqrt(obj.u_nfw_P_dcLink^2 +...
                obj.u_analyzer_dcLink^2);
        end
       
       
       
   end
end