%% HVAC model
% input X: 
% X1) power solution Q
% X2) Initial temperature T0
% X3) Outdout Temperature Tout

% 
% output Y:
% 1) performance [0-1] pencentage of Ttoom stay above T base
% 2) Temperature Troom

function [Y] = HVAC(X)

X.Ton = xlsread('Ton.xlsx'); 
X.Tsn = xlsread('Tsn.xlsx');
X.Tnn = xlsread('Tnn.xlsx');

load b
% the predicted AC energy consumption %
Y = b(1)+b(2)*X.Ton.^3+b(3)*X.Tsn.^3+b(4)*X.Tnn.^3+b(5)*X.Ton.^2+b(6)*X.Tsn.^2+b(7)*X.Tnn.^2+b(8)*X.Ton+b(9)*X.Tsn+b(10)*X.Tnn;  
% model from Zhang Dong

end