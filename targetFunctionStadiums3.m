function [out] = targetFunctionStadiums3(x, v, stadiums, types, boxSize, dist,capsuleAreas,sq)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

nPeople = length(stadiums(1,:));
out = 0;
pivotStadium = [stadiums(1:2,v); x.'];

for q = 1:nPeople
    if q ~= v
        if types(v) == "capsule" && types(q) == "capsule"
            out = out + stadiumOverlapArea4(pivotStadium, stadiums(1:5,q));
        elseif types(v) == "capsule" && types(q) == "rectangle"
            out = out + stadiumRectOverlapArea4(pivotStadium, stadiums(1:5,q));
        elseif types(v) == "rectangle" && types(q) == "capsule"
            out = out + stadiumRectOverlapArea4(stadiums(1:5,q), pivotStadium);
        elseif types(v) == "rectangle" && types(q) == "rectangle"
            out = out + rectIntersectArea(pivotStadium, stadiums(1:5,q));
        end
    end
end
    
    if dist
        % distance to other stadiums
        %out = out + 1e-2 * stadiumRepelSum(x,v,stadiums, boxSize) * boxSize(1)*boxSize(2);
    end
    
    % overlap with borders
    B = [boxSize(1); boxSize(2); 0; 0; 0];
    
    if types(v) == "capsule"
        out = out + stadiums(2,v)*(pi*stadiums(2,v) + 4*stadiums(1,v)) - stadiumRectOverlapArea4(pivotStadium, B);
    elseif types(v) == "rectangle"
        out = out + 4*stadiums(1,v)*stadiums(2,v) - rectIntersectArea(pivotStadium, B);
    end
    
    

    function out = xsq(x)
        out = (x^2 - x)*(2/((x + 1)^8 + 1)) + x;
    end
    
end