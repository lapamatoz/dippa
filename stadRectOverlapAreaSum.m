function [out] = stadRectOverlapAreaSum(x,stadiumSize,rectangles,suitcaseC)
%UNTITLED8 Summary of this function goes here
%   x as a vertical
out = 0;
pivotStadium = [stadiumSize; x.'];
pivotStadium = [pivotStadium(1:2,:)*suitcaseC; pivotStadium(3:5,:)];

for q = 1:length(rectangles(1,:))
	out = out + stadiumRectOverlapArea3(pivotStadium, rectangles(:,q));
end

end