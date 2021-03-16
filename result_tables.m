%%% This script outputs the final result figures in Chapter 3.4
% !!! Set r = 0 in the file simulationRun.m !!!

%simulationCode; simulationRun;

%You may try this
%clear load

% Capsules, BFGS and Matlab
disp("Capsules (grad, BFGS, Matlab):")

table = "";
table = [table newline];

for scen = 3:-1:1
    
    if scen == 1
        table = [table, "1700 $\times$ 2350 & 26 & "];
    elseif scen == 2
        table = [table, "1400 $\times$ 2000 & 17 & "];
    else
        table = [table, "1350 $\times$ 1400 & 10 & "];
    end
    eMatlab = expectedCalculations(Matlab(scen));
    eBFGS = expectedCalculations(BFGS(scen));
    egradM = expectedCalculations(gradM(scen));
    ecyclic = expectedCalculations(cyclic(scen));
    
    maxLen = max([length(eMatlab), length(eBFGS), length(egradM)]);
    
    table = [table num2str(maxLen-1) "&"];
    
    if length(eMatlab) < maxLen
        tMatlab = inf;
    else
        tMatlab = eMatlab(maxLen-1);
    end
    if length(eBFGS) < maxLen
        tBFGS = inf;
    else
        tBFGS = eBFGS(maxLen-1);
    end
    if length(egradM) < maxLen
        tgradM = inf;
    else
        tgradM = egradM(maxLen-1);
    end
    %if length(ecyclic) < maxLen
    %    tcyclic = inf;
    %else
    %    tcyclic = ecyclic(maxLen-1);
    %end
    
    nums = round([tgradM, tBFGS, tMatlab],3,'significant')/10^6;
    
    if tgradM <= min([tgradM, tBFGS, tMatlab])
        table = [table "\textbf{" num2str(nums(1)) "} & "];
    else
        table = [table num2str(nums(1)) " & "];
    end
    
    if tBFGS <= min([tgradM, tBFGS, tMatlab])
        table = [table "\textbf{" num2str(nums(2)) "} & "];
    else
        table = [table num2str(nums(2)) " & "];
    end
    
    if tMatlab <= min([tgradM, tBFGS, tMatlab])
        table = [table "\textbf{" num2str(nums(3)) "}"];
    else
        table = [table num2str(nums(3))];
    end
    
    %if tcyclic <= min([tgradM, tBFGS, tMatlab, tcyclic])
    %    table = [table "\textbf{" num2str(nums(4)) "} & "];
    %else
    %    table = [table num2str(nums(4)) " & "];
    %end
    
    table = [table "\\" newline];
    
end
table = join(table);
disp(strrep(table,'Inf','--'))


% New line search
disp("Capsules (grad, BFGS, new line s.):")

table = "";
table = [table newline];

for scen = 3:-1:1
    
    if scen == 1
        table = [table, "1700 $\times$ 2350 & 26 & "];
    elseif scen == 2
        table = [table, "1400 $\times$ 2000 & 17 & "];
    else
        table = [table, "1350 $\times$ 1400 & 10 & "];
    end
    ecyclic = expectedCalculations(cyclic(scen));
    eBFGS = expectedCalculations(BFGS(scen));
    egradM = expectedCalculations(gradM(scen));
    ecyclic = expectedCalculations(cyclic(scen));
    
    maxLen = max([length(ecyclic), length(eBFGS), length(egradM)]);
    
    table = [table num2str(maxLen-1) "&"];
    
    if length(ecyclic) < maxLen
        tcyclic = inf;
    else
        tcyclic = ecyclic(maxLen-1);
    end
    if length(eBFGS) < maxLen
        tBFGS = inf;
    else
        tBFGS = eBFGS(maxLen-1);
    end
    if length(egradM) < maxLen
        tgradM = inf;
    else
        tgradM = egradM(maxLen-1);
    end
    %if length(ecyclic) < maxLen
    %    tcyclic = inf;
    %else
    %    tcyclic = ecyclic(maxLen-1);
    %end
    
    nums = round([tgradM, tBFGS, tcyclic],3,'significant')/10^6;
    
    if tgradM <= min([tgradM, tBFGS, tcyclic])
        table = [table "\textbf{" num2str(nums(1)) "} & "];
    else
        table = [table num2str(nums(1)) " & "];
    end
    
    if tBFGS <= min([tgradM, tBFGS, tcyclic])
        table = [table "\textbf{" num2str(nums(2)) "} & "];
    else
        table = [table num2str(nums(2)) " & "];
    end
    
    if tcyclic <= min([tgradM, tBFGS, tcyclic])
        table = [table "\textbf{" num2str(nums(3)) "}"];
    else
        table = [table num2str(nums(3))];
    end
    
    %if tcyclic <= min([tgradM, tBFGS, tcyclic, tcyclic])
    %    table = [table "\textbf{" num2str(nums(4)) "} & "];
    %else
    %    table = [table num2str(nums(4)) " & "];
    %end
    
    table = [table "\\" newline];
    
end
table = join(table);
disp(strrep(table,'Inf','--'))

% Suitcases
disp("Suitcases (BFGS, Matlab, new line s.):")

table = "";
table = [table newline];

for scen = 6:-1:4
    
    if scen == 4
        table = [table, "1700 $\times$ 2350 & 26 & "];
    elseif scen == 5
        table = [table, "1400 $\times$ 2000 & 17 & "];
    else
        table = [table, "1350 $\times$ 1400 & 10 & "];
    end
    eMatlab = expectedCalculations(Matlab(scen));
    eBFGS = expectedCalculations(BFGS(scen));
    ecyclic = expectedCalculations(cyclic(scen));
    egradM = expectedCalculations(gradM(scen));
    
    maxLen = max([length(ecyclic), length(eBFGS), length(eMatlab)]);
    
    %fixedObjectCount = ceil(3/2 * (maxLen-1)); % n = 2,3,5,6,8,...
    fixedObjectCount = maxLen-1; % n = 1,2,3,...
    
    table = [table num2str(fixedObjectCount) "&"];
    
    if length(ecyclic) < maxLen
        tcyclic = inf;
    else
        tcyclic = ecyclic(maxLen-1);
    end
    if length(eBFGS) < maxLen
        tBFGS = inf;
    else
        tBFGS = eBFGS(maxLen-1);
    end
    if length(eMatlab) < maxLen
        tMatlab = inf;
    else
        tMatlab = eMatlab(maxLen-1);
    end
    
    if length(egradM) < maxLen
        tgradM = inf;
    else
        tgradM = egradM(maxLen-1);
    end
    %if length(ecyclic) < maxLen
    %    tcyclic = inf;
    %else
    %    tcyclic = ecyclic(maxLen-1);
    %end
    
    nums = round([tBFGS, tMatlab, tcyclic, tgradM],3,'significant')/10^6;
    
    if tBFGS <= min([tBFGS, tMatlab, tcyclic])
        table = [table "\textbf{" num2str(nums(1)) "} & "];
    else
        table = [table num2str(nums(1)) " & "];
    end
    
    %if tgradM <= min([tBFGS, tMatlab, tcyclic])
    %    table = [table "\textbf{" num2str(nums(4)) "}"];
    %else
    %    table = [table num2str(nums(4))];
    %end
    
    if tMatlab <= min([tBFGS, tMatlab, tcyclic])
        table = [table "\textbf{" num2str(nums(2)) "} & "];
    else
        table = [table num2str(nums(2)) " & "];
    end
    
    if tcyclic <= min([tBFGS, tMatlab, tcyclic])
        table = [table "\textbf{" num2str(nums(3)) "}"];
    else
        table = [table num2str(nums(3))];
    end
    
    %if tcyclic <= min([tgradM, tBFGS, tcyclic, tcyclic])
    %    table = [table "\textbf{" num2str(nums(4)) "} & "];
    %else
    %    table = [table num2str(nums(4)) " & "];
    %end
    
    table = [table "\\" newline];
    
end
table = join(table);
disp(strrep(table,'Inf','--'))
