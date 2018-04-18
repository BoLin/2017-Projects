%% EWH Model

% input X: 
% X1) power solution Q
% X2) inlet temperature Tinput
% X3) ambient temperature Tamb
% X4) waterflow m (demand)
% X5) tank previous temperature T0
% 
% output Y:
% 1) performance [0-1] pencentage of Ttemp stay above T base
% 2) tank temperature Ttank

function [Y] = EWH(X)

global dayn M hA c

Q = X(1,1);
Tinput = (X(1,2)-32)/1.8;
Tamb = (X(1,3)-32)/1.8;
T0 = (X(1,5)-32)/1.8;
A = X(1,4:5);



Temp = zeros(24,1);% temp Ttank

for hour=1:24% C not F
      if hour == 1
        
       Temp(hour)= d2m(A)*Tinput/M + 3600*hA*Tamb/(M*c) + 3600*Q/(M*c) + T0*(M*c-d2m(A)-3600*hA)/M*c;
      else
          
       Temp(hour)= d2m(A)*Tinput/M + 3600*hA*Tamb/(M*c) + 3600*Q/(M*c) + Temp(hour-1)*(M*c-d2m(A)-3600*hA)/M*c;
      end
end

Temp = 1.8*Temp+32*ones(24,1);

P =  ;%performance

Y = {Temp,P};

end

function [B] = d2m(A)
% A = [wd, T0]
B = 227.4*A(1)/(1.8*A(2)-18)
end