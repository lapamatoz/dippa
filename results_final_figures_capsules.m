%%% This script outputs the final result figures in Chapter 3.4
% !!! Set r = 0 in the file simulationRun.m !!!

%simulationCode; simulationRun;

%You may try this
%clear load

scenario = 3; % 1 to 3
save1 = true;
zoomfactor = 1.1;

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

p2 = BFGS(scenario).probabilityP();
p3 = Matlab(scenario).probabilityP();
p1 = gradM(scenario).probabilityP();
p1.Color = 'k';
p2.Color = defaultPlotColors(1);
p3.Color = defaultPlotColors(2);
p1.LineWidth = 1;
p2.LineWidth = 1;
p3.LineWidth = 1;
p2.LineStyle = '--';
p3.LineStyle = '-.';
axis(axisLimits)
plot(axisLimits(1:2), [1,1], ':', 'Color', 'k', 'LineWidth', 1)
plot(axisLimits(1:2), [0,0], ':', 'Color', 'k', 'LineWidth', 1)
%grid on
title('Probability of finding a feasible arrangement')
legend([p1 p2 p3],...
            ["Gradient method",...
             "BFGS",...
             "Cyclic pl. m. (Matlab's solver)"],...
            'Location',...
            'southwest');
figuresize(14, 9, 'cm')
if save1
    saveas(gcf, ['probabilityP-capsules-',num2str(scenario),'.pdf']);
end

figure; hold on;

curves = gradM(scenario).plotTwo([BFGS(scenario), Matlab(scenario)]);
title('Expected solving times')
legend([curves(1) curves(2) curves(3)],...
            ["Gradient method",...
             "BFGS",...
             "Cyclic pl. m. (Matlab's solver)"],...
            'Location',...
            'southeast');
figuresize(14, 9, 'cm')
if save1
    saveas(gcf, ['expected-capsules-',num2str(scenario),'.pdf']);
end

figure; hold on;
gradM(scenario).plot('no',false);
title("Gradient m. performance")
figuresize(14, 9, 'cm')
if save1
    saveas(gcf, ['gradM-capsules-',num2str(scenario),'.pdf']);
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

%close all

gradM(scenario).Pbest(1).drawProblem(false);
w = gradM(scenario).problem('box').width;
h = gradM(scenario).problem('box').height;
axis([-w/2 w/2 -h/2 h/2]*zoomfactor)
figuresize(14, 9, 'cm')
if save1
    saveas(gcf, ['gradM-arrangement-capsules-',num2str(scenario),'.pdf']);
end

BFGS(scenario).Pbest(1).drawProblem(false);
w = BFGS(scenario).problem('box').width;
h = BFGS(scenario).problem('box').height;
axis([-w/2 w/2 -h/2 h/2]*zoomfactor)
figuresize(14, 9, 'cm')
if save1
    saveas(gcf, ['BFGS-arrangement-capsules-',num2str(scenario),'.pdf']);
end

Matlab(scenario).Pbest(1).drawProblem(false);
w = Matlab(scenario).problem('box').width;
h = Matlab(scenario).problem('box').height;
axis([-w/2 w/2 -h/2 h/2]*zoomfactor)
figuresize(14, 9, 'cm')
if save1
    saveas(gcf, ['Matlab-arrangement-capsules-',num2str(scenario),'.pdf']);
end