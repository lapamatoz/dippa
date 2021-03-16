scen=3;
if scen >= 4
    disp("Valkkaappa joku toinen skenaario")
    return
end
save1 = true;


%barcolors = [1, 1, 1; .5,.5,.5; .75,.75,.75; .25,.25,.25];
barcolors = [defaultPlotColors(1).^0.7; .9*defaultPlotColors(2); defaultPlotColors(3); defaultPlotColors(4).^(3)];


if scen == 1
    titletxt = "Box: 1700 x 2350 mm";
elseif scen == 2
    titletxt = "Box: 1400 x 2000 mm";
elseif scen == 3
    titletxt = "Box: 1350 x 2350 mm";
end

gradMlengths = zeros(1,length(gradM(scen).res));

for q = 1:length(gradM(scen).res)
    gradMlengths(q) = length(gradM(scen).res{q})-1;
end

%histogram(gradMlengths)

BFGSlengths = zeros(1,length(BFGS(scen).res));

for q = 1:length(BFGS(scen).res)
    BFGSlengths(q) = length(BFGS(scen).res{q})-1;
end

%histogram(BFGSlengths)

binMax = max([BFGSlengths+1, gradMlengths+1]);
binMin = max(0, binMax-8);
binRange = binMin:1:binMax ;
hcx = histcounts(gradMlengths,[binRange Inf],'Normalization','probability');
hcy = histcounts(BFGSlengths,[binRange Inf],'Normalization','probability');
figure
b = bar(binRange,[hcx;hcy]');
b(1).FaceColor = barcolors(1,:);
b(2).FaceColor = barcolors(2,:);

legend("Gradient method","BFGS",'Location','northwest')
ylabel("Probability")
xlabel("Simulation result")

figuresize(14, 9, 'cm')
if save1
    saveas(gcf, ['histogram-grad-BFGS-',num2str(scen),'.pdf']);
end

%%% MATLAB ADDED

gradMlengths = zeros(1,length(gradM(scen).res));

for q = 1:length(gradM(scen).res)
    gradMlengths(q) = length(gradM(scen).res{q})-1;
end

%histogram(gradMlengths)

BFGSlengths = zeros(1,length(BFGS(scen).res));

for q = 1:length(BFGS(scen).res)
    BFGSlengths(q) = length(BFGS(scen).res{q})-1;
end

Matlablengths = zeros(1,length(gradM(scen).res));

for q = 1:length(Matlab(scen).res)
    Matlablengths(q) = length(Matlab(scen).res{q})-1;
end

%histogram(BFGSlengths)

binMax = max([BFGSlengths+1, gradMlengths+1, Matlablengths+1]);
binMin = max(0, binMax-8);
binRange = binMin:1:binMax ;
hcx = histcounts(gradMlengths,[binRange Inf],'Normalization','probability');
hcy = histcounts(BFGSlengths,[binRange Inf],'Normalization','probability');
hcm = histcounts(Matlablengths,[binRange Inf],'Normalization','probability');
figure
b = bar(binRange,[hcx;hcy;hcm]');
b(1).FaceColor = barcolors(1,:);
b(2).FaceColor = barcolors(2,:);
b(3).FaceColor = barcolors(3,:);

legend("Gradient method","BFGS","Cyclic pl. m. (Matlab's solver)",'Location','northwest')
ylabel("Probability")
xlabel("Simulation result")
title(titletxt)

figuresize(14, 9, 'cm')
if save1
    saveas(gcf, ['histogram-three-',num2str(scen),'.pdf']);
end

%%% CYCLIC ADDED

gradMlengths = zeros(1,length(gradM(scen).res));

for q = 1:length(gradM(scen).res)
    gradMlengths(q) = length(gradM(scen).res{q})-1;
end

%histogram(gradMlengths)

BFGSlengths = zeros(1,length(BFGS(scen).res));

for q = 1:length(BFGS(scen).res)
    BFGSlengths(q) = length(BFGS(scen).res{q})-1;
end

Matlablengths = zeros(1,length(gradM(scen).res));

for q = 1:length(Matlab(scen).res)
    Matlablengths(q) = length(Matlab(scen).res{q})-1;
end

cycliclengths = zeros(1,length(gradM(scen).res));

for q = 1:length(cyclic(scen).res)
    cycliclengths(q) = length(cyclic(scen).res{q})-1;
end

%histogram(BFGSlengths)

binMax = max([BFGSlengths+1, gradMlengths+1, Matlablengths+1, cycliclengths+1]);
binMin = max(0, binMax-8);
binRange = binMin:1:binMax ;
hcx = histcounts(gradMlengths,[binRange Inf],'Normalization','probability');
hcy = histcounts(BFGSlengths,[binRange Inf],'Normalization','probability');
hcm = histcounts(Matlablengths,[binRange Inf],'Normalization','probability');
hcc = histcounts(cycliclengths,[binRange Inf],'Normalization','probability');
figure
b = bar(binRange,[hcx;hcy;hcm;hcc]');
b(1).FaceColor = barcolors(1,:);
b(2).FaceColor = barcolors(2,:);
b(3).FaceColor = barcolors(3,:);
b(4).FaceColor = barcolors(4,:);

legend("Gradient method","BFGS","Cyclic pl. m. (Matlab's solver)","Cyclic pl. m. (new line s.)",'Location','northwest')
ylabel("Probability")
xlabel("Simulation result")
title(titletxt)

figuresize(14, 9, 'cm')
if save1
    saveas(gcf, ['histogram-four-',num2str(scen),'.pdf']);
end


%%% SUITCASES

scen=3+scen

if scen == 4
    titletxt = "Box: 1700 x 2350 mm";
elseif scen == 5
    titletxt = "Box: 1400 x 2000 mm";
elseif scen == 6
    titletxt = "Box: 1350 x 2350 mm";
end

gradMlengths = zeros(1,length(gradM(scen).res));

for q = 1:length(gradM(scen).res)
    gradMlengths(q) = length(gradM(scen).res{q})-1;
end

%histogram(gradMlengths)

BFGSlengths = zeros(1,length(BFGS(scen).res));

for q = 1:length(BFGS(scen).res)
    BFGSlengths(q) = length(BFGS(scen).res{q})-1;
end

Matlablengths = zeros(1,length(gradM(scen).res));

for q = 1:length(Matlab(scen).res)
    Matlablengths(q) = length(Matlab(scen).res{q})-1;
end

cycliclengths = zeros(1,length(gradM(scen).res));

for q = 1:length(cyclic(scen).res)
    cycliclengths(q) = length(cyclic(scen).res{q})-1;
end

%histogram(BFGSlengths)

binMax = max([BFGSlengths+1, gradMlengths+1, Matlablengths+1, cycliclengths+1]);
binMin = max(0, binMax-8);
binRange = binMin:1:binMax ;
hcx = histcounts(gradMlengths,[binRange Inf],'Normalization','probability');
hcy = histcounts(BFGSlengths,[binRange Inf],'Normalization','probability');
hcm = histcounts(Matlablengths,[binRange Inf],'Normalization','probability');
hcc = histcounts(cycliclengths,[binRange Inf],'Normalization','probability');
figure
b = bar(binRange,[hcx;hcy;hcm;hcc]');
b(1).FaceColor = barcolors(1,:);
b(2).FaceColor = barcolors(2,:);
b(3).FaceColor = barcolors(3,:);
b(4).FaceColor = barcolors(4,:);

legend("Gradient method","BFGS","Cyclic pl. m. (Matlab's solver)","Cyclic pl. m. (new line s.)",'Location','northwest')
ylabel("Probability")
xlabel("Simulation result")
title(titletxt)

figuresize(14, 9, 'cm')
if save1
    saveas(gcf, ['histogram-suitcases-',num2str(scen),'.pdf']);
end