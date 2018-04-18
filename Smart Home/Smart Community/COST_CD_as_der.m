    %% Cost function


    % for each house ? no, over all optimization
    function [ Y ] = COST_CD_as_der(X)

     global Prior N Pmax Price
     global WH_Load PV Wind
     global C ESS_max
     
     % the sequence of X WH  AC EV CD ESS
    %house 1 to N
    % size of power [1 X (N+1)*74]
   
    Power = zeros(24,1);%initialize total power
    G2E = zeros(24,1); % initialize grid to ess power

    for i = 1:N
        pc = zeros(24,1);
        slot =  X(((i-1)*74 + 73))+ 11;

        if X(((i-1)*74 + 74)) == 0
            pc(slot:(slot+2)) = [4;0.3;4];
        else
            pc(slot:(slot+2)) = [4;4;0];
        end

        %                                                                                                        EV
        Power = Power + 0.1*X(((i-1)*74 + 1):((i-1)*74 + 24))+0.1* X(((i-1)*74 + 25):((i-1)*74 + 48))+ 3.3*X(((i-1)*74 + 49):((i-1)*74 + 72))+ pc;
    end
    
%  remove renew

load = Power;

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
    % COST_CD_as_der(X)
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
          
        
          % discharge of ESS = min(X(74*N+i),0)
          % dispatch power needed from grid = max((Power(i)-PV(i)-Wind(i)),0)
          
          % charge of ESS = max(X(74*N+i),0)
          % excess renew = max(((PV(i)+Wind(i)) - Power(i)),0)
          % excess renew into ESS limit =  
          % 
          
          renew2ess(i) = min(max(((PV(i)+Wind(i)) - load(i)),0),ESS_max);
          
          
           G2E(i) = max((X(74*N+i)- renew2ess(i) ),0);
         % Power(i) = max((max((Power(i)-PV(i)-Wind(i)),0) +  min(X(74*N+i),0)),0);% remove ess discharge part
            Power(i) = max((max((load(i)-PV(i)-Wind(i)),0) +  G2E(i)),0);
          
           
           
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


    %% Initial Constraint
    C = zeros(N+1,4);
   

    for i = 1: N

        %% 1  EWH Constraint
          
        EWH_weight = 1;
        
        CEWH = WH_Load(i,:)-Waterprovide(100*X(((i-1)*74 + 1):((i-1)*74 + 24)),CalT(X(((i-1)*74 + 1):((i-1)*74 + 24)))) <=0;%wd<=wp
        if CEWH
            C(i,1) = 0;
        else
           C(i,1) = EWH_weight * Prior(i,1);
        end



        %% 2 AC Constraint
        
        global HVAC_high HVAC_low 
        
        T_h = CalT_HVAC(X(((i-1)*74+25):((i-1)*74+48)));
        
        C(i,2) = sum(T_h>HVAC_high)+0.5* sum(T_h<HVAC_low);



        %% 3 CD COnstraint
%         CD_weight = 100;
% 
%         C(i,3) = CD_weight*Prior(i,3)* CD(X(((i-1)*74 + 73):((i-1)*74 + 74)));

    end




    %% 4 EV Constriant
    global EV_Data
    for i = 1:N
        EV_Data.Power(i,:) =  3.3*X(((i-1)*74 + 49):((i-1)*74 + 72));
    end
    EV_Data = EV(EV_Data);

    EV_weight = 1;% the importance of not breaking soc
   C(1:N,4) = Prior(1:N,4).* EV_Data.Err*EV_weight;
   
   % EV constraints about staying home should be added



    %% ESS Constriant
    global ESS_Data
    ESS_Data.Power = X(74*N +1:end);
    ESS_Data = ESS(ESS_Data);

   ESS_weight = 1;% the importance of not breaking SOC    
    
        C(N+1,1) = ESS_weight*ESS_Data.Err;
    


    %% Constraints Sum up
    Csum = sum(sum(C))+ Curtail;
    Y = -Y - Csum * 1000;

    end