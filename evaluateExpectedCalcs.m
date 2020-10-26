function minExp = evaluateExpectedCalcs(data)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
runs = length(data);
p = (0:runs) ./ runs;

calcs = sort(data(~isnan(data)));

maxNLen = length(calcs);

expTrue = zeros(maxNLen,1);

%for i = 0:10000
%	expTrue(1) = expTrue(1) + (1-p(2))^i * p(2) * calcs(1)*(i+1);
%end

for k = 1:maxNLen
    for i = 0:10000
        %cycle = floor((i-1)/(k-1));
        %ind = mod(i-1,(k-1))+2;
        cycle = floor(i/k);
        ind = mod(i,k) + 1;
        %disp([k,i,cycle, ind])
        expTrue(k) = expTrue(k) + (1-p(2))^i * p(2) * (calcs(ind) + cycle*calcs(k));
    end
end

%figure;
%plot(calcs, expTrue)

minExp = min(expTrue);
end

