classdef inverterModel

    properties
        semiconductor
        motor
        OP
    end

    properties (Dependent)

        P_sw    % W
        %P_cond  % W
        P_loss  % W
        n_steps
        P_conduction


    end

    
    methods

        %% constructor
        function obj = inverterModel(semiconductor,motor,OP)

            obj.semiconductor = semiconductor;
            obj.motor = motor;
            obj.OP = OP;
        end


        %% general functions

        % number of sampling points
        function n_steps = get.n_steps(obj)
            %n_steps = obj.OP.T_el/obj.OP.t_sampling;
            n_steps = 49;
        end


        % counter function (triangle)
        function P_sw = get.P_sw(obj)
            % sample step
            t_s = 0:1:obj.n_steps;

            % counter start value
            counter=-500;

            % initialization
            a = zeros(1,length(t_s));
            zz = 1;

            while zz < length(t_s)
                if counter == -500
                    while counter < 500
                        a(zz) = counter;
                        counter = counter +20;
                        zz = zz+1;
                    end
                end

                if counter ==500
                    while counter > -500
                        a(zz) = counter;
                        counter = counter -20;
                        zz = zz+1;
                    end
                end
            end


            % resize the carrier signal
            carrier = a(1:length(t_s)-1);

            % new variable
            u_abc_c = obj.motor.u_abc(1,:);

            for zz = 1:1:length(t_s)-1
                % compare the triangle signal (carrier) with the reference signal
                if u_abc_c(1,zz) > (carrier(zz)/500)
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
            i_abc_c = obj.motor.i_abc(1,:);

            % get the current values at the switching points
            for zz=1:1:length(t_s)-1

                if switching_times(zz) ~= 0
                    current_values(zz) = i_abc_c(1,zz);

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

            P_sw = (6*((1/length(t_s))*(sum(E_on)+sum(E_off))))*(1/obj.OP.T_el);

        end


        %% output function
        % switching loss
        % function P_sw = get.P_sw(obj)
        % 
        %     P_sw = 1;
        % end


        % loss
        % function P_loss = get.P_loss(obj) % W
        % 
        %     P_loss = 6*((obj.semiconductor.E_sum*obj.OP.f_sw)*(obj.OP.i_dq/obj.OP.i_max) +...
        %         (obj.semiconductor.U_ce*obj.OP.i_dq + obj.semiconductor.r_ce*(obj.OP.i_dq^2)));
        % end


        % conduction loss
        function P_conduction = get.P_conduction(obj) % W

            P_conduction = 3*obj.OP.i_dq^2*obj.semiconductor.R_ds_on;
        end

        % Mosfet loss calculation
        function P_loss = get.P_loss(obj) % W

            P_loss = obj.P_sw + obj.P_conduction;
        end


    end
end
