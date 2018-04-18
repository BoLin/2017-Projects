%% Cloth Dryer

%The power consumption of a typical clothes dryer includes the motor part and the heating coils.
%http://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=6217295

function [Y] = CD(X)

% Power: [1x48 double]
% Err: [1x1 double]
global Ton Ph Pm


% X.Power(X.Power = Pm) = 1;
% X.Power(X.Power = Ph) = 2;
S = zeros(1,48);
S(X == 0) = 0;
S(X == 1) = 300;
S(X == 2) = 4000;




   
    if sum(S) >0
        SS = find(S>0);
    S_distance = SS(end)-SS(1)+1;
    else
        S_distance = 48;% if X = [0 0 ... 0]
    end
    
    if ((sum(S)>= 3*1000*(Ph + Pm)) && (sum(S)<= 1000*(3*(Ph + Pm)+ Pm) )&& (S_distance <= 4))
        Y = 0;
    else
        Y = 1;
    end
end


% % Power: [5x48 double]
% % Err: [5x1 double]
% global Ton Ph Pm
% 
% 
% % X.Power(X.Power = Pm) = 1;
% % X.Power(X.Power = Ph) = 2;
% for i = 1:5
%     S = find(X.Power);
%     S_distance = S(end)-S(1);
%     
%     if sum(X.Power(i,:))>= 3*(Ph + Pm) || sum(X.Power(i,:))<= 3*(Ph + Pm)+ Pm || S_distance <= 4
%         Y.Err(i) = 0;
%     else
%         Y.Err(i) = 1;
%     end
% end

