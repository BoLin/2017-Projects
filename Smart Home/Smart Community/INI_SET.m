    %% Initial File

    %% Simulation Setup

    % Starting from 8 am to the next day's 8 am
    % Simulation time 24 hours
    % 8:00 8:30 9:00 9:30 10:00 10:30 11:00 11:30 12:00 12:30 13:00 13:30 14:00 14:30 15:00 15:30 16:00 16:30 17:00 17:30 18:00 18:30 19:00 19:30 20:00  20:30 21:00 21:30 22:00 22:30 23:00 23:30 24:00 00:30 1:00 1:30 2:00 2:30 3:00 3:30 4:00 4:30 5:00 5:30 6:00 6:30 7:00 7:30
    % 1    2    3    4    5     6     7     8     9     10    11    12    13    14    15    16    17    18    19    20    21    22    23    24    25     26    27    28    29    30    31    32    33    34    35   36   37   38   39   40   41   42   43   44   45   46   47   48
    %% Resident Number
    global N Prior Pmax Price
    %N = 5;
    %N = (length(Qbest) - 24)/74; 
    %% Overall Load Curtail Condition
    Pmax = 80;% kW

    %% Ambient Temperature
    

    %% Electricity Price
    Price_raw =[0.02303 0.02178 0.02063 0.02014 0.02146 0.02451 0.02576 0.02817 0.03128 0.03619 0.04001 0.0432 0.04815 0.05429 0.05822 0.0615 0.05765 0.04944 0.04503 0.0424 0.03891 0.03088 0.02733 0.02478 ];
    Price = [Price_raw(8:24) Price_raw(1:7)];
    
    %% Load Priority
    load prior
    %each house can set a load priority, it can be different
    %  WH AC CD EV 1 2 3 4 represent the weight
    %Prior = ones(N,4);
%     Prior = [4 3 2 1;4 2 3 1;3 2 4 1; 2 4 3 1;3 4 2 1];
    %% Prior Generate Code
%     iMin = 0; iMax = 4;numToTake = 4; % Must be less than iMax - iMin
%     % Get (iMax-iMin) numbers between iMin and iMax
%     for i = 1:N
%     Prior(i,:) = randperm(iMax-iMin) + iMin;
%     end

    %% Cloth Dryer

    %The power consumption of a typical clothes dryer includes the motor part and the heating coils.
    %http://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=6217295
    global Ton Ph Pm

    Ton = 1.5;% required turned on time

    Ph = 3.7; %CD heating rated power kW
    Pm = 0.3; %CD motor rated power

    %CD_Data = struct('Power',zeros(N,48), 'Err' ,zeros(N,1));
    %% HVAC
    global Qdd Tod Tsd Tnd % these should be initialized
    global HVAC_high HVAC_low HVAC_max
    global To1 Ts1
    To=xlsread('To.xlsx'); % outdoor temp %
    Ts=xlsread('Ts.xlsx'); % current temp setting %
    Tn=xlsread('Tn.xlsx'); % temp setting for next hour %

    To1 = To(8:31);
    Ts1 = Ts(8:31);
    
    load HVAC_train1 % this can be changed  
    HVAC_high = 79; %F
    HVAC_low = 71; % comfort temperature range
    HVAC_max = 7;
    Qdd = 1;% initial HVAC power
    Tod = 70;
    Tsd = 70;
    Tnd = 71;
    

    %% Water Heater

    global WH_Load
    global Qd Wdd Tinputd Tambd Td % delay elements for NN training
    global Tinput Tamb
    global V
    Qd = 2000;
    Tinputd = 50;
    Wdd = 2;
    Tambd = 50;
    Td = 110;
          

    Pwater = 4.5;%
    Tbase = 110; % minimum acceptance temperature
    Tinput = 50; % inlet cold water, not ambient temperature
    Tamb = 50;
    %tank parameters
    V=50;%volumne 50 gallon
    M=V*0.00378541*1000;
    c=4.186/0.001;% specific heat of water 4.18 j/gC
    hA=20;

    L=[1 0.7 0.8 1.8 5.6 12 14.3 11.2 10.7 9.8 8.9 8 7.2 6.7 6.8 8 9.8 10.9 11 9.8 8.1 5.3 3 1.6];%AHC solar city sample
    G= [L(8:24) L(1:7)]/3.78541; % in Gallon
    WD_Load_Demo = G;
    WH_Load = ones(N,1)*WD_Load_Demo; % 24 water demand for all families
    
    %% Electric Vehicle
   
    global EV_SOCmax EV_SOCmin EV_SOC_final EV_Data EV_Capacity
    EV_Capacity = 60; % set all EV Capacity kWh
    EV_Charge = 6.6; % two charging power kW, 3.3 or 6.6 https://evobsession.com/electric-car-charging-101-types-of-charging-apps-more/
    EV_Arrive = 21;
    EV_Leave = 48; % EV charging available time
    %EV_slot = - EV_Arrive + EV_Leave;
    EV_SOCmax = 0.95;
    EV_SOCmin = 0.35;
    EV_SOC_final = 0.9;

    EV_Initial = 0.35;% EV Initial SOC
    %Initial EV Structure
    EV_Data = struct('SOC',EV_Initial*ones(N,25),'Power',zeros(N,24), 'Err',zeros(N,1));

    %% ESS
    global nc ndc B SOC_max SOC_min ESS_max ESS_Data
    nc =  0.95;% charg efficiency   http://ieeexplore.ieee.org/stamp/stamp.jsp?arnumber=5657267
    ndc = 0.90;% discharge efficiency  http://ieeexplore.ieee.org/stamp/stamp.jsp?arnumber=6253991

    B = 100; % SOC capacity (kWh)
    SOC_0 = 0.35; %initial SOC http://ieeexplore.ieee.org/stamp/stamp.jsp?arnumber=6253991
    SOC_max = 0.95;
    SOC_min = 0.30;
    ESS_max = 10; % kw
    %Initial EV Structure
    ESS_Data = struct('SOC',SOC_0*ones(1,25),'Power',zeros(1,24), 'Err',0);
    
    %% Renewable energy
    load renewable
% PV in W Windin kW
global PV Wind
PV = PV'/100;
PV = [PV(8:24) PV(1:7)]
Wind = Wind';
Wind = [Wind(8:24) Wind(1:7)]
% % 
% PV = zeros(1,24)
% Wind = PV
% % %     
% PV = 0.5* PV;
%  Wind = 0.5* Wind


