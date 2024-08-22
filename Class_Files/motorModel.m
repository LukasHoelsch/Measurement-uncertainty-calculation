classdef motorModel

    properties
        motor_spec   % motor specifications
        OP           % operating point information 
    end

    properties (Dependent)
        
        T_calc       % Nm
        T_calc_idq   % Nm
        u_dq_complex
        u_dq         % V
        u_i_dq       % V
        T_calc_bound % W
        P_calc       % W
        P_calc_bound % W
        P            % W
        P_loss       % W
        P_mech       % W
        S            % W
        phi          % deg
        theta        % deg
        u_i_dq_complex
        u_ab         % V
        u_abc        % V
        i_ab         % A
        i_abc        % A
    end

    
    methods
        
        %% constructor
        function obj = motorModel(motor,OP)
            
            obj.motor_spec = motor;
            obj.OP = OP;
        end
        
        
        %% output function
        
        % calculation of the torque
        function T_calc_idq = get.T_calc_idq(obj) % Nm
            
            T_calc_idq = 3/2*obj.motor_spec.p*(obj.motor_spec.Psi_d.fit_Psi_d(obj.OP.i_d,obj.OP.i_q)*obj.OP.i_q-...
                obj.motor_spec.Psi_q.fit_Psi_q(obj.OP.i_d,obj.OP.i_q)*obj.OP.i_d);
        end
        
        
        % Calculate the motor power
        function P_calc = get.P_calc(obj)
            
            P_calc = obj.T_calc_idq * obj.OP.n_op*2*pi/60;
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
           P_loss = (100-obj.motor_spec.losses.fitLossBrusa(obj.OP.n_op,obj.T_calc_idq))/100*obj.P_calc;
           
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


        % Calculation of the meachnical power
        function P_mech = get.P_mech(obj)
            P_mech = obj.T_calc*obj.OP.n_op/60*2*pi; % W, estimation
        
        end
        
        
        % calculation of the stator voltage in the steady state
        function u_dq = get.u_dq(obj) % V
            
            i_dq = [obj.OP.i_d;obj.OP.i_q]; 
            psi_dq = [obj.motor_spec.Psi_d.fit_Psi_d(obj.OP.i_d,obj.OP.i_q);
                obj.motor_spec.Psi_q.fit_Psi_q(obj.OP.i_d,obj.OP.i_q)];
            
            u_dq = obj.motor_spec.Rs*i_dq + (obj.OP.n_op/60)*obj.motor_spec.p*2*pi*[0,-1;1,0]*psi_dq;
        end
        

        % calculation of the complex stator voltage in the steady state
        function u_dq_complex = get.u_dq_complex(obj) % V
            
            %i_dq = [obj.OP.i_d;obj.OP.i_q]; 
            %i_dq_complex = obj.OP.i_d + 1j*obj.OP.i_q; % imaginary i_q from the lecture EMD, slide 301

            i_d_complex = obj.OP.i_d;
            i_q_complex = obj.OP.i_q*1j;

            psi_dq = [obj.motor_spec.Psi_d.fit_Psi_d(obj.OP.i_d,obj.OP.i_q);
                obj.motor_spec.Psi_q.fit_Psi_q(obj.OP.i_d,obj.OP.i_q)];
            
            % u_dq_complex = obj.motor_spec.Rs*i_dq_complex - obj.OP.n_op/60*obj.motor_spec.p*2*pi*psi_dq(2) +...
            %     obj.OP.n_op/60*obj.motor_spec.p*2*pi*psi_dq(1) ;

            u_d_complex = obj.motor_spec.Rs * i_d_complex - obj.OP.n_op/60*obj.motor_spec.p*2*pi*psi_dq(2);
            u_q_complex = obj.motor_spec.Rs * i_q_complex + obj.OP.n_op/60*obj.motor_spec.p*2*pi*psi_dq(1);

            u_dq_complex = [u_d_complex; u_q_complex];

            "u_dq_complex";
            u_dq_complex;

           
        end


        % calculation of the induced voltage in the steady state
        function u_i_dq = get.u_i_dq(obj) % V

            psi_dq = [obj.motor_spec.Psi_d.fit_Psi_d(obj.OP.i_d,obj.OP.i_q);
                obj.motor_spec.Psi_q.fit_Psi_q(obj.OP.i_d,obj.OP.i_q)];
      
            u_i_dq = (obj.OP.n_op/60)*obj.motor_spec.p*2*pi*[0,-1;1,0]*psi_dq;
        end


        % calculation of the complex induced voltage in the steady state
        function u_i_dq_complex = get.u_i_dq_complex(obj) % V

            psi_dq = [obj.motor_spec.Psi_d.fit_Psi_d(obj.OP.i_d,obj.OP.i_q);
                obj.motor_spec.Psi_q.fit_Psi_q(obj.OP.i_d,obj.OP.i_q)];
      
            %u_i_dq_complex = -1j*(obj.OP.n_op/60)*obj.motor_spec.p*2*pi*psi_dq(2)+1j*(obj.OP.n_op/60)*obj.motor_spec.p*2*pi*psi_dq(1);
            

            u_i_d_complex = -1j*(obj.OP.n_op/60)*obj.motor_spec.p*2*pi*psi_dq(2);
            u_i_q_complex = 1j*(obj.OP.n_op/60)*obj.motor_spec.p*2*pi*psi_dq(1);

            u_i_dq_complex = [u_i_d_complex; u_i_q_complex];

            "u_i_dq_complex";
            u_i_dq_complex;

        end

        % apparent power
        function S = get.S(obj) % W
            
            S = 3*3/2* obj.u_dq * obj.OP.i_dq;
        end


        % power factor angle calculation
        function phi = get.phi(obj)
            
            phi = acosd((obj.P_mech+obj.P_loss)/obj.S);
        end


        % load angle 
        function theta = get.theta(obj)

            %theta = asind(abs(obj.u_i_dq_complex-obj.u_dq_complex)/abs(obj.u_dq_complex));
            
            theta = atand(abs(obj.u_dq_complex(1)/obj.u_dq_complex(2)));
        end



        %% voltage
        % dq -> alpha bera
        function u_ab =get.u_ab(obj)

            epsilon_el = 0:0.1:2*pi;

            % initialization
            u_ab = zeros(2,length(epsilon_el));

            for zz=1:1:length(epsilon_el)
                % transformation matrix
                Tdqab = [cos(epsilon_el(zz)), sin(epsilon_el(zz)); -sin(epsilon_el(zz)), cos(epsilon_el(zz))];
                
                u_ab(:,zz) = Tdqab*obj.u_dq;
            end
        end

        % alpha beta -> abc
        function u_abc = get.u_abc(obj)

            % transformation matrix abc -> ab
            Tababc = 2/3*[1,-1/2,-1/2;0,sqrt(3)/2,-sqrt(3)/2];

            % inverse
            Tabcab = pinv(Tababc);
            u_abc = zeros(3,length(obj.u_ab(1,:)));

            for zz=1:1:length(obj.u_ab(1,:))
                u_abc(:,zz) = Tabcab * obj.u_ab(:,zz);
            end
        end

        

        %% current
        % dq -> alpha bera
        function i_ab =get.i_ab(obj)

            epsilon_el = 0:0.1:2*pi;

            % initialization
            i_ab = zeros(2,length(epsilon_el));

            for zz=1:1:length(epsilon_el)
                % transformation matrix
                Tdqab = [cos(epsilon_el(zz)), sin(epsilon_el(zz)); -sin(epsilon_el(zz)), cos(epsilon_el(zz))];
                
                i_ab(:,zz) = Tdqab*[obj.OP.i_d;obj.OP.i_q];
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


























