%%%%% MID BOX
midbox = shape;
midbox.height = 1400 / 100;
midbox.width = 2000 / 100;
midbox.type = 'rectangle';

Matlab = resultsAnalysis;
for q = 5
    Matlab(q) = resultsAnalysis;
    Matlab(q).problem = containers.Map;
    Matlab(q) = Matlab(q).initialize();
    Matlab(q).problem('method2') = @(P,p)P.optimizeCyclic('Matlab',p);
    Matlab(q).problem('squared') = 'no';
    Matlab(q).problem('changeIter') = 0;
    Matlab(q).problem('h2Step') = 'no';
    Matlab(q).name = "Matlab (BSc thesis)";
    if q == 1 || q == 4
        Matlab(q).problem('box') = bigbox;
        Matlab(q).name = join([Matlab(q).name, "bigBox"]);
    elseif q == 2 || q == 5
        Matlab(q).problem('box') = midbox;
        Matlab(q).name = join([Matlab(q).name, "midBox"]);
    elseif q == 3 || q == 6
        Matlab(q).problem('box') = smabox;
        Matlab(q).name = join([Matlab(q).name, "smallBox"]);
    end
    if q<=3
        Matlab(q).problem('shape1') = Matlab(q).problem('shape1').capsule;
        Matlab(q).name = join([Matlab(q).name, "capsules"]);
    else
        Matlab(q).name = join([Matlab(q).name, "capsRect"]);
    end
end

Matlab(5).problem
%Pcapsules = Matlab(5).simulate(1, "returnP");
Pcapsules.drawProblem(false)

figuresize(8, 8, 'cm')
saveas(gcf, ['contours-box', '.pdf'])

n = 120;
t = 1;
while isa(Pcapsules.shapes{t},'shape')
    t = t+1;
end
theta0 = Pcapsules.shapes{t}.capsule.theta;
x0 = Pcapsules.shapes{t}.capsule.position(1);
y0 = Pcapsules.shapes{t}.capsule.position(2);
alpha0 = Pcapsules.shapes{1}.rectangle.position(1);
beta0 = Pcapsules.shapes{1}.rectangle.position(2);

x = linspace(-midbox.width/ 2, midbox.width/ 2, n);
y = linspace(-midbox.height/ 2, midbox.height/ 2, n);
theta = linspace(-1.5*pi, 1.5*pi, n);
alpha = linspace(-3*pi, 3*pi, n);
beta = linspace(-1, 1, n);

problem = containers.Map;
problem("allowDist") = "allowDistances";
problem("squared") = "no";
problem2 = containers.Map;
problem2("allowDist") = "no";
problem2("squared") = "no";
zDist = zeros(n,n);
zNoDist = zeros(n,n);
for tile=1:7
    if tile == 1
        vector = @(q,w)[x(q), y(w), theta0, alpha0, beta0];
        xlab = '\it{x}'; ylab = '\it{y}';
        xplot = x; yplot = y;
    elseif tile == 2
        vector = @(q,w)[x(q), y0, theta(w), alpha0, beta0];
        xlab = '\it{x}'; ylab = '\it{θ}';
        xplot = x; yplot = theta;
    elseif tile == 3
        vector = @(q,w)[x(q), y0, theta0, alpha(w), beta0];
        xlab = '\it{x}'; ylab = '\it{α}';
        xplot = x; yplot = alpha;
    elseif tile == 4
        vector = @(q,w)[x(q), y0, theta0, alpha0, beta(w)];
        xlab = '\it{x}'; ylab = '\it{β}';
        xplot = x; yplot = beta;
    elseif tile == 5
        vector = @(q,w)[x0, y0, theta(q), alpha(w), beta0];
        xlab = '\it{θ}'; ylab = '\it{α}';
        xplot = theta; yplot = alpha;
    elseif tile == 6
        vector = @(q,w)[x0, y0, theta(q), alpha0, beta(w)];
        xlab = '\it{θ}'; ylab = '\it{β}';
        xplot = theta; yplot = beta;
    elseif tile == 7
        vector = @(q,w)[x0, y0, theta0, alpha(q), beta(w)];
        xlab = '\it{α}'; ylab = '\it{β}';
        xplot = alpha; yplot = beta;
    end
    parfor q = 1:n
        for w = 1:n
            zDist(q,w) = objectiveFunctionShapeWise(Pcapsules, feval(vector,q,w), 1, problem);
            %zNoDist(q,w) = objectiveFunctionShapeWise(Pcapsules, [x0, y(w), x(q), p], 1, problem2);
        end
    end
    figure('visible','off');
    figure;
    contourf(xplot,yplot,zDist.')
    colormap(hot)
    daspect([1 1 1])
    colorbar
    xlabel(xlab)
    ylabel(ylab)
    figuresize(8, 8, 'cm')
    saveas(gcf, ['contours-', num2str(tile), '.pdf'])
    close all
end
% figure;
% contourf(x,y,zDist.')
% colormap(hot)
% daspect([1 1 1])
% colorbar
% title('Using distances')
% xlabel('\it{θ}')
% ylabel('\it{y}')
% 
% figure;
% contourf(x,y,zNoDist.')
% colormap(hot)
% daspect([1 1 1])
% colorbar
% title('Using intersecting areas')
% xlabel('\it{θ}')
% ylabel('\it{y}')