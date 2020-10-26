function [stadiums, value, calculationTotal] = optimizeSystem_2020(stadiums, types, calculationLimit,draw,videoFile,boxSize)
% based on descentSpeedRunCyclic3
% optimize different shapes with names
%rng(seed);
sq = false;

nPeople = length(stadiums(1,:));

cycle = randperm(nPeople);

funVals = zeros(1,nPeople);

%gradStats = zeros(3,steps);
k=0;
calculationTotal = 0;
while calculationTotal <= calculationLimit
    k = k+1;
    if draw && mod(k,ceil(nPeople/3)) == 0
        close all
        drawLiftSetup_2020(stadiums,types,boxSize, false, 1);
        axis([-boxSize(1) boxSize(1) -boxSize(2) boxSize(2)]*1.4)
        set(gca,'nextplot','replacechildren');
        frame = getframe(gcf);
        writeVideo(videoFile,frame);
    end
    
    %feetStadiums = [stadiums(1:2,:)*suitcaseC; stadiums(3:5,:)];
    %suitcaseCoord = suitcaseCoordinates2(suitcases, feetStadiums);
    %h = 4e-2/k^0.5;
    
    for v = 1:nPeople
    	funVals(v) = targetFunctionStadiums3(stadiums(3:5,v).', v, stadiums,types, boxSize, false, true, sq);
    end
    value = sum(funVals);
    if value <= 4*nPeople
        return
    end
    
    q = mod(k,nPeople)+1;
    q = cycle(q);
    %disp(q)
    
    weights = capsuleWeights(stadiums, q);

    initialX = stadiums(3:5,q).';
    initialX = initialX .* weights;
    if k < 5*nPeople
        [s, gradW, calcTmp] = gradWithNewtonStep(@(x)targetFunctionStadiums3(x ./ weights, q, stadiums,types, boxSize, true, true, sq), initialX, 1e-4, 1e9, 'triangleSubGrad');
    else
        [s, gradW, calcTmp] = gradWithNewtonStep(@(x)targetFunctionStadiums3(x ./ weights, q, stadiums,types, boxSize, true, true, sq), initialX, 1e-4, 1e-3, 'triangle');
    end
    calculationTotal = calculationTotal + calcTmp;
    %gradStats(:,k) = gradWeight;
    % 5h, 250h
    stadiums(3:5,q) = s.';


    if norm(stadiums(3:5,q) - initialX.') > 0.5
        stadiums(3:5,q) = initialX.' + 0.5 * (stadiums(3:5,q) - initialX.') / norm(stadiums(3:5,q) - initialX.') ;
        %disp('yli')
    else
        %stadiums(3:5,q) = initialX.';
        %stadiums(3:5,q) = initialX.' - 0.9 * (initialX.' - stadiums(3:5,q));
    end
    stadiums(3:5,q) = stadiums(3:5,q) ./ weights.';
    stadiums = containCapsulesInBox(stadiums, boxSize);
end



if false
    drawLiftSetup_2020(stadiums,types,boxSize,0, false, 1);
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