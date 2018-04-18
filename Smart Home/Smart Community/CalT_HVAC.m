function [ T ] = CalT_HVAC(QH)
%calculating temperature using neural network 1
% should use real water usage

load HVAC_train1 
%global Qd Wdd Tinputd Tambd Td 
global Qdd Tod  Tnd To To1 Ts1



T = zeros(24,1);
% Qdd = 1;
% Tod = 70;
% %Tsd = 70;
% Tnd = 71;

for i=1:24
           
    %% Below is the NN model
    % Input Q Wd Tinput Tamb
    % Delay Q Wd Tinput Tamb T0
    
    % input Q To Ts
    % output Tn T0
    
%     Input = {[Q(i);To1(i)];[]};
%     Delay = {[Qdd;Tod];[Tnd]};% all the delays
%     TT = HVAC_4(Input,Delay,{});
%     T(i) = cell2mat(TT(1));
 
    Input = {[QH(i)/10 To1(i) Ts1(i)]};
   
    TT = HVAC_5(Input,{},{});
    T(i) = cell2mat(TT(1));
    
    %% update delayed unit
%     Qdd = Q(i);
%     Tod = To(i);
%     Tnd = T(i);
    
end

% plot(QH)
% hold on
% plot(To1)
% plot(Ts1)

end

