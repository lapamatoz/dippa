%%% This script outputs the final result figures in Chapter 3.4
% !!! Set r = 0 in the file simulationRun.m !!!

%simulationCode; simulationRun;

%You may try this
%clear load

scenario = 1; % 1 to 3
save1 = false;

% p-plots
%big
figure; hold on;
if scenario == 1
    axisLimits = [11,34,-0.02,1.02];
elseif scenario == 2
    axisLimits = [12,24 ,-0.02,1.02];
else
    axisLimits = [8,16,-0.02,1.02];
end

p1 = BFGS(scenario).probabilityP();
p2 = Matlab(scenario).probabilityP();
p2.Color = 'k';
p1.Color = defaultPlotColors(1);
p1.LineWidth = 1;
p2.LineWidth = 1;
p1.LineStyle = '--';
axis(axisLimits)
plot(axisLimits(1:2), [1,1], ':', 'Color', 'k', 'LineWidth', 1)
plot(axisLimits(1:2), [0,0], ':', 'Color', 'k', 'LineWidth', 1)
%grid on
title('Probability of finding a feasible arrangement')
legend([p2 p1],...
            ["Cyclic pl. m. (Matlab's solver)", ...
             "BFGS"],...
            'Location',...
            'southwest');
figuresize(14, 9, 'cm')
if save1
    saveas(gcf, ['probabilityP-capsules-',num2str(scenario),'.pdf']);
end

figure; hold on;

curves = Matlab(scenario).plotTwo(BFGS(scenario));
title('Expected solving times')
legend([curves(1) curves(2)],...
            ["Cyclic pl. m. (Matlab's solver)", ...
             "BFGS"],...
            'Location',...
            'southeast');
figuresize(14, 9, 'cm')
if save1
    saveas(gcf, ['expected-capsules-',num2str(scenario),'.pdf']);
end

figure; hold on;
BFGS(scenario).plot('no',false);
title('BFGS performance')
figuresize(14, 9, 'cm')
if save1
    saveas(gcf, ['BFGS-capsules-',num2str(scenario),'.pdf']);
end

figure; hold on;
Matlab(scenario).plot('no',false);
title("Cyclic pl. m. performance (Matlab's solver)")
figuresize(14, 9, 'cm')
if save1
    saveas(gcf, ['Matlab-capsules-',num2str(scenario),'.pdf']);
end

close all

BFGS(scenario).Pbest(1).drawProblem(false);
figuresize(14, 9, 'cm')
if save1
    saveas(gcf, ['BFGS-arrangement-capsules-',num2str(scenario),'.pdf']);
end

Matlab(scenario).Pbest(1).drawProblem(false);
figuresize(14, 9, 'cm')
if save1
    saveas(gcf, ['Matlab-arrangement-capsules-',num2str(scenario),'.pdf']);
end