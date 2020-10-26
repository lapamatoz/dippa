function interval = correlationBootstrap(x,y,n,perc)

centerOfMass = zeros(1,n);
m = length(x);

parfor b = 1:n
    
    x1 = zeros(1,m);
    y1 = zeros(1,m);
    
    for k = 1:m
        pos = randi(length(x));
        x1(k) = x(pos);
        y1(k) = y(pos);
    end
    

    centerOfMass(b) = [0,1] * corrcoef(y1,x1) * [1;0];
end

centerOfMass = sort(centerOfMass);

interval = [0,0];

ind = ceil(n*perc/2);
k1 = - 1.0*n*perc/2 + ceil(n*perc/2);

interval(1) = centerOfMass(max(ind,1))*(1-k1) + centerOfMass(max(ind-1,1))*(k1);

ind = ceil(n*(1-perc/2));
k1 = ceil(n*(1-perc/2)) - n*(1-perc/2);

interval(2) = centerOfMass(min(ind,n))*(1-k1) + centerOfMass(min(ind-1,n))*(k1);


end
