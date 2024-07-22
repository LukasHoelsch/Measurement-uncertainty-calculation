% ML60B_spec.m
%%%%%%%%%%%%%%%
% Specifications for the Hottinger Bruel & Kjaer ML60B amplifier

% Input parameter
ML60B.d_amplifier = 0;          % % It is no value in the data sheet given 
ML60B.delta_theta = 7;          % K
ML60B.d_theta = 0.00008;        %       % DS
ML60B.temperature = 'no';       % only 'yes' or 'no' possible
                                % This parameter describes the temperture 
                                % influence on the uncertainty
%
% Output
% u_T2      % Nm