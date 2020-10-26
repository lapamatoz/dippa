function [] = drawStadiums(s,filled, fillColor, strokeColor)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
for v = 1:length(s(1,:))
    drawStadium(s(:,v),filled, fillColor, strokeColor);
end
end

