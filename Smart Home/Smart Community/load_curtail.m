    %% trim ga output
    function [under] = load_curtail(over)
    global SOC_max SOC_min ESS_Data  Pmax Prior PV Wind
    global nc ndc B SOC_max SOC_min ESS_max ESS_Data Power1
    
    N = (length(over)-24)/74;

    Power = zeros(24,1);
    for i = 1:N
        pc = zeros(24,1);
        slot =  over(((i-1)*74 + 73))+ 11;

        if over(((i-1)*74 + 74)) == 0
            pc(slot:(slot+2)) = [4;0.3;4];
        else if over(((i-1)*74 + 74)) == 1
            pc(slot:(slot+2)) = [4;4;0];
            end
        end

        %                                                                                                        EV
        Power = Power + 0.1*over(((i-1)*74 + 1):((i-1)*74 + 24))+0.1* over(((i-1)*74 + 25):((i-1)*74 + 48))+ 3.3*over(((i-1)*74 + 49):((i-1)*74 + 72))+ pc;
    end

    %  remove renew

    scload = Power;

    for i = 1:24

        Power(i) = max((Power(i)-PV(i)-Wind(i)),0);

    end
    
    raw_power = Power;


    %     figure
    %     plot(Power)
    %     hold on
    %     plot(PV)
    %     plot(Wind)
    %    % plot(Price)
    %     xlabel('Timeslot')
    %     ylabel('Power(kW)')
    % COST_CD_as_der(over)
    % global C
    % C
    % s = sprintf('Temperature(%cF)', char(176)); zlabel(s)
    % xlabel('Timeslot')
    % ylabel('Smart Home i')
    % zlabel('Power(kW)')

   

   

    for i = 1:24


        % discharge of ESS = min(over(74*N+i),0)
        % dispatch power needed from grid = max((Power(i)-PV(i)-Wind(i)),0)

        % charge of ESS = max(over(74*N+i),0)
        % excess renew = max(((PV(i)+Wind(i)) - Power(i)),0)
        % excess renew into ESS limit =
        %

        renew2ess(i) = min(max(((PV(i)+Wind(i)) - scload(i)),0),ESS_max);


        G2E(i) = max((over(74*N+i)- renew2ess(i) ),0);
        % Power(i) = max((max((Power(i)-PV(i)-Wind(i)),0) +  min(over(74*N+i),0)),0);% remove ess discharge part
        Power(i) = max((max((scload(i)-PV(i)-Wind(i)),0) +  G2E(i)),0);


    end
    
    
    for i = 1:24
        i
        load Prior
        while Power(i) > Pmax && max(max(Prior))>=1
           off =  find(Prior==1) ;% [16 17 18 19 20]
           CP = 0;
           for j = 1:N
                a = rem(off(j),N);
                if a == 0
                a = N;
                end
               b = ceil(off(j)/N); %type 1 2 3 4  WH AC CD EV
               
               switch b
                   case 1
                       tempp = 0.1*over((a-1)*74+i); %EWH
                       ewh=(a-1)*74+i
                       over((a-1)*74+i) = 0;
                   case 2
                       tempp = 0.1*over((a-1)*74+24+i);%HVAC
                       hvac=(a-1)*74+24+i
                       over((a-1)*74+24+i) = 0;
                   case 4
                       tempp = 3.3*over((a-1)*74+48+i);%EV
                       ev=(a-1)*74+48+i
                       over((a-1)*74+48+i) = 0;
                   case 3
                       pc = zeros(24,1);
                       slot =  over(((a-1)*74 + 73))+ 11;
                       if over(((a-1)*74 + 74)) == 0
                           pc(slot:(slot+2)) = [4;0.3;4];
                       else if over(((a-1)*74 + 74)) == 1
                               pc(slot:(slot+2)) = [4;4;0];
                           end
                       end
                       tempp = pc(i);
                       if pc(i)>0
                           over(((a-1)*74 + 74)) = 2;% cancel CD
                       end
               end
              
               
               CP = CP + tempp;% curtail power
               
           end           
            
           CP
           Power(i) = Power(i) - CP;
           Prior = Prior - ones(size(Prior));
        end 
    end
    Power1 = Power
    plot(raw_power-Power)
 
  under = over;
    end