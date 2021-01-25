function out = gradient(fun,x)
    len = length(x);
    x0 = [];
    out = zeros(1,len);
    for p = 1:len
        x0 = [x0, imagine];
        x0(p).value = [x(p), 0];
    end
    for p = 1:len
        x0(p).value = [x(p), 1];
        outTemp = fun(x0);
        out(p) = outTemp.value(2);
        x0(p).value = [x(p), 0];
    end
end