function out = derivative(fun,x)
    x0 = imagine;
    x0.value = [x,1];
    out = fun(x0);
    out = out.value(2);
end