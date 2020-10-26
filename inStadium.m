function [out] = inStadium(x, s)
%   returns true, if point x is in stadium s

%if insideStadium(x, s)
%    out = true;
%    return
%end

p = x;
p(1) = p(1) - s(3);
p(2) = p(2) - s(4);
p = [cos(-s(5)), -sin(-s(5)); sin(-s(5)), cos(-s(5))] * p;

if (p(1) <= s(1) && p(1) >= -s(1) && p(2) <= s(2) && p(2) >= -s(2))
    out = true;
elseif ((p(1) - s(1))^2 + p(2)^2 <= s(2)^2)
        out = true;
elseif ((p(1) + s(1))^2 + p(2)^2 <= s(2)^2)
        out = true;
else
        out = false;
end
end