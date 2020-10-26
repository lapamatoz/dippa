function [] = drawRectangles(r,filled, fillColor, strokeColor)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
for v = 1:length(r(1,:))
    drawRectangle(r(:,v),filled, fillColor, strokeColor);
end
end