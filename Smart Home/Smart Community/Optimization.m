clc
clear all
INI_SET
%% optimization
global N C


%% up and low boundary
% EWH HVAC EV CD ESS
% EWH [0 4500] W 
% HVAC [0 7] kW
% EV [0 66] 100W
% CD [0 4] kW
% ESS [0 10000] W
EWH_max = 45;
HVAC_max = 20;% train[0 - 2] *2000
EV_max = 2;
CD_max = 2; 
ESS_max = 10;

L=-0.0001*zeros(1,120*N+24);
U=ones(1,120*N+24);
tic
% Initialize the parameters
GAP = gapdefault;                    % can try whats on manual P61        % Line 1


for i = 1:N
   U(1,120*(i-1)+1:120*(i-1)+24) = EWH_max * ones(1,24);
   U(1,120*(i-1)+25:120*(i-1)+48) = HVAC_max * ones(1,24);
   U(1,120*(i-1)+49:120*(i-1)+72) = EV_max * ones(1,24);
   U(1,120*(i-1)+73:120*(i-1)+120) = CD_max * ones(1,48);
   GAP.gd_cid(1,120*(i-1)+1:120*(i-1)+24)  = ones(1,24);
   GAP.gd_cid(1,120*(i-1)+25:120*(i-1)+48)  = 2*ones(1,24);
   GAP.gd_cid(1,120*(i-1)+49:120*(i-1)+72)  = 3*ones(1,24);
   GAP.gd_cid(1,120*(i-1)+73:120*(i-1)+120)  = 4*ones(1,48);
end
U(120*N+1:end) = ESS_max * ones(1,24);
L(120*N+1:end) = -ESS_max * ones(1,24);
GAP.gd_cid(1,(120*N+1):(120*N+24)) = 5*ones(1,24);



T=@(Q) CalT(Q);%input power, initial temperature, estimated water usage
TT=@(Q) CalT_HVAC(Q);% calculate conventional model temperature

%calculating Water provide
Wp=@(Q) Waterprovide(Q,T(Q));%define 24 hour Wp by Q and T,T is collected 


%% Define gene parameters 
%using genetic algorithm
%Nonlinear constraints are not satisfied when the  PopulationType option is set to 'bitString' or 'custom'

%                 x1     x2 ......x24   
% gene             1      2     
GAP.gd_min  = L;            % Line 2
GAP.gd_max  = U;            % Line 3
GAP.gd_type = 1*ones(1,120*N+24);            % Line 4 
%GAP.gd_cid  = ones(1,120*N+24);            % Line 5

GAP.fp_ipop = 100;               % initial population size   
GAP.fp_npop = 100; 
GAP.fp_ngen = 100;% number of generations
GAP.fp_nobj = 1;
GAP.fp_obj = 0;
GAP.trimga = 0;


% objwght objective weight can be considered

% Execute GOSET
[fP,GAS,Qbest,fbest] = gaoptimize(@COST,GAP);   % Line 6 
t1=toc/3600
%final population, GAS structure, best individual

Performance