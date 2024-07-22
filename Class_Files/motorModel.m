classdef motorModel

    properties
        motor_spec   % struct
        i_dq_ref % operating point in A
        OP
    end

    properties (Dependent)
        
        T_calc       % Nm
        T_calc_idq   % Nm
        u_dq         % V
        T_calc_bound % W
        P_calc       % W
        P_calc_bound % W
        P            % W
        P_loss       % W

    end

    
    methods
        
        %% constructor
        function obj = motorModel(motor,i_dq_ref,OP)
            
            obj.motor_spec = motor;
            obj.i_dq_ref = i_dq_ref;
            obj.OP = OP;
        end
        
        
        %% output function
        
        % calculation of the torque
        function T_calc_idq = get.T_calc_idq(obj) % Nm
            
            T_calc_idq = 3/2*obj.motor_spec.p*(obj.motor_spec.Psi_d.fit_Psi_d(obj.i_dq_ref.i_d,obj.i_dq_ref.i_q)*obj.i_dq_ref.i_q-...
                obj.motor_spec.Psi_q.fit_Psi_q(obj.i_dq_ref.i_d,obj.i_dq_ref.i_q)*obj.i_dq_ref.i_d);
        end
        
        
        % Calculate the motor power
        function P_calc = get.P_calc(obj)
            
            P_calc = obj.T_calc_idq * obj.OP.n_max*2*pi/60;
        end


        % Check boundary for the motor power
        function P_calc_bound = get.P_calc_bound(obj)
            
            if obj.P_calc > obj.motor_spec.P_max

                P_calc_bound = obj.motor_spec.P_max;
            else

                P_calc_bound = obj.P_calc;
            end
        end

        % Output motor power
        function P = get.P(obj)

            P = obj.P_calc_bound;
        end

        
        % Loss
        function P_loss = get.P_loss(obj)
           P_loss = (100-obj.motor_spec.losses.fitLossBrusa(obj.OP.n_max,obj.T_calc_idq))/100*obj.P_calc;
           
        end
        

        
        %%%%
        function T_calc_bound = get.T_calc_bound(obj)
            if obj.P_calc >= obj.motor_spec.P_max || obj.T_calc_idq >= obj.motor_spec.T_max_calc ...
                    || obj.OP.i_dq > obj.motor_spec.i_dq_max_calc || obj.T_calc_idq <= obj.motor_spec.T_calc_min
                T_calc_bound = 0;
            else
                T_calc_bound = obj.T_calc_idq;
            end
        end 
        %%%%
        
        function T_calc = get.T_calc(obj)
            T_calc = obj.T_calc_bound;
        end
        
        
        
        % calculation of the voltage in the steady state
        function u_dq = get.u_dq(obj) % V
            
            i_dq = [obj.i_dq_ref.i_d;obj.i_dq_ref.i_q];
            psi_dq = [obj.motor_spec.Psi_d.fit_Psi_d(obj.i_dq_ref.i_d,obj.i_dq_ref.i_q);
                obj.motor_spec.Psi_q.fit_Psi_q(obj.i_dq_ref.i_d,obj.i_dq_ref.i_q)];
            
            u_dq = obj.motor_spec.Rs*i_dq + obj.OP.n_max*[0,-1;1,0]*psi_dq;
        end
        

      
    end
end

