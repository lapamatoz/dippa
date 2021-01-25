classdef imagine
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        value
    end
    
    methods
        function obj = plus(a,b)
            %UNTITLED Construct an instance of this class
            %   Detailed explanation goes here
            obj = imagine;
            obj.value = a.value + b.value;
        end
        
        function obj = minus(a,b)
            obj = imagine;
            obj.value = a.value - b.value;
        end
        
        function obj = uminus(a)
            obj = imagine;
            obj.value = -a.value;
        end
        
        function A = imagine2matrix(a)
            d = length(a.value);
            A = toeplitz([zeros(1,d-1), a.value]);
            A = A(1:d,d:end);
        end
        
        function obj = log(a)
            obj = matrix2imagine(logm(imagine2matrix(a)));
        end
        
        function obj = exponent(a,b)
            obj = exp(b*log(a));
        end
        
        function obj = exp2(a)
            d = length(a.value);
            obj = imagine;
            const = imagine;
            obj.value = [1, zeros(1,d-1)];
            product = imagine;
            product.value = a.value;
            for p=1:300
                const.value = [1/factorial(p), zeros(1,d-1)];
                obj = obj + const * product;
                product = product * a;
            end
        end
        
        function obj = exp(a)
            d = length(a.value);
            obj = imagine;
            obj.value = [1, zeros(1,d-1)];
            g = imagine;
            g.value = [1, zeros(1,d-1)];
            ader = imagine;
            ader.value = (1:d).*[a.value(2:end), 0];
            gder = imagine;
            for p = 1:d
                obj.value(p) = g.value(1)/factorial(p-1);
                gder.value = (1:d).*[g.value(2:end), 0];
                g = (ader*g + gder);
                %g.value = g.value;
                %disp(g)
            end
            obj.value = obj.value * exp(a.value(1));
        end
        
        function obj = sin(a)
            d = length(a.value);
            obj = imagine;
            const = imagine;
            obj.value = [0, zeros(1,d-1)];
            product = imagine;
            product.value = a.value;
            for p=0:300
                const.value = [(-1)^(p)/factorial(2*p+1), zeros(1,d-1)];
                obj = obj + const * product;
                product = product * a;
                product = product * a;
            end
        end
        
        function obj = cos(a)
            d = length(a.value);
            obj = imagine;
            const = imagine;
            obj.value = [1, zeros(1,d-1)];
            product = a*a;
            for p=1:300
                const.value = [(-1)^(p)/factorial(2*p), zeros(1,d-1)];
                obj = obj + const * product;
                product = product * a;
                product = product * a;
            end
        end
        
        function out = derivative(fun,x)
            x0 = imagine;
            x0.value = [x,1];
            out = fun(x0);
            out = out.value(2);
        end
        
        function obj = mrdivide(a,b)
            d = length(a.value);
            obj = imagine;
            obj.value = [1, zeros(1,d-1)];
            one = imagine;
            one.value = [1, zeros(1,d-1)];
            product = one - b;
            for p=1:300
                obj = obj + product;
                product = product * (one - b);
            end
            obj = a*obj;
        end
        
        function out = mtimes(a,b)
            out = imagine;
            out.value = arrayfun(@(n) sum(a.value(n+1:-1:1).*b.value(1:n+1)), 0:length(a.value)-1);
        end
        
        function out = mtimes2(a,b)
            d = length(a.value);
            out = imagine;
            out.value = zeros(1,d);
            for p = 0:length(a.value)-1
                for q = 0:length(a.value)-1-p
                    out.value(p+q+1) = out.value(p+q+1) + a.value(p+1) * b.value(q+1);
                end
            end
        end
        
        function out = mtimesCut(a,b)
            d = 100;
            out = imagine;
            out.value = zeros(1,d);
            for p = 0:length(a.value)-1
                for q = 0:length(a.value)-1
                    l = mod(p+q, 2*(d));
                    if l <= d
                        out.value(mod(p+q, d)+1) = out.value(mod(p+q, d)+1) + a.value(p+1) * b.value(q+1);
                    else
                        out.value(mod(p+q, d)+1) = out.value(mod(p+q, d)+1) - a.value(p+1) * b.value(q+1);
                    end
                end
            end
            out.value = out.value(1:length(a.value));
        end
        
        
        function out = mtimesCyc(a,b)
            d = length(a.value);
            out = imagine;
            out.value = zeros(1,d);
            for p = 0:d-1
                for q = 0:d-1
                    l = mod(p+q, 2*(d));
                    if l <= d
                        out.value(mod(p+q, d)+1) = out.value(mod(p+q, d)+1) + a.value(p+1) * b.value(q+1);
                    else
                        out.value(mod(p+q, d)+1) = out.value(mod(p+q, d)+1) - a.value(p+1) * b.value(q+1);
                    end
                end
            end
        end
    end
end

