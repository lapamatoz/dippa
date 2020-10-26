function out = distanceLineSegPt(A,B,C)
%UNTITLED Distance between a line segment AB and point C
%   Yeah, that's right B)
if ~iscolumn(A)
    A = A.';
end

if ~iscolumn(B)
    B = B.';
end

if ~iscolumn(C)
    C = C.';
end

q = (C-A).'*(B-A) / norm(B-A)^2;

if 0 <= q && q <= 1
    P = q*(B - A) + A;
    out = norm(P - C);
else
    out = min([norm(A-C), norm(B-C)]);
end
end

