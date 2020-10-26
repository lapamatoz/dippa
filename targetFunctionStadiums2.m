function [out] = targetFunctionStadiums2(x, v, stadiums, suitcases, boxSize, suitcaseC, dist,capsuleAreas,sq)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

feetStadiums = [stadiums(1:2,:)*suitcaseC; stadiums(3:5,:)];
suitcaseCoord = suitcaseCoordinates2(suitcases, feetStadiums);

    out = 0;
    if capsuleAreas
        % overlap with other stadiums
        out = out + stadiumOverlapAreaSum(x,v,stadiums,sq);
    end
    
    if dist
        % distance to other stadiums
        %out = out + 1e-2 * stadiumRepelSum(x,v,stadiums, boxSize) * boxSize(1)*boxSize(2);
    end
    
    % overlap with borders
    B = [boxSize(1); boxSize(2); 0; 0; 0];
    pivotStadium = [stadiums(1:2,v); x.'];
    if sq
        out = out + xsq(stadiums(2,v)*(pi*stadiums(2,v) + 4*stadiums(1,v)) - stadiumRectOverlapArea4(pivotStadium, B));
    else
        out = out + stadiums(2,v)*(pi*stadiums(2,v) + 4*stadiums(1,v)) - stadiumRectOverlapArea4(pivotStadium, B);
    end
    
    nSuitcases = length(suitcases(1,:));
    
% capsule intr. with rects
for q = 1:nSuitcases
    if q ~= v
        out = out + stadiumRectOverlapArea4(stadiums(:,v), suitcaseCoord(:,q));
    end
end

if v <= nSuitcases
    stadiums2 = stadiums;
    stadiums2(:,v) = pivotStadium;
    out = out + targetFunctionSuitcases2020(suitcases(3:4,v).', v, stadiums2, suitcases, boxSize, suitcaseC);
end

    function out = xsq(x)
        out = (x^2 - x)*(2/((x + 1)^8 + 1)) + x;
    end
    
end