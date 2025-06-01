classdef inverterModel

    properties
        semiconductor
        motor
        v_DC
        counter
        f_el
        T_el
        i_dq
        motor_v_abc
        motor_i_abc
    end

    properties (Dependent)

        P_sw    % W
        P_conduction  % W
        P_loss_DC % W
        P_loss  % W
        n_steps
    end

    
    methods

        %% constructor
        function obj = inverterModel(semiconductor,motor,v_DC,counter,f_el,T_el,i_dq,motor_v_abc,motor_i_abc)

            obj.semiconductor = semiconductor;
            obj.motor = motor;
            obj.v_DC = v_DC;
            obj.counter = counter;
            obj.f_el = f_el;
            obj.T_el = T_el;
            obj.i_dq = i_dq;
            obj.motor_v_abc = motor_v_abc;
            obj.motor_i_abc = motor_i_abc;
        end


        %% general functions

        function P_sw = get.P_sw(obj)

            % select voltage of phase a
            v_a = obj.motor_v_abc(1,:)/obj.v_DC;

            %
            end_value = length(v_a);
            t_s = 0:1:end_value;
            s = zeros(end_value);

            for zz = 1:1:length(t_s)-1
                % compare the triangle signal (carrier) with the reference signal
                if v_a(1,zz) > obj.counter(1,zz)
                    % pulse high
                    s(zz) = 1;
                else
                    % pulse low
                    s(zz) = -1;
                end

            end


            switching_times = zeros(1,length(t_s)-1);

            % determine the switching time points
            for zz=2:1:length(t_s)-1

                if s(zz) ~= s(zz-1)
                    switching_times(zz) = s(zz);

                end
            end


            % current          
            current_values = zeros(1,length(t_s));
            % select current of phase a
            i_a = obj.motor_i_abc(1,:);

            % get the current values at the switching points
            for zz=1:1:length(t_s)-1

                if switching_times(zz) ~= 0
                    current_values(zz) = i_a(1,zz);

                end
            end


            E_on = zeros(1,length(t_s)-1);
            E_off = zeros(1,length(t_s)-1);

            for zz=1:1:length(t_s)

                if current_values(zz) ~= 0
                    if switching_times(zz) == 1
                        E_on(zz) = obj.semiconductor.fit_E_on.fit_E_on(abs(current_values(zz)));

                    elseif switching_times(zz) == -1
                        E_off(zz) = obj.semiconductor.fit_E_off.fit_E_off(abs(current_values(zz)));
                    end
                end
            end

            P_sw = (6*((1/length(t_s))*(sum(E_on)+sum(E_off))))*(1/obj.T_el);

        end


        %% output function

        % conduction loss
        function P_conduction = get.P_conduction(obj) % W

            P_conduction = 3*obj.i_dq^2*obj.semiconductor.R_ds_on;
        end

        % DC link loss
        function P_loss_DC = get.P_loss_DC(obj)
            P_loss_DC = obj.semiconductor.R_ESR * obj.i_dq^2;
        end


        % Mosfet loss calculation
        function P_loss = get.P_loss(obj) % W

            P_loss = obj.P_sw + obj.P_conduction + obj.P_loss_DC;
        end


    end
end
