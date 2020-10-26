function [out] = rectStadOverlapAreaSum(x,rectSize,pivotStadiums,rectIndex,overlapStadiums,same)
%UNTITLED8 Summary of this function goes here
%   x as a vertical
out = 0;
pivotRect = [rectSize; x.'];
rect = suitcaseCoordinates2(pivotRect, pivotStadiums(:,rectIndex));

%for q = 1:length(stadiums(1,:))
%	out = out + stadiumRectOverlapArea(stadiums(:,q), rect)^2;
%end

if same == true

    if rectIndex > 2
        for q = 1:rectIndex-1
            out = out + stadiumRectOverlapArea3(overlapStadiums(:,q), rect);
        end
    end

    if rectIndex ~= length(overlapStadiums(1,:))
        for q = rectIndex+1:length(overlapStadiums(1,:))
            out = out + stadiumRectOverlapArea3(overlapStadiums(:,q), rect);
        end
    end

else
    
	for q = 1:length(overlapStadiums(1,:))
        out = out + stadiumRectOverlapArea3(overlapStadiums(:,q), rect);
    end
    
end

end