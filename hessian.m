function out = hessian(fun,x)
    len = length(x);
    x0 = [];
    out = zeros(len);
    for p = 1:len
        x0 = [x0, imagine];
        x0(p).value = [x(p) 0 0];
    end
    for p = 1:len
        x0(p).value = [x(p) 1 0];
        outTemp = fun(x0);
        out(p,p) = 2 * outTemp.value(3);
        x0(p).value = [x(p) 0 0];
    end
    for i = 1:len
        for j = i+1:len
            x0(i).value = [x(i) 1/sqrt(2) 0];
            x0(j).value = [x(j) 1/sqrt(2) 0];
            outTemp = fun(x0);
            out(i,j) = 2 * outTemp.value(3) - 1/2 * (out(i,i) + out(j,j));
            x0(i).value = [x(i) 0 0];
            x0(j).value = [x(j) 0 0];
        end
    end
    for i = 1:len
        for j = 1:i-1
            out(i,j) = out(j,i);
        end
    end
end