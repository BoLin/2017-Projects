%% trim ga output
function [GA] = final_trim(GA)
global SOC_max SOC_min ESS_Data
N = (length(GA)-24)/74;


%ESS_trim = GA((length(GA)-24):end);
ESS_Data.Power = GA((length(GA)-23):end)';
error = 0;
for i = 1:24
    if ESS_Data.SOC(i+1)> SOC_max
        break
    else
        error = error + 1;
    end
end

GA((length(GA)-24+error):end) = 0*GA((length(GA)-24+error):end);



  global EV_Data
    for i = 1:N
        EV_Data.Power(i,:) = 3.3* GA(((i-1)*74 + 49):((i-1)*74 + 72))';
    end
EV_Data = EV(EV_Data);




for i = 1:N
   GA(74*(i-1)+49:74*(i-1)+72) = 1/3.3*EV_Data.Power(i,:)';
   
end

end