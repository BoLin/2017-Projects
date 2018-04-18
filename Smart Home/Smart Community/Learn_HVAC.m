%% HVAC Learn

%%%%%%%%%  Q=f(Ti,Ti+1,Touti)   %%%%%%%%%
% 
% 
% 
% To=xlsread('To.xlsx'); % outdoor temp %
% Ts=xlsread('Ts.xlsx'); % current temp setting %
% Q = xlsread('Q.xlsx'); % AC energy consumption %
% 
% Tn=xlsread('Tn.xlsx'); % temp setting for next hour %

clear all
load HVAC_train2
load Qsmooth
X = [Qsmooth To Ts]
Y = Tn
stairs(70*Q)
hold on 
stairs(Ts)
stairs(To)
stairs(Tn)


nntool
nnstart
nftool


plot(Ts)
hold on
plot(Tn)

Input = {[2000;61];[75]};
Delay = {[1500;61];[74]};% all the delays
TT = HVAC_4(Input,Delay,{});
cell2mat(TT(1))

clear TT
Input = {[1.2 71 71]};
TT = HVAC_5(Input,{},{});
cell2mat(TT(1))