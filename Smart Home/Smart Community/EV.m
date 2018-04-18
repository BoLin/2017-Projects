    %% Electric Vehicle
    function [X] = EV(X)
    %  SOC: [5x24 double]
    %  Power: [5x24 double]
    %  Err: [5x1 double]
    global EV_SOCmax EV_SOCmin EV_Capacity EV_SOC_final N

    X.Err = zeros(N,1);

    for i = 1:24

       X.SOC(:,i+1) = X.SOC(:,i) + (1/EV_Capacity)*X.Power(:,i); 

       %% method 1
    %    for j = 1:N
    %    
    %    if (X.SOC(j,i+1) >= EV_SOCmax) || (X.SOC(j,i+1) <= EV_SOCmin)% now EV wont discharge
    %        X.Err(j) = X.Err(j)+1;
    %    end
    %    end

       %% interior penalty? no
       for j = 1:N

           if  X.SOC(j,i+1)> EV_SOCmax 
%                  X.Err(j) = X.Err(j)+ 1/(EV_SOCmax - X.SOC(j,i+1))^4;
                 X.Power(j,i:end)=0*X.Power(j,i:end);% trim here
                
%            else% over charge
%                   X.Err(j) = X.Err(j)+ (X.SOC(j,i+1) - EV_SOCmax)^4;
           end
       end

    end
    for i  = 1:24
    X.SOC(:,i+1) = X.SOC(:,i) + (1/EV_Capacity)*X.Power(:,i); 
    end

    % for i = 1:N
    %     if max(X.SOC(i,:)) >= EV_SOCmax || min(X.SOC(i,:)) <= EV_SOCmin
    %         X.Err(i) = 100;
    %     else
    %         X.Err(i) = 0;
    %     end
    %     
    % end

    for i = 1:N
        if X.SOC(i,end) <= EV_SOC_final|| max(X.SOC(i,:))> EV_SOCmax
            X.Err(i) = 10000;
        end


    end
    end