function [stadiums] = shakeStadiums3(stadiums, boxSize)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
nPeople = length(stadiums(1,:));

coordinates = [];
u = nPeople - 3;

while isempty(coordinates) && u < nPeople + 3
	coordinates = goldenTryPetals(u,nPeople,boxSize);
    u = u + 0.1;
end

if u > nPeople + 3
    disp('Golden petals meni pieleen')
end

stadiums(3:5,:) = coordinates(:,1:nPeople);
rp = randperm(nPeople);
stadiums(3:5,:) = stadiums(3:5, rp);
%stadiums(5,:) = pi*rand(1,nPeople);

end

