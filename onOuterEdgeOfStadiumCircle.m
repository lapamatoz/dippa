function res = onOuterEdgeOfStadiumCircle(pt,s1,EF)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% E:  0
% F:  1
rotationS1 = [cos(s1(5)), -sin(s1(5)); sin(s1(5)), cos(s1(5))];
if EF
    center = [-s1(1); 0];
    stCenterToCircleCenter = rotationS1 * center;
else
    center = [s1(1); 0];
    stCenterToCircleCenter = rotationS1 * center;
end
centerToPt = pt - stCenterToCircleCenter - s1(3:4);
res = (centerToPt.'*stCenterToCircleCenter > 0);
end