function [grad, f0, calculations] = triangleGrad(fun, x, h, zeroCondition)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
parallel = false;
calculations = 0;
n = length(x);
alpha = h/sqrt(2*n+2);
alphap = -alpha * (1+sqrt(n+1)) / n;
beta = h / sqrt(2);

w1 = (1 - (alpha - alphap)*(n-1) / beta) / (n*(alphap - alpha) + beta);
w = w1 - 1/beta;
w0 = - (n-1)*w - w1;
%disp(alpha)
fA = fun(x + alpha);
fB = zeros(1, n);

if parallel
    parfor p = 1:n
        e = zeros(1,n);
        e(p) = 1;
        fB(p) = fun(x + alphap + beta*e);
        calculations = calculations + 1;
        %disp(alphap + beta*e)
    end
    for p = 1:n
        if zeroCondition && fB(p) == 0
            e = zeros(1,n);
            e(p) = 1;
            f0 = 0;
            grad = x + alphap + beta*e;
            return
        end
    end
else
    for p = 1:n
        e = zeros(1,n);
        e(p) = 1;
        fB(p) = fun(x + alphap + beta*e);
        calculations = calculations + 1;
        if zeroCondition && fB(p) == 0
            f0 = 0;
            grad = x + alphap + beta*e;
            return
        end
        %disp(alphap + beta*e)
    end
end

f0 = mean([fA, fB]);

grad = w0 * fA;
E = ones(1,n);

%disp([w0 w1 w])

for p = 1:n
    e = zeros(1,n);
    e(p) = 1;
    grad = grad + fB(p) * (w1*e + w*(E - e));
end

end

