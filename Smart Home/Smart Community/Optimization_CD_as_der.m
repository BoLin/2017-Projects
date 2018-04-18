
%% optimization
global N ESS_max


%% up and low boundary
% EWH HVAC EV CD ESS
% EWH [0 4500] W 
% HVAC [0 7] kW
% EV [0 66] 100W
% CD [0 4] kW
% ESS [0 10000] W
EWH_max = 45;
HVAC_max = 26;% train[0 - 2.6] *2000
EV_max = 2;
CD_max = 5; % CD time slot from 7 pm to 12 pm 6 slots, 19-24
CD_type = 1; % two types, 0 1
%ESS_max = 10;
 
L=-0.0001*zeros(1,74*N+24);
U=ones(1,74*N+24);
tic
% Initialize the parameters
GAP = gapdefault;                    % can try whats on manual P61        % Line 1


% 24 + 24 + 24 + 2
for i = 1:N
   U(1,74*(i-1)+1:74*(i-1)+24) = EWH_max * ones(1,24);
   U(1,74*(i-1)+25:74*(i-1)+48) = HVAC_max * ones(1,24);
   U(1,74*(i-1)+49:74*(i-1)+72) = EV_max * ones(1,24);
   U(1,74*(i-1)+49:74*(i-1)+59) = zeros(1,11);  % this is the limit for EV
   U(1,74*(i-1)+73) = CD_max;
   U(1,74*(i-1)+74) = CD_type;
   GAP.gd_cid(1,74*(i-1)+1:74*(i-1)+24)  = ones(1,24);
   GAP.gd_cid(1,74*(i-1)+25:74*(i-1)+48)  = 2*ones(1,24);
   GAP.gd_cid(1,74*(i-1)+49:74*(i-1)+72)  = 3*ones(1,24);
   GAP.gd_cid(1,74*(i-1)+73:74*(i-1)+74)  = 4*ones(1,2);
end
U(74*N+1:end) = ESS_max * ones(1,24);
L(74*N+1:end) = -ESS_max * ones(1,24);
GAP.gd_cid(1,(74*N+1):(74*N+24)) = 5*ones(1,24);



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
GAP.gd_type = 1*ones(1,74*N+24);            % Line 4 
%GAP.gd_cid  = ones(1,74*N+24);            % Line 5

GAP.fp_ipop = 100;               % initial population size   
GAP.fp_npop = 100; 
GAP.fp_ngen = 50;% number of generations
GAP.fp_nobj = 1;
GAP.fp_obj = 0;
GAP.trimga = 0;


% objwght objective weight can be considered

% Execute GOSET
[fP,GAS,Qbest,fbest] = gaoptimize(@COST_CD_as_der,GAP);   % Line 6 
t1=toc/3600
%final population, GAS structure, best individual
Qbest_original = Qbest(:,1);
%Qbest = final_trim(Qbest)
Qbest = final_trim(Qbest_original)
