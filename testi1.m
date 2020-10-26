p = (1:runs) ./ runs;

calcs = sort(res2(maxN,~isnan(res2(maxN,:))));

maxNLen = length(calcs);

expTrue = zeros(maxNLen,1);

for i = 0:10000
	expTrue(1) = expTrue(1) + (1-p(1))^i * p(1) * calcs(1)*(i+1);
end

for k = 2:maxNLen
    for i = 1:10000
        cycle = floor((i-1)/(k-1));
        ind = mod(i-1,(k-1))+2;
        %disp([cycle, ind])
        expTrue(k) = expTrue(k) + (1-p(k))^cycle * (p(ind) - p(ind-1)) * (calcs(ind) + cycle*calcs(k));
    end
end

figure;
plot(calcs, expTrue)

min(expTrue)