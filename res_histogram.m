scen=3;
save1 = true;

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
bar(binRange,[hcx;hcy]')

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
bar(binRange,[hcx;hcy;hcm]')

legend("Gradient method","BFGS","Cyclic pl. m. (Matlab's solver)",'Location','northwest')
ylabel("Probability")
xlabel("Simulation result")

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
bar(binRange,[hcx;hcy;hcm;hcc]')

legend("Gradient method","BFGS","Cyclic pl. m. (Matlab's solver)","Cyclic pl. m. (new line s.)",'Location','northwest')
ylabel("Probability")
xlabel("Simulation result")

figuresize(14, 9, 'cm')
if save1
    saveas(gcf, ['histogram-four-',num2str(scen),'.pdf']);
end