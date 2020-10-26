function [out] = pointOnCircle(x,c,R)
% returns true, if x in on circle with centerpoint c and radius R.
if (abs((x(1)-c(1))^2 + (x(2)-c(2))^2 - R^2) < 1e-8) % taking inaccuracies into account
    out = true;
else
    out = false;
end
end