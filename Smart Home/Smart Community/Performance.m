%%  Performance 
close all
clc
 total_cost = Real_Cost(Qbest)

%plot(Qbest)
figure(1)
for i = 1:N
    EWH_P(i,:) = 100*Qbest(((i-1)*120 + 1):((i-1)*120 + 24));
        
end
subplot(2,1,1)
plot(EWH_P')
title('EWH.Power')
subplot(2,1,2)
hold on
for i = 1:N
plot(CalT(100*Qbest(((i-1)*120 + 1):((i-1)*120 + 24))) )
end
title('EWH.T')


for i = 1:N

    HVAC_P(i,:) = 2000*Qbest(((i-1)*120+25):((i-1)*120+48));
    
end

figure(2)

subplot(2,1,1)
plot(HVAC_P')
title('HVAC.Power')
subplot(2,1,2)
hold on
for i = 1:N
 plot(CalT_HVAC(Qbest(((i-1)*120+25):((i-1)*120+48))));
end
title('HVAC.T')

for i = 1:N

    EV_P(i,:) = 3300*Qbest(((i-1)*120 + 49):((i-1)*120 + 72));
    
end


figure(3)
subplot(2,1,1)
plot(EV_P')
title('EV.Power W')
subplot(2,1,2)
hold on
for i = 1:N
EV_Data.Power(i,:) = 3.3*Qbest(((i-1)*120 + 49):((i-1)*120 + 72))';

end
EV_Data = EV(EV_Data)
plot(EV_Data.SOC(:,2:end)')
title('EV.SOC')

for i = 1:N
    S = zeros(48,1);    
    SS = Qbest(((i-1)*120 + 73):((i-1)*120 + 120));
    S(SS == 0) = 0;
    S(SS == 1) = 300;
    S(SS == 2) = 4000;
    CD_P(i,:) = S;
    
end
figure(4)
plot(CD_P')
title('CD')
for i = 1:N
CD_ERROR(i) = CD(Qbest(((i-1)*120 + 73):((i-1)*120 + 120)))
end


figure(5)
subplot(2,1,1)
plot(1000*Qbest((120*N+1):end)')
title('ESS.Power W')
subplot(2,1,2)
ESS_Data.Power = Qbest((120*N+1):end);
ESS_Data = ESS(ESS_Data)
plot(ESS_Data.SOC)
title('ESS.SOC')

%figure(6)


