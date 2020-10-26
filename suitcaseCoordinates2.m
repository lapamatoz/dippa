function [out] = suitcaseCoordinates2(suitcases, stadiums)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
out = zeros(5, length(suitcases(1,:)));

out(1:2,:) = suitcases(1:2,:);

for q = 1:length(suitcases(1,:))
    rotationSt = [cos(stadiums(5,q)), -sin(stadiums(5,q)); sin(stadiums(5,q)), cos(stadiums(5,q))];
    temp = suitcaseCoordinates(suitcases(1:2,q), stadiums(:,q), suitcases(3,q), suitcases(4,q));
    out(3:5, q) = [rotationSt*temp(1:2)+[stadiums(3,q); stadiums(4,q)]; temp(3)+stadiums(5,q)]; 
end
end