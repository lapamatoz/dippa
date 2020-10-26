function [P] = arcCenter2(A,B,C,capsuleCenter)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

if norm((A+B)/2-C) < 1e-3*norm(A-B)
    P = capsuleCenter + (norm(capsuleCenter - C) + norm(A-C))*(C-capsuleCenter)./norm(C-capsuleCenter);
else
    cd = (A+B)./2 - C;
    ca = A-C;
    P = C + cd / sqrt(cd(1)^2 + cd(2)^2) * sqrt(ca(1)^2 + ca(2)^2);
end

end