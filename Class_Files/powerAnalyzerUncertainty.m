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
       % torque
       u_T3                 % Nm
       %
       % speed
       u_n3                 % 1/min
       %
       % abc, current transducer
       u_CT_lin_abc         % A, CT, linearity
       u_CT_offset_abc      % A, CT, offset 
       u_CT_f_abc           % 1, CT, frequency influence
       u_CT_phi_rel_abc     % 1, CT, angular influence
       %
       u_CT_abs_abc         % A, CT, absolute
       u_CT_rel_abc         % A, CT, relative
       %
       %
       % dcLink, current transducer
       u_CT_lin_dcLink      % A, CT, linearity
       u_CT_offset_dcLink   % A, CT, offset
       u_CT_f_dcLink        % A, CT, frequency influence
       u_CT_phi_dcLink      % 1, CT, angular influence
       %
       u_CT_abs_dcLink      % A, CT, absolut
       u_CT_rel_dcLink      % A, CT, relative
       %
       %
       % abc, power analyzer
       u_current_a          % A
       u_voltage_a          % V
       %
       u_el_abs_abc     % absolut
       u_el_rel_abc     % relative
       %
       %
       % dcLink, power anaylzer
       u_PA_a_dcLink_i           % relative display error
       u_PA_a_dcLink_v
       u_PA_dcLink
       %
       u_abs_dcLink     % absolut
       u_rel_dcLink     % relative
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


       % abs; i_abc
       function u_CT_abs_abc = get.u_CT_abs_abc(obj)
           
           u_CT_abs_abc = obj.b_r*(sqrt(obj.u_CT_lin_abc^2+obj.u_CT_offset_abc^2+...
               obj.u_CT_f_abc^2 + obj.u_CT_phi_rel_abc^2));
       end
       

       % relativ; i_abc
       function u_CT_rel_abc = get.u_CT_rel_abc(obj)
           
           u_CT_rel_abc = obj.b_r*(sqrt(obj.u_CT_f_abc^2 + obj.u_CT_phi_rel_abc^2));
       end


       %% power analyzer, i_abc

       % phase current a
       function u_current_a = get.u_current_a(obj)
            
            u_current_a = obj.b_r*(obj.OP.I_abc_fund*obj.device.d_current_fund + ...
                obj.OP.I_abc_harm*obj.device.d_current_harm + ...
                obj.device.I_MR*obj.device.d_current_fund_MR + ...
                obj.device.I_MR*obj.device.d_current_harm_MR);
       
       end

       % phase voltage a
       function u_voltage_a = get.u_voltage_a(obj)
           % scaling with 2/3 from the Clark transformation
           % calculation of the RMS value wit sqrt(2) for the uncertaitny
           u_voltage_a = obj.b_r*(obj.motor.u_dq*(2/3)/sqrt(2)*0.95*obj.device.d_voltage_fund + ...
                obj.motor.u_dq*(2/3)/sqrt(2)*0.05*obj.device.d_voltage_harm + ...
                obj.device.U_MB*obj.device.d_voltage_fund_MR + ...
                obj.device.U_MR*obj.device.d_voltage_harm_MR);
       
       end

       
       % absolute
       function u_el_abs_abc = get.u_el_abs_abc(obj)

           u_el_abs_abc = sqrt(obj.u_current_a^2+obj.u_current_a^2+obj.u_current_a^2+ ...
               obj.u_voltage_a^2+obj.u_voltage_a^2+obj.u_voltage_a^2 + ...
               obj.u_CT_abs_abc^2);
       
       end

       % relativ
       function u_el_rel_abc = get.u_el_rel_abc(obj)

           u_el_rel_abc = sqrt(obj.u_current_a^2+obj.u_current_a^2+obj.u_current_a^2+ ...
               obj.u_voltage_a^2+obj.u_voltage_a^2+obj.u_voltage_a^2 + ...
               obj.u_CT_rel_abc^2);
       
       end


       
        %% current transducer; i_dcLink
        % input: measurement values

        % linearity
        function u_CT_lin_dcLink = get.u_CT_lin_dcLink(obj)
           
            u_CT_lin_dcLink = obj.device.d_CT_lin*obj.OP.I_dcLink;
        end
       
        % offset
        function u_CT_offset_dcLink = get.u_CT_offset_dcLink(obj)
           
            u_CT_offset_dcLink = obj.device.d_CT_offset*obj.device.I_CT_MR;
        end
       
        % frequency influence
        function u_CT_f_dcLink = get.u_CT_f_dcLink(obj)
            % assumption: only active DC power
            u_CT_f_dcLink = 0;
        end
       
        % angular influence
        function u_CT_phi_dcLink = get.u_CT_phi_dcLink(obj)
            % assumption: only active DC power
            u_CT_phi_dcLink = 0;
        end
       
        % absolut; i_dcLink
        function u_CT_abs_dcLink = get.u_CT_abs_dcLink(obj)
           
            u_CT_abs_dcLink = obj.b_r*sqrt(obj.u_CT_lin_dcLink^2 +...
                obj.u_CT_offset_dcLink^2+obj.u_CT_f_dcLink^2 +...
                obj.u_CT_phi_dcLink^2);
        end


        % relativ; i_dcLink
        function u_CT_rel_dcLink = get.u_CT_rel_dcLink(obj)
           
            u_CT_rel_dcLink = obj.b_r*sqrt(obj.u_CT_f_dcLink^2 +obj.u_CT_phi_dcLink^2);
        end
       
       
        %% power analyzor, i_dcLink 
        % input: values from the CT
        
        % phase current a
        function u_PA_a_dcLink_i = get.u_PA_a_dcLink_i(obj) % W
                    
            u_PA_a_dcLink_i = (obj.OP.I_dcLink)*obj.device.d_current_DC;
        end
       
        % phase voltage a
        function u_PA_a_dcLink_v = get.u_PA_a_dcLink_v(obj) % W
                    
            u_PA_a_dcLink_v = obj.OP.u_DC*obj.device.d_voltage_DC;
        end
       
       
        % error power analyzor DC-link
        function u_PA_dcLink = get.u_PA_dcLink(obj) % W
            u_PA_dcLink = sqrt(obj.u_PA_a_dcLink_i^2+obj.u_PA_a_dcLink_v^2); 
        end
       
        % absolut
        function u_abs_dcLink = get.u_abs_dcLink(obj) % W
            u_abs_dcLink = obj.b_r*(sqrt(obj.u_CT_abs_dcLink^2+obj.u_PA_dcLink^2));
        end

        % relativ
        function u_rel_dcLink = get.u_rel_dcLink(obj) % W
            u_rel_dcLink = obj.b_r*(sqrt(obj.u_CT_rel_dcLink^2+obj.u_PA_dcLink^2));
        end
       
               
       
   end
end