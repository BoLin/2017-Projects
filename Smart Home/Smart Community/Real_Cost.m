function [Y] = Real_Cost(X)
global N Price
 Power = zeros(24,1);%initialize total power
 
 

 
 
for i = 1:N
    
    
    
    
    S = zeros(1,48);
    S = X(((i-1)*120+74):((i-1)*120 + 120));
    
    S(X == 0) = 0;
    S(X == 1) = 0.3;
    S(X == 2) = 4;
    
    even = S(((i-1)*120+74):2:((i-1)*120 + 120));
    odd = S(((i-1)*120+73):2:((i-1)*120 + 120));
    %                         EWH                                  AC
    %                                                                                                     EV
    Power = Power + 0.1*X(((i-1)*120 + 1):((i-1)*120 + 24))+ X(((i-1)*120 + 25):((i-1)*120 + 48))+ 3.3*X(((i-1)*120 + 49):((i-1)*120 + 72))+ 0.5*(even + odd);
end




Power = Power + X((120*N+1):end);
%size(Power)

Y = Price*Power; % dollar
end
