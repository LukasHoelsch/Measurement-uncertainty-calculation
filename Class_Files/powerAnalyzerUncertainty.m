classdef powerAnalyzerUncertainty
    
    properties
        device
        device_torque
        n_op
        motor_T_calc
        I_abc_fund
        f_I_abc_fund
        angle_phi
        I_abc_harm
        motor_v_dq
        I_dcLink
        v_DC
        f_n
        f_T
    end
    
   properties (Access = private)
       b_r = 1/sqrt(3);
   end
   
   properties (Dependent)   %
       u_T3                 % Nm
       u_n3                 % 1/min
       %
       % abc, current transducer
       u_CT_lin_abc         % A, CT, linearity
       u_CT_offset_abc      % A, CT, offset 
       u_CT_f_abc           % 1, CT, frequency influence
       u_CT_phi_abc_MM     % 1, CT, angular influence
       %
       u_CT_abc_SM         % A, CT, single measurement
       u_CT_abc_MM         % A, CT, multi measurement
       %
       %
       % dcLink, current transducer
       u_CT_lin_dcLink      % A, CT, linearity
       u_CT_offset_dcLink   % A, CT, offset
       %
       u_CT_dcLink_SM      % A, CT, absolut
       u_CT_dcLink_MM      % A, CT, relative
       %
       %
       % abc, power analyzer
       i_a          % A
       v_a          % V
       %
       u_el_abc_SM     % single measurement
       u_el_abc_MM     % multi measurement
       %
       %
       % dcLink, power anaylzer
       u_PA_dcLink_i           % display error
       u_PA_dcLink_v
       %
       u_i_dcLink_SM 
       u_i_dcLink_MM
       %
       u_c_el_dcLink_SM     % single measurement
       u_c_el_dcLink_MM     % multi measurement
   end
   
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %% static methods %%
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   methods(Static)
        % frequency influence
        function u_CT_f_dcLink = u_CT_f_dcLink()
            % assumption: only active DC power
            u_CT_f_dcLink = 0;
        end
       
        % angular influence
        function u_CT_phi_dcLink = u_CT_phi_dcLink()
            % assumption: only active DC power
            u_CT_phi_dcLink = 0;
        end

   end
   
   methods
       
       
        %% constructor
        function obj = powerAnalyzerUncertainty(device,device_torque,n_op,motor_T_calc,I_abc_fund,...
                f_I_abc_fund,angle_phi,I_abc_harm,motor_v_dq,I_dcLink,v_DC,f_n,f_T)
           
            obj.device = device;
            obj.device_torque = device_torque;
            obj.n_op = n_op;
            obj.motor_T_calc = motor_T_calc;
            obj.I_abc_fund = I_abc_fund;
            obj.f_I_abc_fund = f_I_abc_fund;
            obj.angle_phi = angle_phi;
            obj.I_abc_harm = I_abc_harm;
            obj.motor_v_dq = motor_v_dq;
            obj.I_dcLink = I_dcLink;
            obj.v_DC = v_DC;
            obj.f_n = f_n;
            obj.f_T = f_T;
        end
       
       
        %% power analyzer torque, rotational speed
        % input: values from the amplifier
        % 
        % troque
        function u_T3 = get.u_T3(obj) % Nm
           
            u_T3 = (obj.b_r*(obj.device.d_pulse_1+obj.f_T/obj.device.d_pulse_2))/obj.device_torque.f_T_nom*obj.motor_T_calc;

        end
       
        % rotational speed
        function u_n3 = get.u_n3(obj) % 1/min
            
            u_n3 = (obj.b_r*(obj.device.d_pulse_1+obj.f_n/obj.device.d_pulse_2))*60/obj.device_torque.d_inc;
        end
       
        %% current transducer; i_abc
        % input: measurement values

        % linearity
        function u_CT_lin_abc = get.u_CT_lin_abc(obj)
           
            u_CT_lin_abc = obj.b_r * obj.device.d_CT_lin*obj.I_abc_fund;
        end
       
        % offset
       function u_CT_offset_abc = get.u_CT_offset_abc(obj)
           
           u_CT_offset_abc = obj.b_r * obj.device.d_CT_offset*obj.device.I_CT_MR;
       end
       
       % frequency influence
       function u_CT_f_abc = get.u_CT_f_abc(obj)
           
           u_CT_f_abc = obj.b_r * obj.device.d_CT_f*obj.I_abc_fund*...
               obj.f_I_abc_fund;
       end
       
       % angular influence
       function u_CT_phi_abc_MM = get.u_CT_phi_abc_MM(obj)
           
           u_CT_phi_abc_MM = obj.b_r * (1-(cos((obj.angle_phi+...
               obj.device.d_CT_phi_fix+...
               obj.device.d_CT_phi_var*obj.f_I_abc_fund)/360*2*pi)/...
               (cos(obj.angle_phi/360*2*pi))));
       end


       % abs; i_abc
       function u_CT_abc_SM = get.u_CT_abc_SM(obj)
           
           u_CT_abc_SM = sqrt(obj.u_CT_lin_abc^2+obj.u_CT_offset_abc^2+...
               obj.u_CT_f_abc^2 + obj.u_CT_phi_abc_MM^2);
       end
       

       % relativ; i_abc
       function u_CT_abc_MM = get.u_CT_abc_MM(obj)
           
           u_CT_abc_MM = sqrt(obj.u_CT_f_abc^2 + obj.u_CT_phi_abc_MM^2);
       end


       %% power analyzer, i_abc

       % phase current a
       function i_a = get.i_a(obj)
            
          i_a = obj.b_r*(obj.I_abc_fund*obj.device.d_current_fund + ...
                obj.I_abc_harm*obj.device.d_current_harm + ...
                obj.device.I_MR*obj.device.d_current_fund_MR + ...
                obj.device.I_MR*obj.device.d_current_harm_MR);
       
       end

       % phase voltage a
       function v_a = get.v_a(obj)
           % scaling with 2/3 from the Clark transformation
           % calculation of the RMS value wit sqrt(2) for the uncertaitny
           v_a = obj.b_r*(obj.motor_v_dq*(2/3)/sqrt(2)*0.95*obj.device.d_voltage_fund + ...
                obj.motor_v_dq*(2/3)/sqrt(2)*0.05*obj.device.d_voltage_harm + ...
                obj.device.U_MR*obj.device.d_voltage_fund_MR + ...
                obj.device.U_MR*obj.device.d_voltage_harm_MR);
       
       end

       
       % absolute
       function u_el_abc_SM = get.u_el_abc_SM(obj)

           u_el_abc_SM = sqrt(obj.i_a^2+obj.i_a^2+obj.i_a^2+ ...
               obj.v_a^2+obj.v_a^2+obj.v_a^2 + ...
               obj.u_CT_abc_SM^2+obj.u_CT_abc_SM^2+obj.u_CT_abc_SM^2);
       
       end

       % relativ
       function u_el_abc_MM = get.u_el_abc_MM(obj)

           u_el_abc_MM = sqrt(obj.i_a^2+obj.i_a^2+obj.i_a^2+ ...
               obj.v_a^2+obj.v_a^2+obj.v_a^2 + ...
               obj.u_CT_abc_MM^2+obj.u_CT_abc_MM^2+obj.u_CT_abc_MM^2);
       
       end


       
        %% current transducer; i_dcLink
        % input: measurement values

        % linearity
        function u_CT_lin_dcLink = get.u_CT_lin_dcLink(obj)
           
            u_CT_lin_dcLink = obj.b_r * obj.device.d_CT_lin*obj.I_dcLink;
        end
       
        % offset
        function u_CT_offset_dcLink = get.u_CT_offset_dcLink(obj)
           
            u_CT_offset_dcLink = obj.b_r * obj.device.d_CT_offset*obj.device.I_CT_MR;
        end
       
        % absolut; i_dcLink
        function u_CT_dcLink_SM = get.u_CT_dcLink_SM(obj)
           
            u_CT_dcLink_SM = sqrt(obj.u_CT_lin_dcLink^2 +...
                obj.u_CT_offset_dcLink^2+obj.u_CT_f_dcLink^2 +...
                obj.u_CT_phi_dcLink^2);
        end


        % relativ; i_dcLink
        function u_CT_dcLink_MM = get.u_CT_dcLink_MM(obj)
           
            u_CT_dcLink_MM = sqrt(obj.u_CT_f_dcLink^2 +obj.u_CT_phi_dcLink^2);
        end
       
       
        %% power analyzor, i_dcLink 
        % input: values from the CT
        
        % DC link current
        function u_PA_dcLink_i = get.u_PA_dcLink_i(obj) % W
                    
            u_PA_dcLink_i = obj.b_r * obj.I_dcLink*obj.device.d_current_DC;
        end
       
        % DC link voltage
        function u_PA_dcLink_v = get.u_PA_dcLink_v(obj) % W
                    
            u_PA_dcLink_v = obj.b_r * obj.v_DC*obj.device.d_voltage_DC;
        end
       
       
        % current DC-link, single
        function u_i_dcLink_SM = get.u_i_dcLink_SM(obj) % W
            u_i_dcLink_SM = sqrt(obj.u_PA_dcLink_i^2+obj.u_CT_dcLink_SM^2); 
        end

        % current DC-link, multiple
        function u_i_dcLink_MM = get.u_i_dcLink_MM(obj) % W
            u_i_dcLink_MM = sqrt(obj.u_PA_dcLink_i^2+obj.u_CT_dcLink_MM^2); 
        end
       

        %% combined uncertainty
        % single
        function u_c_el_dcLink_SM = get.u_c_el_dcLink_SM(obj) % W
            u_c_el_dcLink_SM = sqrt(obj.u_PA_dcLink_v^2 * obj.u_i_dcLink_SM^2 + ...
             obj.u_i_dcLink_SM^2*obj.u_PA_dcLink_v^2);
        end

        % multiple
        function u_c_el_dcLink_MM = get.u_c_el_dcLink_MM(obj) % W
            u_c_el_dcLink_MM = sqrt(obj.u_PA_dcLink_v^2 * obj.u_i_dcLink_MM^2 + ...
             obj.u_i_dcLink_MM^2*obj.u_PA_dcLink_v^2);
        end
       
               
       
   end
end