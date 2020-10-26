function [out] = lineIntersect(x1, x2, y1, y2)
%UNTITLED Summary of this function goes here
% Solves for a intersection of tx*x1 + (1-tx)*x2 and ty*y1 + (1-ty)*y2,
% where 0 <= tx <= 1, 0 <= ty <= 1.
% Returns an empty array, if no intersection point exists.
    A1x = x1(1);
    A1y = x1(2);
    B1x = x2(1);
    B1y = x2(2);
    
    A2x = y1(1);
    A2y = y1(2);
    B2x = y2(1);
    B2y = y2(2);
    
    t1 = (A2y * B1x - A2x * B1y - A2y * B2x + B1y * B2x + A2x * B2y - B1x * B2y)/(A1y * A2x - A1x * A2y + A2y * B1x - A2x * B1y - A1y * B2x + B1y * B2x + A1x * B2y - B1x * B2y);
    t2 = (A1y*B1x - A1x*B1y - A1y*B2x + B1y*B2x + A1x*B2y - B1x*B2y)/(A1y*A2x - A1x*A2y + A2y*B1x - A2x*B1y - A1y*B2x + B1y*B2x + A1x*B2y - B1x * B2y);
    
    if (t1 <= 1 && t1 >= 0 && t2 <= 1 && t2 >= 0)
        out = [A1x*t1+(1-t1)*B1x ; A1y*t1+(1-t1)*B1y];
    else
        out = [];
    end
end