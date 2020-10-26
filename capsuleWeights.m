function weights = capsuleWeights(stadiums, q)
    negativeRotMat = [cos(-stadiums(5,q)), -sin(-stadiums(5,q)); sin(-stadiums(5,q)), cos(-stadiums(5,q))];
    e1y = negativeRotMat * [1; 0];
    e1y = e1y(2);
    e2y = negativeRotMat * [0; 1];
    e2y = e2y(2);
    a = stadiums(1,q)*2;
    r = stadiums(2,q);
    weights = [abs(a*e1y) + 2*r, abs(a*e2y) + 2*r, a*(r+a/4)];
    weights = weights / weights(3); % onko pakollinen?
    
    %weights = [1,1,a]; % this works pretty well
end

