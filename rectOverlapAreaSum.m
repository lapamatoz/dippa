function [out] = rectOverlapAreaSum(x,rectSize,pivotStadiums,rectIndex,overlapRectangles)
%UNTITLED8 Summary of this function goes here
%   x as a vertical
out = 0;
pivotRect = [rectSize; x.'];
rect = suitcaseCoordinates2(pivotRect, pivotStadiums(:,rectIndex));

otherRectangles = suitcaseCoordinates2(overlapRectangles, pivotStadiums);

%for q = 1:length(stadiums(1,:))
%	out = out + stadiumRectOverlapArea(stadiums(:,q), rect)^2;
%end


    if rectIndex > 2
        for q = 1:rectIndex-1
            out = out + rectIntersectArea(otherRectangles(:,q), rect)^2;
        end
    end

    if rectIndex ~= length(overlapRectangles(1,:))
        for q = rectIndex+1:length(overlapRectangles(1,:))
            out = out + rectIntersectArea(otherRectangles(:,q), rect)^2;
        end
    end

end