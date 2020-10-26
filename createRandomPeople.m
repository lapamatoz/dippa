function [stadiums, suitcases] = createRandomPeople(n)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
lev4 = normrnd(530,0,[1,n])+20; % 30
paks4 = (lev4-20)/1.82+20;

lev5 = normrnd(420,0,[1,n])+20; % 40
paks5 = (lev5-20)/1.53+20;

stadiums = zeros(5,n);

for q = 1:n
    if rand()>0 % 0.5
        a = (sqrt(lev4(q))*(lev4(q) - paks4(q))*sqrt(pi))/sqrt(4*lev4(q) + paks4(q)*(-4 + pi));
        r = (sqrt(lev4(q))*paks4(q)*sqrt(pi))/(2*sqrt(4*lev4(q) + paks4(q)*(-4 + pi)));
        stadiums(:,q) = [a*0.5; r; 0; 0; 0];
    else
        a = (sqrt(lev5(q))*(lev5(q) - paks5(q))*sqrt(pi))/sqrt(4*lev5(q) + paks5(q)*(-4 + pi));
        r = (sqrt(lev5(q))*paks5(q)*sqrt(pi))/(2*sqrt(4*lev5(q) + paks5(q)*(-4 + pi)));
        stadiums(:,q) = [a*0.5; r; 0; 0; 0];
    end
end

nSuitcases = n;
suitcases = [normrnd(38.942,3.035,[1,nSuitcases])*0.5; normrnd(22.395,2.368,[1,nSuitcases]); zeros(1,nSuitcases); zeros(1,nSuitcases)];

suitcases(1,:) = 6*suitcases(1,:);
suitcases(2,:) = 3*suitcases(2,:);

end

