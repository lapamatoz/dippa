function out = segmentArea(A,B,R) 
% A and B are given as [x;y]-coordinates.
% http://mathworld.wolfram.com/CircularSegment.html
d = norm(A-B);
q = asin(min(d/(2*R),1));
out = 1/2 * R^2 * (2*q - sin(2*q));
end

