%% multi task run

for N = 20  %:3:10
    INI_SET
    
    Optimization_CD_as_der  % Line 6
    
   % Qbest = Qbest(:,1);
    
    c = clock;
    filename = sprintf('%d-%d',c(1:5),N)
    filename = strcat(filename,'.mat')
    save(filename,'Qbest')
end




