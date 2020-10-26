function [x, grad, calc] = gradWithNewtonStep(fun, x0, h, h2, type, options)
%gradWithNewtonStep Does single step of gradient method with Newton-like step
limit = options('linesearchLimit'); % limit >= |x_0 - x_1|
randomTrials = options('randomTrials');
calc = 0;
if type == "double" || type == "triangle" || type == "triangleSubGrad"
    fx0 = 0;
else
    fx0 = fun(x0);
    for p = 1:randomTrials
        calc = calc + 1;
        xRand = x0 + 2*(2*rand(1,length(x0))-1)*limit;
        calc = calc + 1;
        if fun(xRand) <= fx0
            x = xRand;
            grad = NaN;
            return
        end
    end
    
    if fx0 == 0
        x = x0;
        grad = NaN;
        return
    end
    
end

if type == "triangle" || type == "triangleSubGrad"
    [grad, fx0, cTmp] = triangleGrad(fun, x0, h, true);
    calc = calc + cTmp;
    
    for p = 1:randomTrials
        calc = calc + 1;
        xRand = x0 + 2*(2*rand(1,length(x0))-1)*limit;
        calc = calc + 1;
        if fun(xRand) <= fx0
            x = xRand;
            grad = NaN;
            return
        end
    end
    
    if fx0 == 0
        x = grad; % special feature of triangleGrad
        grad = NaN;
        return
    end
else
    grad = zeros(1, length(x0));
    for p = 1:length(x0)
        diff = zeros(1, length(x0));
        diff(p) = h;
        if type == "double"
            a = fun(x0 + diff);
            if a == 0
                x = x0 + diff;
                return
            end
            calc = calc + 1;
            b = fun(x0 - diff);
            if b == 0
                x = x0 - diff;
                return
            end
            calc = calc + 1;
            fx0 = fx0 + (a+b)/(2*length(x0));
            grad(p) = (a - b)/(2*h);
        else
            value = fun(x0 + diff);
            grad(p) = (value - fx0)/h;
            calc = calc + 1;
            if value == 0
                x = x0 + diff;
                return
            end
        end
    end
end
%disp(grad)

if norm(grad) == 0
    x = x0;
    for p = 1:randomTrials
        calc = calc + 1;
        xRand = x0 + 2*(2*rand(1,length(x0))-1)*limit;
        calc = calc + 1;
        if fun(xRand) <= fx0
            x = xRand;
            grad = NaN;
            return
        end
    end
    return
end

if type == "triangleSubGrad" || type == "subgrad"
    %x = x0 - h2 * grad / max(norm(grad),1);
    x = x0 - limit * grad / norm(grad);
    return
end

fh = fun(x0 - h2 * grad / norm(grad));
calc = calc + 1;
if fh == 0
    x = x0 - h2 * grad / norm(grad);
    return
end

dg = -norm(grad);
d2g = 2 * (fh - fx0 - dg * h2) / h2^2;

if dg^2 - 2 * d2g * fx0 >= 0
    alphaZeros = [(-dg + sqrt(dg^2 - 2 * d2g * fx0))/d2g,...
                  (-dg - sqrt(dg^2 - 2 * d2g * fx0))/d2g];
    %disp(alphaZeros)
    alphaZeros = alphaZeros(alphaZeros > 0);
    alphaZeros = min(alphaZeros);
    if alphaZeros < limit && sum(isreal(alphaZeros)) == 1
        %disp('Zero')
        x = x0 - grad / norm(grad) * alphaZeros;
        if rand() < options('accelerationProbability')
            x = x0 - 2 * grad / norm(grad) * alphaZeros;
        end
        return
    end
end

%disp(gder2)

if d2g > 0
    alpha = 1 * 1/2 * h2^2 / (-dg * h2 - fx0 + fh);
    if norm(alpha * grad) > limit
        alpha = limit / norm(grad);
    end
    x = x0 - alpha * grad;
    %calc = calc + 1;
    %k = 0;
    %while fun(x) > fx0 && k<20
    %    alpha = alpha * 0.75;
    %    x = x0 - alpha * grad;
    %    calc = calc + 1;
    %    k = k+1;
    %end
else
    alpha = limit / norm(grad);
    x = x0 - alpha * grad;
    %calc = calc + 1;
    %k = 0;
    %while fun(x) > fx0 && k<20
    %    alpha = alpha * 0.75;
    %    x = x0 - alpha * grad;
    %    calc = calc + 1;
    %    k = k+1;
    %end
end

if rand() < options('accelerationProbability')
    x = x0 - 2 * alpha * grad;
end

end

