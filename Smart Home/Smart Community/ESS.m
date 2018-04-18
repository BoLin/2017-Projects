%% ESS energy storage system

function [X] = ESS(X)

global nc ndc B SOC_max SOC_min
% SOC X1) 24 hour SOC
% Power X2) 24 hour Charge/Discharge Power W
% Err   X3) Error

% SOC: [1x24 double]
% Power: [1x24 double]
% Err: [1 double]
X.Err = 0;

%% Update SOC
for i = 1:24
if X.Power(i) > 0
    n = nc;
else
    n = 1/ndc;
end

    X.SOC(i+1) =  (X.SOC(i) * B + (n * X.Power(i)))/B;
    
    if X.SOC(i+1)< SOC_min || X.SOC(i+1)> SOC_max
        X.Err = X.Err + 1;
    end
end
    %X.SOC(1) = X.SOC(end); % save the last one to the first one

% %% Check SOC Status
% if min(X.SOC)< SOC_min || max(X.SOC)> SOC_max
%     X.Err = 1;
% else
%     X.Err = 0;   
    
end