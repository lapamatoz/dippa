%scenario = 6;
method = gradM;

for scenario = 1:6
    lengths = zeros(1,length(method(scenario).res));

    for q = 1:length(method(scenario).res)
        lengths(q) = length(method(scenario).res{q});
    end

    eMatlab = expectedCalculations(Matlab(scenario));
    eBFGS = expectedCalculations(BFGS(scenario));
    egradM = expectedCalculations(gradM(scenario));
    ecyclic = expectedCalculations(cyclic(scenario));

    maxLen = max([length(eMatlab), length(eBFGS), length(egradM), length(ecyclic)]);


    T = zeros(1,length(method(scenario).res));

    for q = 1:length(method(scenario).res)
        if length(method(scenario).res{q}) == maxLen
            T(q) = abs(method(scenario).res{q}{end-1});
        else
            T(q) = -abs(method(scenario).res{q}{end});
        end
    end

    TP = mean(T(T > 0));
    TQ = -mean(T(T <= 0));

    figure; hold on;
    plot(rand(1,length(T(T > 0))), T(T > 0), '.', 'Color', 'k', 'MarkerSize', 7);
    plot(rand(1,length(T(T <= 0)))+2, -T(T <= 0), '.', 'Color', defaultPlotColors(2), 'MarkerSize', 7);
    range = abs(-min(abs(T)) - max(abs(T)));
    axis([-0.5 3.5 min(abs(T))-0.1*range max(abs(T))+0.1*range])
    set(gca,'xtick',[])
    ylabel('{\itA} and {\itE} function evaluations')

    %annotation('textbox',[.9 .5 .1 .2],'String','Text outside the axes','EdgeColor','none')
    annotation('textbox',[0.31 0 .3 .1],'String','{\itT}_{\itP}','EdgeColor','none')
    annotation('textbox',[0.68 0 .3 .1],'String','{\itT}_{\itQ}','EdgeColor','none')

    if scenario == 1 || scenario == 4
        %title('Box size: 1700 x 2350')
    elseif scenario == 2 || scenario == 5
        %title('Box size: 1400 x 2000')
    else
        %title('Box size: 1350 x 1400')
    end

    figuresize(7, 8, 'cm')
    ax = gca;
    ax.YAxis.Exponent = 6;
    saveas(gcf, join(['TP-TQ', method(scenario).name, '.pdf']))
end

for scenario = 1:6
    drawProblem(method(scenario).Pbest(1),false)
    %figuresize(8, 10, 'cm')
    w = method(scenario).problem('box').width;
    h = method(scenario).problem('box').height;
    axis([-w/2 w/2 -h/2 h/2]*zoomfactor)
    figuresize(14, 9, 'cm')
    %saveas(gcf, join(['liftSetup', method(scenario).name, '.pdf']))
end