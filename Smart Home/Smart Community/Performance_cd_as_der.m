    %%  Performance
    close all
    clc
    Qbest = final_trim(Qbest)
    %Qbest = load_curtail(Qbest1);
    global PV Wind Price WH_Load 
    global nc ndc B SOC_max SOC_min ESS_max ESS_Data
    % total_cost =
    N = (length(Qbest) - 24)/74;
    %plot(Qbest)
    clear EWH_P
    figure
    for i = 1:N
        EWH_P(i,:) = 100*Qbest(((i-1)*74 + 1):((i-1)*74 + 24));
        plot3(1:24,i*ones(1,24), EWH_P(i,:));
        hold on
    end
    xlabel('Timeslot','FontWeight','bold','FontSize',12,...
            'FontName','Times New Roman');
        ylabel('Smart Home i','FontWeight','bold','FontSize',12,...
            'FontName','Times New Roman');
        zlabel('Power(W)','FontWeight','bold','FontSize',12,...
            'FontName','Times New Roman');
        
%     plot(EWH_P')
%     title('EWH.Power')
   
    
    
    for i = 1:N
        plot3(1:24,i*ones(1,24),CalT(100*Qbest(((i-1)*74 + 1):((i-1)*74 + 24))) )
        hold on
    end
    %title('EWH.T')
    xlabel('Timeslot','FontWeight','bold','FontSize',12,...
            'FontName','Times New Roman');
        ylabel('Smart Home i','FontWeight','bold','FontSize',12,...
            'FontName','Times New Roman');
        s = sprintf('Temperature(%cF)', char(176)); zlabel(s)
        zlabel(s,'FontWeight','bold','FontSize',12,...
            'FontName','Times New Roman');
        
       

    for i = 1:N
        plot(-WH_Load(i,:)+Waterprovide(100*Qbest(((i-1)*74 + 1):((i-1)*74 + 24)),CalT(Qbest(((i-1)*74 + 1):((i-1)*74 + 24)))))
        hold on
    end
    xlabel('Timeslot','FontWeight','bold','FontSize',12,...
            'FontName','Times New Roman');
        ylabel('Abundant hot water(gallon)','FontWeight','bold','FontSize',12,...
            'FontName','Times New Roman');

   
    figure
    clear HVAC_P
    for i = 1:N

        HVAC_P(i,:) = 100*Qbest(((i-1)*74+25):((i-1)*74+48));
        plot3(1:24,i*ones(1,24),HVAC_P(i,:))
        hold on
    end
     %title('HVAC.Power')
     xlabel('Timeslot','FontWeight','bold','FontSize',12,...
            'FontName','Times New Roman');
        ylabel('Smart Home i','FontWeight','bold','FontSize',12,...
            'FontName','Times New Roman');
        zlabel('Power(W)','FontWeight','bold','FontSize',12,...
            'FontName','Times New Roman');
        
        

    for i = 1:N
        plot3(1:24,i*ones(1,24),CalT_HVAC(Qbest(((i-1)*74+25):((i-1)*74+48))));
        hold on
    end
    %title('HVAC.T')
xlabel('Timeslot','FontWeight','bold','FontSize',12,...
            'FontName','Times New Roman');
        ylabel('Smart Home i','FontWeight','bold','FontSize',12,...
            'FontName','Times New Roman');
        s = sprintf('Temperature(%cF)', char(176)); zlabel(s)
        zlabel(s,'FontWeight','bold','FontSize',12,...
            'FontName','Times New Roman');




    clear EV_P
    figure(3)
    for i = 1:N

        EV_P(i,:) = 3.3*Qbest(((i-1)*74 + 49):((i-1)*74 + 72) );
        plot3(1:24,i*ones(1,24),EV_P(i,:))
        hold on
    end
    %plot(EV_P')
    %title('EV.Power W')
     xlabel('Timeslot','FontWeight','bold','FontSize',12,...
            'FontName','Times New Roman');
        ylabel('Smart Home i','FontWeight','bold','FontSize',12,...
            'FontName','Times New Roman');
        zlabel('Power(kW)','FontWeight','bold','FontSize',12,...
            'FontName','Times New Roman');

    figure(6)
    for i = 1:N
        plot3(1:24,i*ones(1,24),EV_Data.SOC(i,2:end))
        hold on
    end
    %title('EV.SOC')
        xlabel('Timeslot','FontWeight','bold','FontSize',12,...
            'FontName','Times New Roman');
        ylabel('Smart Home i','FontWeight','bold','FontSize',12,...
            'FontName','Times New Roman');
        zlabel('EV SOC','FontWeight','bold','FontSize',12,...
            'FontName','Times New Roman');


    figure(4)

    for i = 1:N
        pc = zeros(24,1);
        slot =  Qbest(((i-1)*74 + 73))+ 11;

        if Qbest(((i-1)*74 + 74)) == 0
            pc(slot:(slot+2)) = [4;0.3;4];
        else if  Qbest(((i-1)*74 + 74)) == 1
            pc(slot:(slot+2)) = [4;4;0];
            end
        end
        plot3(1:24,i*ones(1,24),pc)
        hold on
    end
     xlabel('Timeslot','FontWeight','bold','FontSize',12,...
            'FontName','Times New Roman');
        ylabel('Smart Home i','FontWeight','bold','FontSize',12,...
            'FontName','Times New Roman');
        zlabel('CD Power(kW)','FontWeight','bold','FontSize',12,...
            'FontName','Times New Roman');
    
    
   % title('CD')% need to plot them paralel

    figure(5)
    subplot(2,1,1)
    bar(Qbest(((74*N+1):end),1),'FaceColor',[1 0 0],'EdgeColor',[1 0 0])
    title('ESS.Power','FontWeight','bold','FontSize',12,...
            'FontName','Times New Roman')
        ylabel('Power(kW)','FontWeight','bold','FontSize',12,...
            'FontName','Times New Roman');
    subplot(2,1,2)
    ESS_Data.Power = Qbest(((74*N+1):end),1);
    ESS_Data = ESS(ESS_Data);
    plot(ESS_Data.SOC,'LineWidth',2)
    title('ESS.SOC','FontWeight','bold','FontSize',12,...
            'FontName','Times New Roman')
 xlabel('Timeslot','FontWeight','bold','FontSize',12,...
            'FontName','Times New Roman');
    %figure(6)



    % real 24 power
    Power = zeros(24,1);
    for i = 1:N
        pc = zeros(24,1);
        slot =  Qbest(((i-1)*74 + 73))+ 11;

         if Qbest(((i-1)*74 + 74)) == 0
            pc(slot:(slot+2)) = [4;0.3;4];
        else if Qbest(((i-1)*74 + 74)) == 1
            pc(slot:(slot+2)) = [4;4;0];
            end
        end

        %                                                                                                        EV
        Power = Power + 0.1*Qbest(((i-1)*74 + 1):((i-1)*74 + 24))+0.1* Qbest(((i-1)*74 + 25):((i-1)*74 + 48))+ 3.3*Qbest(((i-1)*74 + 49):((i-1)*74 + 72))+ pc;
    end
    
%  remove renew

scload = Power;

    for i = 1:24

        Power(i) = max((Power(i)-PV(i)-Wind(i)),0);

    end

    
%     figure
%     plot(Power)
%     hold on
%     plot(PV)
%     plot(Wind)
%    % plot(Price)
%     xlabel('Timeslot')
%     ylabel('Power(kW)')
    % COST_CD_as_der(Qbest)
    % global C
    % C
    % s = sprintf('Temperature(%cF)', char(176)); zlabel(s)
    % xlabel('Timeslot')
    % ylabel('Smart Home i')
    % zlabel('Power(kW)')

Power_o = Power;% power of all smart home
 
% when ess discharge, power will remove
    Curtail = 0;

    for i = 1:24
          
        
          % discharge of ESS = min(Qbest(74*N+i),0)
          % dispatch power needed from grid = max((Power(i)-PV(i)-Wind(i)),0)
          
          % charge of ESS = max(Qbest(74*N+i),0)
          % excess renew = max(((PV(i)+Wind(i)) - Power(i)),0)
          % excess renew into ESS limit =  
          % 
          
          renew2ess(i) = min(max(((PV(i)+Wind(i)) - scload(i)),0),ESS_max);
          
          
           G2E(i) = max((Qbest(74*N+i)- renew2ess(i) ),0);
         % Power(i) = max((max((Power(i)-PV(i)-Wind(i)),0) +  min(Qbest(74*N+i),0)),0);% remove ess discharge part
            Power(i) = max((max((scload(i)-PV(i)-Wind(i)),0) +  G2E(i)),0);
          
           
           
            %Power(i) = Power(i) + G2E(i);
            if Power(i) > Pmax
                Power(i) = Pmax;

                %             Power_hour = X()
                %             Cut(Power)
                Curtail = Curtail + 100000;
            end
            
    end

  
    %
    %
    Y = Price*Power; % dollar
    
     
        axes1 = axes('Parent',figure);
        hold(axes1,'on');
        plot(scload,'LineWidth',2,'Parent',axes1)
        
        hold on
        plot(Power_o,'LineWidth',2,'Parent',axes1)
        plot(Power,'LineWidth',2,'Parent',axes1)
        plot(PV,'LineWidth',2,'Parent',axes1)
        plot(Wind,'LineWidth',2,'Parent',axes1)
         global Pmax
      % plot(Pmax*ones(1,24),'--r','LineWidth',2)
%      

        % Create multiple lines using matrix input to plot

        xlabel('Timeslot','FontWeight','bold','FontSize',12,...
            'FontName','Times New Roman');

        % Create ylabel
        ylabel('Power(kW)','FontWeight','bold','FontSize',12,...
            'FontName','Times New Roman');
        box(axes1,'on');
        set(axes1,'XTick',...
            [ 2  4 6  8  10  12 14  16 18  20  22  24]);
        legend('load','load-renew','Grid','PV','Wind','Location','NorthWest')%,'grid limit'
       %set(gca,  'Position',[.11 .18 .86 .78]);
       ylim([0 200])
       set(gcf,  'Position',[500 200 380 300]);
        
        Y
        Sum_Power = sum(Power)
        unit = Y/Sum_Power
        Average_EV_SOC = mean(EV_Data.SOC(:,end)')
        Leave_ESS = ESS_Data.SOC(end)
        
        PAPR = max(Power)^2/(rms(Power)^2)
        
figure
plot(Qbest1)
hold on
plot(Qbest)

plot(Qbest1-Qbest)