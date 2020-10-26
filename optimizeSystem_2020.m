function [stadiums, suitcases, value, calculationTotal] = optimizeSystem_2020(stadiums,suitcases,suitcaseC,calculationLimit,draw,videoFile,boxSize)
% based on descentSpeedRunCyclic3
%rng(seed);
sq = false;

nPeople = length(stadiums(1,:));
nSuitcases = length(suitcases(1,:));

cycle = randperm(nPeople + nSuitcases);

funVals = zeros(1,nPeople);

%gradStats = zeros(3,steps);
k=0;
calculationTotal = 0;
while calculationTotal <= calculationLimit
    k = k+1;
    if draw && mod(k,ceil(nPeople/4)) == 0
        close all
        drawLiftSetup(stadiums,suitcases,suitcaseC,boxSize,0, false, 1);
        axis([-boxSize(1) boxSize(1) -boxSize(2) boxSize(2)]*1.4)
        set(gca,'nextplot','replacechildren');
        frame = getframe(gcf);
        writeVideo(videoFile,frame);
    end
    
    %feetStadiums = [stadiums(1:2,:)*suitcaseC; stadiums(3:5,:)];
    %suitcaseCoord = suitcaseCoordinates2(suitcases, feetStadiums);
    %h = 4e-2/k^0.5;
    
    for v = 1:nPeople
    	funVals(v) = targetFunctionStadiums2(stadiums(3:5,v).', v, stadiums, suitcases, boxSize, suitcaseC, false, true, sq);
    end
    for v = 1:nSuitcases
        funVals(1) = funVals(1) + targetFunctionSuitcases2020(suitcases(3:4,v).', v, stadiums, suitcases, boxSize, suitcaseC);
    end
    value = sum(funVals);
    if value <= 4*nPeople
        return
    end
    
    q = mod(k,nPeople + nSuitcases)+1;
    q = cycle(q);
    optimizeSuitcase = q > nPeople;
    
    if ~optimizeSuitcase
        weights = capsuleWeights(stadiums, q);

        initialX = stadiums(3:5,q).';
        initialX = initialX .* weights;
        if true
            [s, gradW, calcTmp] = gradWithNewtonStep(@(x)targetFunctionStadiums2(x ./ weights, q, stadiums, suitcases, boxSize, suitcaseC, true, true, sq), initialX, 1e-4, 1e10, 'triangleSubGrad');
        else
            [s, gradW, calcTmp] = gradWithNewtonStep(@(x)targetFunctionStadiums2(x ./ weights, q, stadiums, suitcases, boxSize, suitcaseC, true, true, sq), initialX, 1e-4, 1e-3, 'triangle');
        end
        calculationTotal = calculationTotal + calcTmp;
        %gradStats(:,k) = gradWeight;
        % 5h, 250h
        stadiums(3:5,q) = s.';
        

        if norm(stadiums(3:5,q) - initialX.') > 0 && sum(isnan(gradW)) == 0
            stadiums(3:5,q) = initialX.' - 0.00001 * gradW.';
            %disp('yli')
        else
            stadiums(3:5,q) = initialX.';
            %stadiums(3:5,q) = initialX.' - 0.9 * (initialX.' - stadiums(3:5,q));
        end
        stadiums(3:5,q) = stadiums(3:5,q) ./ weights.';
        stadiums = containCapsulesInBox(stadiums, boxSize);
    else
        q = q - nPeople;
        weights = [1,1];
        initialX = suitcases(3:4, q).';
        initialX = initialX .* weights;
        if k < 5*nPeople
            [s, ~, calcTmp] = gradWithNewtonStep(@(x)targetFunctionSuitcases2020(x ./ weights, q, stadiums, suitcases, boxSize, suitcaseC), initialX, 1e-4, 1e10, 'triangleSubGrad');
        else
            [s, ~, calcTmp] = gradWithNewtonStep(@(x)targetFunctionSuitcases2020(x ./ weights, q, stadiums, suitcases, boxSize, suitcaseC), initialX, 1e-4, 1e-3, 'triangle');
        end
        calculationTotal = calculationTotal + calcTmp;
        suitcases(3:4,q) = s.';
        if norm(suitcases(3:4,q) - initialX.') > 0.2
            suitcases(3:4,q) = initialX.' + 0.2 * (suitcases(3:4,q) - initialX.') / norm(suitcases(3:4,q) - initialX.');
        end
        suitcases(3:4,q) = suitcases(3:4,q) ./ weights.';
        suitcases = containSuitcases(suitcases);
end



if false
    drawLiftSetup(stadiums,suitcases,suitcaseC,boxSize,0, false, 1);
    figure;
    histogram(abs(gradStats(1,:) ./ vecnorm(gradStats)) - abs(gradStats(2,:) ./ vecnorm(gradStats)));
    title('x')
    figure;
    histogram(abs(gradStats(2,:) ./ vecnorm(gradStats)) - abs(gradStats(3,:) ./ vecnorm(gradStats)));
    title('y')
    figure;
    histogram(abs(gradStats(3,:) ./ vecnorm(gradStats)) - abs(gradStats(1,:) ./ vecnorm(gradStats)));
    title('theta')   
    
end

end