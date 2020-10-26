function [x0, funx0, grad] = gradientCapsule(v, h, stadiums, suitcaseCoord, boxSize, suitcaseC)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
grad = zeros(1,3);
dist = true;
fun = @(x)targetFunctionStadiums2(x, v, stadiums, suitcaseCoord, boxSize, suitcaseC,dist,true,false);
x0 = double(stadiums(3:5, v).');
%funx0 = fun(x0);

%h = [0,0,0];
%h(1) = h1 * max(2.10734e-08 * x0(1),1e-8);
%grad(1) = (fun(x0 + [h 0 0]) - funx0)/h;
fun1 = fun(x0 + [h 0 0]);
fun2 = fun(x0 - [h 0 0]);
grad(1) = (fun1 - fun2)/(2*h);
funx0 = fun1/6 + fun2/6;
%h(2) = h1 * max(2.10734e-08 * x0(2),1e-8);
%grad(2) = (fun(x0 + [0 h 0]) - funx0)/h;
fun1 = fun(x0 + [0 h 0]);
fun2 = fun(x0 - [0 h 0]);
grad(2) = (fun1 - fun2)/(2*h);
funx0 = funx0 + fun1/6 + fun2/6;
%h(3) = h1 * max(2.10734e-08 * x0(3),1e-8);
%grad(3) = (fun(x0 + [0 0 h]) - funx0)/h;
fun1 = fun(x0 + [0 0 h]);
fun2 = fun(x0 - [0 0 h]);
grad(3) = (fun1 - fun2)/(2*h);
funx0 = funx0 + fun1/6 + fun2/6;


%if min(grad) == 0 && funx0 ~= 0
%    disp('h liian pieni')
%end
end

