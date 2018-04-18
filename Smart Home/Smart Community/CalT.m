function [ T ] = CalT(Q)
%calculating temperature using neural network 1
% should use real water usage



global Tinput Tamb WH_Load 
%global M c m hA
global Qd Wdd Tinputd Tambd Td % delay elements for NN training

Td1 = Td;

T = zeros(24,1);
for i=1:24
%     if i==1
%         %% Below is the NN model
%         % Input Q Wd Tinput Tamb
%         % Delay Q Wd Tinput Tamb T0
%        
%         Input = {[Q(i);Wd(i);Tinput;Tamb];[]};
%         Delay = {[Qd;Wdd;Tinputd;Tambd];[Td]};% all the delays
%         TT = EWH_D1(Input,Delay,{});
%         T(i) = cell2mat(TT(1));
%         
%     else
%        
        Input = {[Q(i);WH_Load(i);Tinput;Tamb];[]};
        Delay = {[Qd;Wdd;Tinputd;Tambd];[Td1]};% all the delays
        TT  = EWH_D1(Input,Delay,{});
        T(i) =  cell2mat(TT(1));
%     end
    
    %% update delayed unit
    Qd = Q(i);
    Wdd = WH_Load(i);
    Tinputd = Tinput;
    Tambd = Tamb;
    Td1 = T(i);
    
end

% T(i) =  1/(M*c + m*c+hA)*(m*c+3600*Q+hA*3600*Tamb - 3600*(m*c+hA)*T(i-1))+T(i-1)
% T = 1.8*T+32*ones(24,1);

end

