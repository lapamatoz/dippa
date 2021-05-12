disp('These should be zeros:')
x = zeros(1,6);
for q = 1:3
    x(q*2-1) = length(expectedCalculations(gradMNoLine(q))) - length( expectedCalculations(gradM(q)));
    x(q*2) = length(expectedCalculations(BFGSNoLine(q))) - length( expectedCalculations(BFGS(q)));
end
disp(x)

for q=1:3
    tmp = expectedCalculations(gradM(q));
    tmp = expectedCalculations(gradMNoLine(q)) ./ tmp(1:(end + x(q*2-1)));
    disp(1-tmp(end-1))
    tmp = expectedCalculations(BFGS(q));
    tmp = expectedCalculations(BFGSNoLine(q)) ./ tmp(1:(end + x(q*2)));
    disp(1-tmp(end-1))
end