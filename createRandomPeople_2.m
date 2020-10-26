function [stadiums, type] = createRandomPeople_2()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
n = 1;
lev4 = normrnd(530,0,[1,n])+20; % 30
paks4 = (lev4-20)/1.82+20;

lev5 = normrnd(420,0,[1,n])+20; % 40
paks5 = (lev5-20)/1.53+20;

stadiums = zeros(5,1);
q = 1;

    if rand()>0 % 0.5
        a = (sqrt(lev4(q))*(lev4(q) - paks4(q))*sqrt(pi))/sqrt(4*lev4(q) + paks4(q)*(-4 + pi));
        r = (sqrt(lev4(q))*paks4(q)*sqrt(pi))/(2*sqrt(4*lev4(q) + paks4(q)*(-4 + pi)));
        stadiums(1:5,q) = [a*0.5; r; 0; 0; 0];
    else
        a = (sqrt(lev5(q))*(lev5(q) - paks5(q))*sqrt(pi))/sqrt(4*lev5(q) + paks5(q)*(-4 + pi));
        r = (sqrt(lev5(q))*paks5(q)*sqrt(pi))/(2*sqrt(4*lev5(q) + paks5(q)*(-4 + pi)));
        stadiums(1:5,q) = [a*0.5; r; 0; 0; 0];
    end
    
    if rand() < 0.0
        type = "capsule";
    else
        type = "rectangle";
    end

end

