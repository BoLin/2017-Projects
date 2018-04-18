N=20
INI_SET
Price = Price_raw; % different DAP    
    Optimization_CD_as_der  % Line 6
    
   % Qbest = Qbest(:,1);
    
    c = clock;
    filename = sprintf('%d-%d',c(1:5),N)
    filename = strcat(filename,'.mat')
    save(filename,'Qbest')
    

    
    INI_SET
    global EV_SOCmax EV_SOCmin EV_SOC_final EV_Data EV_Capacity
    EV_Initial = 0.6;% EV Initial SOC
    %Initial EV Structure
    EV_Data = struct('SOC',EV_Initial*ones(N,25),'Power',zeros(N,24), 'Err',zeros(N,1));
    
    Optimization_CD_as_der  % Line 6
    
   % Qbest = Qbest(:,1);
    
    c = clock;
    filename = sprintf('%d-%d',c(1:5),N)
    filename = strcat(filename,'.mat')
    save(filename,'Qbest')
    
    INI_SET
 global nc ndc B SOC_max SOC_min ESS_max ESS_Data
  SOC_0 = 0.8; 
  ESS_Data = struct('SOC',SOC_0*ones(1,25),'Power',zeros(1,24), 'Err',0);
    Optimization_CD_as_der  % Line 6
    
   % Qbest = Qbest(:,1);
    
    c = clock;
    filename = sprintf('%d-%d',c(1:5),N)
    filename = strcat(filename,'.mat')
    save(filename,'Qbest')
    
    
   
     figure(5)
    subplot(3,1,1)
    bar(Qbest(((74*N+1):end),1),'FaceColor',[1 0 0],'EdgeColor',[1 0 0])
    title('ESS.Power','FontWeight','bold','FontSize',12,...
            'FontName','Times New Roman')
        ylabel('Power(kW)','FontWeight','bold','FontSize',12,...
            'FontName','Times New Roman');
    subplot(3,1,2)
    ESS_Data.Power = Qbest(((74*N+1):end),1);
    ESS_Data = ESS(ESS_Data);
    plot(ESS_Data.SOC,'LineWidth',2)
    title('ESS.SOC','FontWeight','bold','FontSize',12,...
            'FontName','Times New Roman')
 xlabel('Timeslot','FontWeight','bold','FontSize',12,...
            'FontName','Times New Roman');
    %figure(6)
   subplot(3,1,3)
    stairs(Price,'LineWidth',2)
    title('Electricity Price','FontWeight','bold','FontSize',12,...
            'FontName','Times New Roman')
        ylabel('$/kWh','FontWeight','bold','FontSize',12,...
            'FontName','Times New Roman');
    