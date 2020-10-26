function result = targetFunctionSuitcases2020(x, v, stadiums, suitcases, boxSize, suitcaseC)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
feetStadiums = [stadiums(1:2,:)*suitcaseC; stadiums(3:5,:)];
suitcaseCoord = suitcaseCoordinates2(suitcases, feetStadiums);
suitcaseCoord(:,v) = suitcaseCoordinates2([suitcases(1:2,v); x.'], feetStadiums(:,v));

nPeople = length(stadiums(1,:));
nSuitcases = length(suitcases(1,:));

result = 0;

% rectangle with other rectangles
for q = 1:nSuitcases
    if q ~= v
        result = result + rectIntersectArea(suitcaseCoord(:,v), suitcaseCoord(:,q));
    end
end

% rectangle with stadiums (excluding owner)
for q = 1:nPeople
    if q ~= v
        result = result + stadiumRectOverlapArea4(stadiums(:,q), suitcaseCoord(:,v));
    end
end

B = [boxSize(1); boxSize(2); 0; 0; 0];

% rectangle with box
result = result + 4*suitcaseCoord(1,v)*suitcaseCoord(2,v) - rectIntersectArea(suitcaseCoord(:,v), B);

end
