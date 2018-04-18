%% Calculate cost using Qbest
function [ Y ] = CalP(X)
global N Price
 Power = zeros(24,1);%initialize total power


    %% calculate total cost from all residents
    for i = 1:N
        
        even = X(((i-1)*120+74):2:((i-1)*120 + 120));
        odd = X(((i-1)*120+73):2:((i-1)*120 + 120));

        %                         EWH                                  AC
        %                                                                                         EV
        Power = Power + X(((i-1)*120 + 1):((i-1)*120 + 24))+ 1000*X(((i-1)*120 + 25):((i-1)*120 + 48))+ X(((i-1)*120 + 49):((i-1)*120 + 72))+ 0.5*(even + odd);
    end

    Power = Power + X((120*N+1):end);
    %size(Power)
   
    Y = Price*Power/1000; % dollar 






end