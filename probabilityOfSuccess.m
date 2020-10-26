function res = probabilityOfSuccess(stadiums, boxSize, trials, calcLimit)
%UNTITLED3 Summary of this function goes here
nPeople = length(stadiums);
res = zeros(trials,1);

nSuitcases = 0;
suitcases = [normrnd(38.942,3.035,[1,nSuitcases]); normrnd(22.395,2.368,[1,nSuitcases]); zeros(1,nSuitcases); zeros(1,nSuitcases)];
suitcaseC = 1;

parfor p = 1:trials
    [~, ~, value, calculations] = optimizeSystem_2020(stadiums(:,randperm(nPeople)),suitcases,suitcaseC,calcLimit,false,NaN,boxSize)
    if calculations >= calcLimit
        res(p) = Inf;
    else
        res(p) = calculations;
    end
end
%p = sum(res) / trials;
end