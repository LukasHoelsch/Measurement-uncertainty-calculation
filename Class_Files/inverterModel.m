classdef inverterModel

    properties
        Semiconductor
        motor
        OP
    end

    properties (Dependent)

        P_sw    % W
        %P_cond  % W
        P_loss  % W
        n_steps
        


    end

    
    methods

        %% constructor
        function obj = inverterModel(Semiconductor,motor,OP)

            obj.Semiconductor = Semiconductor;
            obj.motor = motor;
            obj.OP = OP;
        end


        %% general functions

        % number of sampling points
        function n_steps = get.n_steps(obj)
            n_steps = obj.OP.T_el/obj.OP.t_sampling;
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

            for zz = 1:1:length(t_s)-1
                % compare the triangle signal (carrier) with the reference signal
                if obj.motor.u_abc(1,zz) > (carrier(zz)/500)
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
              
            % get the current values at the switching points
            for zz=2:1:length(t_s)-1
            
                if switching_times(zz) ~= 0
                    current_values(zz) = obj.motor.i_abc(1:zz);
                    
                end
            end



            for zz=2:1:length(t_s)-1

                if current_values(zz) ~= 0
                    if switching_times(zz) == 1
                        E_on(zz) = fit_E_on(current_values(zz));
                        
                    elseif switching_times(zz) == -1
                        E_off(zz) = fit_E_off(current_values(zz));
                        
                    end
                end
            end
            
            P_sw = (6*((1/length(t_s))*(sum(E_on)+sum(E_off))))*(1/T_el);

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
        %     P_loss = 6*((obj.Semiconductor.E_sum*obj.OP.f_sw)*(obj.OP.i_dq/obj.OP.i_max) +...
        %         (obj.Semiconductor.U_ce*obj.OP.i_dq + obj.Semiconductor.r_ce*(obj.OP.i_dq^2)));
        % end




        % Mosfet loss calculation
        function P_loss = get.P_loss(obj) % W

            P_loss = 1;
        end


    end
end
