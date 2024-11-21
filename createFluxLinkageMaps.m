% createFluxLinkageMaps.m
%%%%%%%%%%%%%%%
% Function to create the flux linkage maps with given parameters in the data sheet.


%%
i_min = 0; % A
i_max = 25; % A

i_steps = i_min:5:i_max;

psi_d = L_d * i_steps;
psi_q = L_q * i_steps;
