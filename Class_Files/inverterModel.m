classdef inverterModel

    properties
        Semiconductor
        OP
    end

    properties (Dependent)

        P_loss % W

    end

    
    methods

        %% constructor
        function obj = inverterModel(Semiconductor,OP)

            obj.Semiconductor = Semiconductor;
            obj.OP = OP;
        end

        %% output function

        % loss calculation
        function P_loss = get.P_loss(obj) % W

            P_loss = 6*((obj.Semiconductor.E_sum*obj.Semiconductor.f_sw)*(obj.OP.i_dq/obj.OP.i_max) +...
                (obj.Semiconductor.U_ce*obj.OP.i_dq + obj.Semiconductor.r_ce*(obj.OP.i_dq^2)));
        end




        % Mosfet loss calculation
        % function P_loss = get.P_loss(obj) % W
        % 
        %     P_loss = 
        % end


    end
end