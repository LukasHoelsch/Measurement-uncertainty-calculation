% preallocation.m
% preallocation to save compuataion time

function [n_op,i_d,i_q,i_dq,motor_T_calc,end_calculation] = ...
    preallocation(n_samplingPoints,i_d_MTPC)

    size_n = length(n_samplingPoints);
    size_i_d = length(i_d_MTPC);

    % preallocation
    n_op = zeros(size_i_d,size_n);
    i_d = zeros(size_i_d*size_n,1);
    i_q = zeros(size_i_d*size_n,1);
    i_dq = zeros(size_i_d*size_n,1);
    motor_T_calc = zeros(size_i_d*size_n,1);
    end_calculation = zeros(size_i_d*size_n,1);

end