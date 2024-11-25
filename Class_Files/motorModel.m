classdef motorModel

    properties
        motor_spec   % motor specifications
        OP           % operating point information
        n_op
        i_d
        i_q
        i_dq
    end

    properties (Dependent)
        
        T_calc       % Nm
        T_calc_idq   % Nm
        v_dq_complex % V
        v_dq         % V
        v_ind_dq       % V
        T_calc_bound % W
        P_calc       % W
        P_calc_bound % W
        P_loss       % W
        P_mech       % W
        S            % W
        phi          % deg
        theta        % deg
        v_ind_dq_complex
        v_ab         % V
        v_abc        % V
        i_ab         % A
        i_abc        % A
    end

    
    methods
        
        %% constructor
        function obj = motorModel(motor,OP,n_op,i_d,i_q,i_dq)
            
            obj.motor_spec = motor;
            obj.OP = OP;
            obj.n_op = n_op;
            obj.i_d = i_d;
            obj.i_q = i_q;
            obj.i_dq = i_dq;
        end
        
        
        %% output function
        
        % calculation of the torque
        function T_calc_idq = get.T_calc_idq(obj) % Nm

            T_calc_idq = 3/2*obj.motor_spec.p*(obj.motor_spec.Psi_d.fit_Psi_d(obj.i_d,obj.i_q)*obj.i_q-...
                obj.motor_spec.Psi_q.fit_Psi_q(obj.i_d,obj.i_q)*obj.i_d);
        end
        
        
        % Calculate the motor power
        function P_calc = get.P_calc(obj)
            
            P_calc = obj.T_calc_idq * obj.n_op*2*pi/60;
        end


        % Check boundary for the motor power
        function P_calc_bound = get.P_calc_bound(obj)
            
            if obj.P_calc > obj.motor_spec.P_max

                P_calc_bound = obj.motor_spec.P_max;
            else

                P_calc_bound = obj.P_calc;
            end
        end
              
        % Loss
        function P_loss = get.P_loss(obj)
           P_loss = (100-obj.motor_spec.eta.fit_eta(obj.n_op,obj.T_calc_idq))/100*obj.P_calc;
           
        end
        

        
        %%%%
        function T_calc_bound = get.T_calc_bound(obj)
            if obj.P_calc >= obj.motor_spec.P_max || obj.T_calc_idq >= obj.motor_spec.T_max_calc ...
                    || obj.i_dq > obj.motor_spec.i_dq_max_calc || obj.T_calc_idq <= obj.motor_spec.T_calc_min
                T_calc_bound = 0;
            else
                T_calc_bound = obj.T_calc_idq;
            end
        end 
        %%%%
        
        function T_calc = get.T_calc(obj)
            T_calc = obj.T_calc_bound;
        end


        % Calculation of the meachnical power
        function P_mech = get.P_mech(obj)
            P_mech = obj.T_calc*obj.n_op/60*2*pi; % W, estimation
        
        end
        
        
        % calculation of the stator voltage in the steady state
        function v_dq = get.v_dq(obj) % V
            
            i_dq_m = [obj.i_d;obj.i_q]; 
            psi_dq = [obj.motor_spec.Psi_d.fit_Psi_d(obj.i_d,obj.i_q);
                obj.motor_spec.Psi_q.fit_Psi_q(obj.i_d,obj.i_q)];
            
            v_dq = obj.motor_spec.Rs*i_dq_m + (obj.n_op/60)*obj.motor_spec.p*2*pi*[0,-1;1,0]*psi_dq;
        end
        

        % calculation of the complex stator voltage in the steady state
        function v_dq_complex = get.v_dq_complex(obj) % V
            
            i_d_complex = obj.i_d;
            i_q_complex = obj.i_q*1j;

            psi_dq = [obj.motor_spec.Psi_d.fit_Psi_d(obj.i_d,obj.i_q);
                obj.motor_spec.Psi_q.fit_Psi_q(obj.i_d,obj.i_q)];
            
            
            v_d_complex = obj.motor_spec.Rs * i_d_complex - obj.n_op/60*obj.motor_spec.p*2*pi*psi_dq(2);
            v_q_complex = obj.motor_spec.Rs * i_q_complex + obj.n_op/60*obj.motor_spec.p*2*pi*psi_dq(1);

            v_dq_complex = [v_d_complex; v_q_complex];
        end


        % calculation of the induced voltage in the steady state
        function v_ind_dq = get.v_ind_dq(obj) % V

            psi_dq = [obj.motor_spec.Psi_d.fit_Psi_d(obj.i_d,obj.i_q);
                obj.motor_spec.Psi_q.fit_Psi_q(obj.i_d,obj.i_q)];
      
            v_ind_dq = (obj.n_op/60)*obj.motor_spec.p*2*pi*[0,-1;1,0]*psi_dq;
        end


        % calculation of the complex induced voltage in the steady state
        function v_ind_dq_complex = get.v_ind_dq_complex(obj) % V

            psi_dq = [obj.motor_spec.Psi_d.fit_Psi_d(obj.i_d,obj.i_q);
                obj.motor_spec.Psi_q.fit_Psi_q(obj.i_d,obj.i_q)];

            u_i_d_complex = -1j*(obj.n_op/60)*obj.motor_spec.p*2*pi*psi_dq(2);
            u_i_q_complex = 1j*(obj.n_op/60)*obj.motor_spec.p*2*pi*psi_dq(1);

            v_ind_dq_complex = [u_i_d_complex; u_i_q_complex];
        end

        % apparent power
        function S = get.S(obj) % W
            
            S = 3/2* obj.v_dq * obj.i_dq;
        end


        % power factor angle calculation
        function phi = get.phi(obj)

            psi_dq = [obj.motor_spec.Psi_d.fit_Psi_d(obj.i_d,obj.i_q);
                obj.motor_spec.Psi_q.fit_Psi_q(obj.i_d,obj.i_q)];
            
            Z_L = 2*pi*(obj.n_op/60) *obj.motor_spec.p * psi_dq(2);

            phi = atand(imag(Z_L)/real(Z_L));
        end


        % load angle 
        function theta = get.theta(obj)            
            theta = atand(abs(obj.v_dq_complex(1)/obj.v_dq_complex(2)));
        end



        %% voltage
        % dq -> alpha bera
        function v_ab =get.v_ab(obj)

            epsilon_el = linspace(0,2*pi,200);

            % initialization
            v_ab = zeros(2,length(epsilon_el));

            for zz=1:1:length(epsilon_el)
                % transformation matrix
                Tdqab = [cos(epsilon_el(zz)), sin(epsilon_el(zz)); -sin(epsilon_el(zz)), cos(epsilon_el(zz))];
                
                v_ab(:,zz) = Tdqab*obj.v_dq;
            end
        end

        % alpha beta -> abc
        function v_abc = get.v_abc(obj)
            % transformation matrix abc -> ab
            Tababc = 2/3*[1,-1/2,-1/2;0,sqrt(3)/2,-sqrt(3)/2];

            % inverse
            Tabcab = pinv(Tababc);
            v_abc = zeros(3,length(obj.v_ab(1,:)));

            for zz=1:1:length(obj.v_ab(1,:))
                v_abc(:,zz) = Tabcab * obj.v_ab(:,zz);
            end
        end

        

        %% current
        % dq -> alpha bera
        function i_ab =get.i_ab(obj)

            epsilon_el = linspace(0,2*pi,200);

            % initialization
            i_ab = zeros(2,length(epsilon_el));

            for zz=1:1:length(epsilon_el)
                % transformation matrix
                Tdqab = [cos(epsilon_el(zz)), sin(epsilon_el(zz)); -sin(epsilon_el(zz)), cos(epsilon_el(zz))];
                
                i_ab(:,zz) = Tdqab*[obj.i_d;obj.i_q];
            end
        end

        % alpha beta -> abc
        function i_abc = get.i_abc(obj)

            % transformation matrix abc -> ab
            Tababc = 2/3*[1,-1/2,-1/2;0,sqrt(3)/2,-sqrt(3)/2];

            % inverse
            Tabcab = pinv(Tababc);
            i_abc = zeros(3,length(obj.i_ab(1,:)));

            for zz=1:1:length(obj.i_ab(1,:))
                i_abc(:,zz) = Tabcab * obj.i_ab(:,zz);
            end
        end



    end
end


























