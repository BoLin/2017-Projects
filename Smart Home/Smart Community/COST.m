    %% Cost function


    % for each house ? no, over all optimization
    function [ Y ] = COST(X)

     global Prior N Pmax Price
     global Wd  WH_Load
     global C
     
     % the sequence of X WH  AC EV CD ESS
    %house 1 to N
    % size of power [1 X (N+1)*120]
   
    Power = zeros(24,1);%initialize total power


    %% calculate total cost from all residents
    for i = 1:N
        S = zeros(1,48);
        S = X(((i-1)*120+74):((i-1)*120 + 120));
        S(X == 0) = 0;
        S(X == 1) = 0.300;
        S(X == 2) = 3.700;
        S(X == 3) = 4.000;
        even = S(((i-1)*120+74):2:((i-1)*120 + 120));
        odd = S(((i-1)*120+73):2:((i-1)*120 + 120));
      
        %                         EWH                                  AC
        %                                                                                                        EV
        Power = Power + 0.1*X(((i-1)*120 + 1):((i-1)*120 + 24))+ X(((i-1)*120 + 25):((i-1)*120 + 48))+ 3.3*X(((i-1)*120 + 49):((i-1)*120 + 72))+ 0.5*(even + odd);
    end

    Power = Power + X((120*N+1):end);
    %size(Power)
   
    Y = Price*Power; % dollar 


    %% Initial Constraint
    C = zeros(N+1,4);
   

    for i = 1: N

        %% 1  EWH Constraint
          

        Wd = WH_Load(i,:);
        CEWH = WH_Load(i,:)-Waterprovide(X(((i-1)*120 + 1):((i-1)*120 + 24)),CalT(X(((i-1)*120 + 1):((i-1)*120 + 24)))) <=0;%wd<=wp
        if CEWH
            C(i,1) = 0;
        else
           C(i,1) = Prior(i,1);
        end



        %% 2 AC Constraint
        
        global HVAC_high HVAC_low 
        
        T_h = CalT_HVAC(2000*X(((i-1)*120+25):((i-1)*120+48)));
        
        C(i,2) = sum(T_h>HVAC_high)+0.5* sum(T_h<HVAC_low);



        %% 3 CD COnstraint
        CD_weight = 100;

        C(i,3) = CD_weight*Prior(i,3)* CD(X(((i-1)*120 + 73):((i-1)*120 + 120)));

    end




    %% 4 EV Constriant
    global EV_Data
    for i = 1:N
        EV_Data.Power(i,:) =  3.3*X(((i-1)*120 + 49):((i-1)*120 + 72));
    end
    EV_Data = EV(EV_Data);

    EV_weight = 100;% the importance of not breaking soc
   C(1:N,4) = Prior(1:N,4).* EV_Data.Err*EV_weight;
   
   % EV constraints about staying home should be added



    %% ESS Constriant
    global ESS_Data
    ESS_Data.Power = X(120*N +1:end);
    ESS_Data = ESS(ESS_Data);

   ESS_weight = 100;% the importance of not breaking SOC    
    if ESS_Data.Err == 1
        C(N+1,1) = ESS_weight;
    end



    %% Constraints Sum up
    Csum = sum(sum(C));
    Y = -Y - Csum * 1000;

    end