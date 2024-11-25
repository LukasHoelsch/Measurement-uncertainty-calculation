%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% MTPC_LPV.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [i_d_MTPC,i_q_MTPC] = MTPC_LPV(fit_Torque,i_max)


% fixed
dr=10; % 5
dphi=0.2; % 0.1

% create vector
r_vec=0:dr:i_max;
dphi=pi/2:pi/180*dphi:3/2*pi;


minTPC_meas=zeros(2,length(r_vec));
maxTPC_meas=zeros(2,length(r_vec));

for ii=1:1:length(r_vec)
    i_d=r_vec(ii)*cos(dphi);
    i_q=r_vec(ii)*sin(dphi);
    %Trq_meas = Trq_Map(i_d,i_q);
    Trq_meas = Trq_Map(fit_Torque,i_d,i_q);
    
    [~,idx_min]=min(Trq_meas);
    [~,idx_max]=max(Trq_meas);
    minTPC_meas(1:2,ii)=[i_d(idx_min);i_q(idx_min)];
    maxTPC_meas(1:2,ii)=[i_d(idx_max);i_q(idx_max)];
end

i_d_MTPC=[flip(minTPC_meas(1,:)),maxTPC_meas(1,:)];
i_q_MTPC=[flip(minTPC_meas(2,:)),maxTPC_meas(2,:)];