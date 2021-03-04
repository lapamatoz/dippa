function [out] = inRectangle(x, s)
%   returns true, if point x is in rectangle s
p = x;
p(1) = p(1) - s(3);
p(2) = p(2) - s(4);
p = [cos(-s(5)), -sin(-s(5)); sin(-s(5)), cos(-s(5))] * p;
    
out = (p(1) <= s(1) && p(1) >= -s(1) && p(2) <= s(2) && p(2) >= -s(2));
end