% MTPC_LPV_hoelsch.m
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



 











% prob = optimproblem("ObjectiveSense","minimize");
% 
% i_d = optimvar('i_d',1,1,'LowerBound',-i_max);
% i_q = optimvar('i_q',1,1,'UpperBound',i_max);
% 
% prob.Objective = i_d^2 + i_q^2; 
% 
% 
% i_q = (T+(3/2)*p*fit_Psi_q(i_d,i_q)*i_q)/((3/2)*p*fit_Psi_d(i_d,i_q));
% 
% %i_q = T+(3/2)*p;
% 
% cons1 = i_d + i_q <= i_max;
% 
% prob.Constraints.cons1 = cons1;
% 
% 
% show(prob)
% 
% solve(prob)