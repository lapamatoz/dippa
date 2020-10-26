function PlotQ(stadiums, boxSize)
limit = 5000;
%p = zeros(length(limits),1);
trials = 20;
%for k = 1:length(limits)
calculations = probabilityOfSuccess(stadiums, boxSize, trials, limit);
%if sum(isinf(calculations)) == 0
%    calculations = [calculations; Inf];
%    trials = trials + 1;
%end
calculations = sort(calculations);
calculations = [0; calculations];
p = (0:trials) ./ trials;
trials = trials + 1;

infs = sum(isinf(calculations));
calculations = calculations(1:(end-infs));
p = p(1:(end-infs));
p = [p, p(end)];
calculations = [calculations; limit];

%    if p(k) == 1
%        p(k) = 1 - 1/trials;
%    end
%end

plot(calculations,p,'r')
hold on

q = zeros(length(calculations),1);
ci = zeros(length(calculations),1);
ui = zeros(length(calculations),1);
li = zeros(length(calculations),1);
expT = zeros(length(calculations),1);
expT2 = zeros(length(calculations),1);
expTrue = zeros(length(calculations),1);
for k = 1:length(calculations)
    q(k) = 1-(1-p(k))^(1/calculations(k));
    expT(k) = calculations(k)*p(k) * (1 - (-1+p(k))*(p(k)+1) / p(k)^2);
    expT2(k) = calculations(k) * (1 - p(k)) / p(k);
    if k > 1
        for i = 1:300
            cycle = floor((i-1)/(k-1));
            ind = mod(i-1,(k-1))+2;
            expTrue(k) = expTrue(k) + (1-p(k))^cycle * (p(ind) - p(ind-1)) * (calculations(ind) + cycle*calculations(k));
        end
    end
    ci(k) = 1.96 * sqrt(p(k)*(1-p(k)) / (trials-k+1));
    ui(k) = 1-(min(1,max(0, 1-p(k)-ci(k) )))^(1/calculations(k));
    li(k) = 1-(min(1,max(0, 1-p(k)+ci(k) )))^(1/calculations(k));
end
expTrue(1) = NaN;
plot(calculations,min(1,max(0,p+ci.')),['r',':'])
plot(calculations,min(1,max(0,p-ci.')),['r',':'])

plot(calculations,q,'k')
plot(calculations,ui,['k',':'])
plot(calculations,li,['k',':'])

%disp(expT)

plot(calculations,expT,'b')
plot(calculations,expT2,'b')
plot(calculations,expTrue,'m')

end