% Determination_Counter.m
function [counter] = Determination_Counter(f_sample,f_switchingFrequency)

  

    number_of_periods = 40;
   

    T = number_of_periods*(1/f_switchingFrequency);
    t=0:1/f_sample:T-1/f_sample;
    counter = sawtooth(2*pi*f_switchingFrequency*t,0.5);
end