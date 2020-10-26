function out = objectAreas(stadiums, types)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
nPeople = length(stadiums(1,:));
out = zeros(1,nPeople);
for v = 1:nPeople
    if types(v) == "capsule"
        out(v) = stadiums(2,v)*(pi*stadiums(2,v) + 4*stadiums(1,v));
    elseif types(v) == "rectangle"
        out(v) = 4 * stadiums(1,v) * stadiums(2,v);
    end
end
end

