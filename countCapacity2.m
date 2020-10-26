function res2 = countCapacity2(calculationLimit,runs,video)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

res = {};
box = [4,4];
if video ~= "video"
    for r = 1:runs
        P = elevatorProblem;
        P = P.createBox(box);
        %calculationLimit = 1000;
        area = 0;
        n = 0;
        while area == 0
            %Pold = P;
            %P.calculations = 0;
            P = P.addShape(createRandomShape(P.box));
            n = n+1;
            if P.impossible()
                disp("Impossible")
                break;
            end
            iter = 0;
            previousMinFunValue = Inf;
            objFunValue = Inf;
            while P.calculations < calculationLimit && P.objectiveFunctionAll(NaN, true)
                if mod(iter, 3*n) == 0
                    if objFunValue >= previousMinFunValue
                        disp("Objective is not descending");
                        break
                    end
                    previousMinFunValue = objFunValue;
                    objFunValue = Inf;
                end
                if iter < 10*n+3
                    P = P.optimizeCyclic("triangleSubGrad");
                else
                    P = P.optimizeCyclic("triangle");
                end
                iter = iter+1;
                objFunValue = min([objFunValue, P.objectiveFunctionAll(NaN, false)]);
            end
            P.objectiveFunctionAll(NaN, true)
            
            if P.objectiveFunctionAll(NaN, true)
                %disp(length(P.shapes)-1)
                %res(r,:) = [length(P.shapes)-1, P.calculations];
                break;
            else
                res{r}{length(P.shapes)} = P.calculations;
            end
        end

    end
    lenRes = length(res);
    maxN = 0;

    for q = 1:lenRes
        maxN = max(maxN, length(res{q}));
    end

    res2 = zeros(runs, maxN)*NaN;

    for q = 1:runs
        lenR = length(res{q});
        for w = 1:lenR
            res2(q,w) = res{q}{w};
        end
    end

    res2 = res2.';

    figure;
    hold on
    for p = 1:maxN
        lenR = length(res2(p,:));
        plot(p*ones(1,lenR), res2(p,:), ['k','*'])
        plot(p, evaluateExpectedCalcs(res2(p,:)), ['b', 'o'])
    end
end

if video == "video"
    videoFile = VideoWriter('elokuva.avi');
    open(videoFile);
    
    P = elevatorProblem;
    P = P.createBox(box);
    %calculationLimit = 1000;
    area = 0;
    n = 0;
    while area == 0
        %Pold = P;
        %P.calculations = 0;
        P = P.addShape(createRandomShape(P.box));
        n = n+1;
        if P.impossible()
            disp("Impossible")
            break;
        end
        iter = 0;
        previousMinFunValue = Inf;
        objFunValue = Inf;
        while P.calculations < calculationLimit && P.objectiveFunctionAll(NaN, true)
            if mod(iter, 3*n) == 0
                if objFunValue > previousMinFunValue && iter > 11*n+3
                    disp("Objective is not descending");
                    break
                end
                previousMinFunValue = objFunValue;
                objFunValue = Inf;
            end
            if iter < 10*n+3
                P = P.optimizeCyclic("triangleSubGrad");
            else
                P = P.optimizeCyclic("triangle");
            end
            iter = iter+1;
            objFunValue = min([objFunValue, P.objectiveFunctionAll(NaN, false)]);
            close all
            P.drawProblem;
            axis([-box(1) box(1) -box(2) box(2)]*0.8)
            set(gca,'nextplot','replacechildren');
            frame = getframe(gcf);
            writeVideo(videoFile,frame);
        end
        if P.objectiveFunctionAll(NaN, true)
            break;
        else
        end
    end
    close(videoFile);
    res2 = 0;
end

end

