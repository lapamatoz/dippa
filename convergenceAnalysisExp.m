plotPerformance(@(x)quadraticfun(x), 30, 30, 80, [-3,11], [-11,1], [10;-10], [0;0], 0, 'quadratic');
plotPerformance(@(x)expfun(x), 31, 22, 40, [-3.5,1], [-4.5,.5], [-2; -4], [-log(2) / 2 - 1/20; 0], 2*sqrt(2) / exp(3/20), 'exp');
plotPerformance(@(x)rosenbrockfun(x), 10500, 8000, 130, [-0.7,1.5], [-1.2,1.5], [0.5;-1], [1;1], 0, 'rosenbrock');
%close all hidden
% Rosenbrock with steps 10500, 8000 takes a lot of time

function plotPerformance(fun, nExact, nNewtonLike, nContour, xrange, yrange, x0, optimum, optVal, name)
%%% Draw contours
x1 = linspace(xrange(1),xrange(2),nContour);
x2 = linspace(yrange(1),yrange(2),nContour);

z= zeros(nContour);
for i = 1:nContour
    for j = 1:nContour
        z(j,i) = fun([x1(i),x2(j)]).^(1/2);
    end
end

close all hidden
contour(x1,x2,z.^0.5,8)
hold on
%%% End drawing contours
lineWidth = 1.5;

%optimum = [-log(2) / 2 - 1/20, 0].';
%optVal = 2*sqrt(2) / exp(3/20);

%%% Begin Newton-like line search

x = zeros(2,nNewtonLike);
funVal = zeros(1,nNewtonLike);
x(:,1) = x0;
funVal(1) = fun(x(:,1));

for k = 1:nNewtonLike
    H = hessian(@(x)fun(x),x(:,k));
    G = gradient(@(x)fun(x),x(:,k)).';
    
    alpha = norm(G)^2 / (G.' * H * G);
    x(:,k+1) = x(:,k) - alpha * G;
    funVal(k+1) = fun(x(:,k+1));
end
%%% End Newton-like line search

%%% Begin exact line search
xExact = zeros(2,nExact);
funValExact = zeros(1,nExact);
xExact(:,1) = x0;
funValExact(1) = fun(xExact(:,1));

options = optimset('TolFun',1e-19,'TolX',1e-19);

for k = 1:nExact
    H = hessian(@(x)fun(x),xExact(:,k));
    G = gradient(@(x)fun(x),xExact(:,k)).';
    
    alpha = norm(G)^2 / (G.' * H * G);
    alpha = fminsearch(@(alpha)fun(xExact(:,k) - alpha * G), alpha, options);
    xExact(:,k+1) = xExact(:,k) - alpha * G;
    funValExact(k+1) = fun(xExact(:,k+1));
end
%%% End exact line search

%%% FINITE h
h = [5e-2, 5e-3];
xFinite = {};
funValFinite = {};

parfor hIndex = 1:length(h)
    xFinite{hIndex} = zeros(2,nExact);
    funValFinite{hIndex} = zeros(1,nExact);
    xFinite{hIndex}(:,1) = x0;
    funValFinite{hIndex}(1) = fun(xFinite{hIndex}(:,1));
    for k = 1:nExact
        G = gradient(@(x)fun(x),xFinite{hIndex}(:,k)).';
        h1 = h(hIndex)/norm(G); %/ sqrt(k);
        g2 = 2/h1 * ( 1/h1 * (fun(xFinite{hIndex}(:,k) - h1 * G) - fun(xFinite{hIndex}(:,k))) + norm(G)^2);
        alpha = norm(G)^2 / g2;
        %disp(fun(xFinite{hIndex}(:,end) - h1 * G) - fun(xFinite{hIndex}(:,end)))
        xFinite{hIndex}(:,k+1) = xFinite{hIndex}(:,k) - alpha * G;
        funValFinite{hIndex}(k+1) = fun(xFinite{hIndex}(:,k+1));
    end
end
% End FINITE h

%%% PLOT TERRAIN
p1 = plot(x(1,:), x(2,:), '.-', 'Color', 'k', 'LineWidth', lineWidth, 'Marker', 'x');
%plot(x(1,:), x(2,:),['k', 'o'], 'LineWidth', lineWidth)

p2 = plot(xExact(1,:), xExact(2,:), '.-', 'Color', defaultPlotColors(1), 'LineWidth', lineWidth, 'Marker', 'o');
%plot(xExact(1,:), xExact(2,:), 'o', 'Color', defaultPlotColors(1), 'LineWidth', lineWidth)

% Finite h
p3 = plot(xFinite{1}(1,:), xFinite{1}(2,:), '.-', 'Color', defaultPlotColors(3), 'LineWidth', lineWidth*.8, 'Marker', 's');
p4 = plot(xFinite{2}(1,:), xFinite{2}(2,:), '.-', 'Color', defaultPlotColors(2), 'LineWidth', lineWidth*.8, 'Marker', '^');
p3.Color(4) = .6;
p4.Color(4) = .6;

daspect([1 1 1])
if name == "quadratic"
    loc = 'southwest';
elseif name == "exp"
    loc = 'southeast';
else
    loc = 'northwest';
end
leg = legend([p2,p1,p3,p4],...
        {'Exact line seacrch',...
         'Newton-like line search',...
         'Finite step size, {\ith}_1',...
         'Finite step size, {\ith}_2'},...
        'Location', loc);
xlabel('{\itx}_1')
ylabel('{\itx}_2')

figureDim = [8, 6];
figuresize(figureDim(1)*1.8, figureDim(2)*1.8, 'cm')
saveas(gcf, ['convergence-', name, '-terrain.pdf'])

lineWidth = 1.3;

%%% FUNCTION VALUE CONVERGENCE
figure; hold on;
p1 = plot(0:nNewtonLike, abs(funVal - optVal), '.-', 'Color', 'k', 'LineWidth', lineWidth, 'Marker', 'x');
p2 = plot(0:nExact, abs(funValExact - optVal), '.-', 'Color', defaultPlotColors(1), 'LineWidth', lineWidth, 'Marker', 'o');
p3 = plot(0:nExact, abs(funValFinite{1} - optVal), '.-', 'Color', defaultPlotColors(3), 'LineWidth', lineWidth*0.8, 'Marker', 's');

% Some hand waving, preventing log(0)
ploty = abs(funValFinite{2} - optVal);
zeroes = (ploty ~= 0);
plotx = 0:nExact;

p4 = plot(plotx(zeroes), ploty(zeroes), '.-', 'Color', defaultPlotColors(2), 'LineWidth', lineWidth*0.8, 'Marker', '^');
p3.Color(4) = .6;
p4.Color(4) = .6;

set(gca, 'YScale', 'log')
title('Function value convergence')
ylim([1e-13, inf])
xlim([0, max(nExact, nNewtonLike)])
%if name == "rosenbrock"
%    loc = 'southwest';
%else
    loc = 'northeast';
%end
%leg = legend([p1,p2,p3,p4],...
%        {'Newton-like line search', 'Exact line seacrch',...
%         'Finite step size, {\ith}_1',...
%         'Finite step size, {\ith}_2'},...
%        'Location', loc);
xlabel('Iteration, {\itk}')
ylabel('|{\itf} ({\itx}_{\itk}) − {\itf} *|')

figuresize(figureDim(1), figureDim(2), 'cm')
saveas(gcf, ['convergence-', name, '-value.pdf'])

%%% ARGUMENT CONVERGENCE
figure; hold on;
p1 = plot(0:nNewtonLike, vecnorm(x- optimum), '.-', 'Color', 'k', 'LineWidth', lineWidth, 'Marker', 'x');
p2 = plot(0:nExact, vecnorm(xExact- optimum), '.-', 'Color', defaultPlotColors(1), 'LineWidth', lineWidth, 'Marker', 'o');

p3 = plot(0:nExact, vecnorm(xFinite{1}- optimum), '.-', 'Color', defaultPlotColors(3), 'LineWidth', lineWidth*.8, 'Marker', 's');
p4 = plot(0:nExact, vecnorm(xFinite{2}- optimum), '.-', 'Color', defaultPlotColors(2), 'LineWidth', lineWidth*.8, 'Marker', '^');
p3.Color(4) = .6;
p4.Color(4) = .6;

set(gca, 'YScale', 'log')
title('Argument convergence')
ylim([1e-13, inf])
xlim([0, max(nExact, nNewtonLike)])
if name == "rosenbrock"
    loc = 'northeast';
else
    loc = 'northeast';
end
%leg = legend([p1,p2,p3,p4],...
%        {'Newton-like line search', 'Exact line seacrch',...
%         'Finite step size, {\ith}_2',...
%         'Finite step size, {\ith}_2'},...
%        'Location', loc);
xlabel('Iteration, {\itk}')
ylabel('∥{\itx}_{\itk} − {\itx}*∥')

figuresize(figureDim(1), figureDim(2), 'cm')
saveas(gcf, ['convergence-', name, '-position.pdf'])

end

function out = quadraticfun(x)
    try
        d = length(x(1).value);
        half = imagine;
        half.value = [0.5, zeros(1,d-1)];
        zero = imagine;
        zero.value = [0, zeros(1,d-1)];
        two = imagine;
        two.value = [2, zeros(1,d-1)];
        four = imagine;
        four.value = [4, zeros(1,d-1)];
        %for i = 1:d2-1
        %    out = out + hundred*(x(i+1) - x(i)*x(i))*(x(i+1) - x(i)*x(i)) + (x(i)-one)*(x(i)-one);
        %end
        out = two * (half*x(1)*x(1) + four*x(2)*x(2)) - half*x(1)*x(2);
    catch
        out = 2*(.5*x(1)^2 + 4*x(2)^2) - .5*x(1)*x(2);
    end
end

function out = expfun(x)
    try
        d = length(x(1).value);
        tenth = imagine;
        tenth.value = [0.1, zeros(1,d-1)];
        twoTenths = imagine;
        twoTenths.value = [0.2, zeros(1,d-1)];
        two = imagine;
        two.value = [2, zeros(1,d-1)];
        
        out = exp(x(1) + two*x(2) - tenth) +...
              exp(-x(1) - twoTenths) +...
              exp(x(1) - two*x(2) - tenth);
    catch
        out = exp(x(1) + 2*x(2) - .1) +...
              exp(-x(1) - .2) +...
              exp(x(1) - 2*x(2) - .1);
    end
end

function out = rosenbrockfun(x)
    try
        d2 = length(x);
        d = length(x(1).value);
        hundred = imagine;
        hundred.value = [100, zeros(1,d-1)];
        zero = imagine;
        zero.value = [0, zeros(1,d-1)];
        out = zero;
        one = imagine;
        one.value = [1, zeros(1,d-1)];
        for i = 1:d2-1
            out = out + hundred*(x(i+1) - x(i)*x(i))*(x(i+1) - x(i)*x(i)) + (x(i)-one)*(x(i)-one);
        end
    catch
        d = length(x);
        out = 0;
        for i = 1:d-1
            out = out + 100*(x(i+1) - x(i)*x(i))*(x(i+1) - x(i)*x(i)) + (x(i)-1)*(x(i)-1);
        end
    end
end