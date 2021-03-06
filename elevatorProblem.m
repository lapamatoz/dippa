classdef elevatorProblem
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        shapes = {}
        box
        data = containers.Map
        calculations = 0
    end
    
    methods
        function obj = addShape(obj,shape)
            ls = length(shape);
            lo = length(obj.shapes);
            for w = 1:ls
                obj.shapes{lo+w} = shape(w);
            end
        end
        
        function obj = positionShape(obj, type, q)
            if isnan(q)
                q = length(obj.shapes);
            end
            B = obj.box;
            if type == "atDoor" && isa(obj.shapes{q}, "shape")
                obj.shapes{q}.position = [(2*rand()-1) * B.width/2, B.height/2];
                obj.shapes{q}.theta = rand()*2*pi;
            elseif type == "atDoor" && isa(obj.shapes{q}, "capsRect")
                obj.shapes{q}.capsule.position = [(2*rand()-1) * B.width/2, B.height/2];
                obj.shapes{q}.capsule.theta = rand()*2*pi;
            elseif type == "anywhere" && isa(obj.shapes{q}, "shape")
                obj.shapes{q}.position = [(2*rand()-1) * B.width/2, (2*rand()-1) * B.height/2];
                obj.shapes{q}.theta = rand()*2*pi;
            elseif type == "anywhere" && isa(obj.shapes{q}, "capsRect")
                obj.shapes{q}.capsule.position = [(2*rand()-1) * B.width/2, (2*rand()-1) * B.height/2];
                obj.shapes{q}.capsule.theta = rand()*2*pi;
            end
        end
        
        function obj = createBox(obj,dimensions)
            obj.box = shape;
            obj.box.position = [0;0];
            obj.box.theta = 0;
            obj.box.height = dimensions(1);
            obj.box.width = dimensions(2);
            obj.box.type = "rectangle";
        end
        
        function res = impossible(obj)
            n = length(obj.shapes);
            shapeAreas = 0;
            for v = 1:n
                shapeAreas = shapeAreas + obj.shapes{v}.shapeArea();
            end
            res = (shapeAreas > obj.box.shapeArea());
        end
        
        function out = objectiveFunctionShapeWise(obj, x, q, problem)
            if isa(obj.shapes{q}, "shape")
                obj.shapes{q}.position = x(1:2);
                obj.shapes{q}.theta = x(3);
            elseif isa(obj.shapes{q}, "capsRect")
                obj.shapes{q}.capsule.position = x(1:2);
                obj.shapes{q}.capsule.theta = x(3);
                obj.shapes{q}.rectangle.position = x(4:5);
            end
            
            n = length(obj.shapes);
            out = 0;
            for v = 1:n
                if v ~= q
                    if problem("squared") == "individual"
                        out = out + obj.shapes{v}.intersectArea(obj.shapes{q}, problem("allowDist"))^2;
                    else
                        out = out + obj.shapes{v}.intersectArea(obj.shapes{q}, problem("allowDist"));
                    end
                end
            end
            areaOutsideTheBox = obj.shapes{q}.shapeArea - obj.shapes{q}.intersectArea(obj.box, "no");
            
            if abs(areaOutsideTheBox) / obj.shapes{q}.shapeArea < 1e-7
                areaOutsideTheBox = 0;
            end
            
            if problem("squared") == "individual"
                out = out + areaOutsideTheBox^2;
            elseif problem("squared") == "whole"
                out = (out + areaOutsideTheBox)^2;
            else
                out = out + areaOutsideTheBox;
            end
        end
        
        function [out, obj] = fullGradient(obj, problem)
            % returns gradient of the problem
            n = length(obj.shapes);
            objShapes = obj.shapes;
            fun = @(x,q,weights,p)obj.objectiveFunctionShapeWise(x./weights, q, p);
            objCalculations = obj.calculations;
            
            grads = {};
            
            parfor q = 1:n
                weights = objShapes{q}.weights();
                if isa(objShapes{q},"shape")
                    initialX = objShapes{q}.legacyCoordinates();
                    initialX = (initialX(3:5).') .* weights;
                
                    [grad, f0, calcTmp] = triangleGrad(@(x)fun(x,q,weights,problem), initialX, 1e-4, true);
                    objCalculations = objCalculations + calcTmp * numofcalc(obj,q,"objectWise");
                    grads{q} = grad; % joku kerroin ???
                    
                    if f0 == 0
                        grad = grad ./ weights;
                        objShapes{q}.position = grad(1:2);
                        objShapes{q}.theta = grad(3);
                        grads{q} = [0;0;0];
                    end
                    %ind = ind + 3;
                else
                    initialX = objShapes{q}.capsule.legacyCoordinates();
                    initialX = [initialX(3:5);...
                        objShapes{q}.rectangle.position(1);...
                        objShapes{q}.rectangle.position(2)];
                    initialX = (initialX.') .* weights;
                
                    [grad, f0, calcTmp] = triangleGrad(@(x)fun(x,q,weights,problem), initialX, 1e-4, true);
                    objCalculations = objCalculations + calcTmp * numofcalc(obj,q,"objectWise");
                    
                    grads{q} = grad; % joku kerroin ???
                
                    if f0 == 0
                        grad = grad ./ weights;
                        objShapes{q}.capsule.position = grad(1:2);
                        objShapes{q}.capsule.theta = grad(3);
                        objShapes{q}.rectangle.position = grad(4:5);
                        grads{q} = [0;0;0;0;0];
                    end
                    %ind = ind + 5;
                end
            end
            
            out = obj.decisionVariablesFromProblem * 0;
            
            ind = 1;
            for q = 1:n
                if isa(objShapes{q},"shape")
                    out(ind:(ind+2)) = grads{q};
                    ind = ind+3;
                else
                    out(ind:(ind+4)) = grads{q};
                    ind = ind+5;
                end
            end
            
            obj.shapes = objShapes;
            obj.calculations = objCalculations;
        end
        
        function obj = optimizeBFGS(obj,problem) % vanha versio
            n = length(obj.shapes);
            x = decisionVariablesFromProblem(obj);
            %disp(x);
            try
                H = obj.data("HessianInv");
                gOld = obj.data("previousGrad");
                xOld = obj.data("previousPt");
            catch
                H = eye(length(x));
                gOld = rand(length(x),1)*0.0001;
                xOld = x + rand(length(x),1)*0.1;
            end
            if length(H) ~= length(x)
                H = eye(length(x));
                gOld = rand(length(x),1)*0.0001;
                xOld = x + rand(length(x),1)*0.1;
            end
            [grad, obj] = fullGradient(obj,problem);
            obj.data('previousPt') = x;
            obj.data('previousGrad') = grad;
            s = x - xOld;
            y = grad - gOld;
            %disp(H)
            denominator = s.'*y;
            if abs(denominator) > 1e-4
                H = H + (s.'*y + y.'*H*y)*(s*s.')/(denominator)^2 - (H*y*s.' + s*y.'*H)/denominator;
            end
            obj.data('HessianInv') = H;
            H1g = H*grad; %H2g = H*H*grad; H3g=H*H*H*grad;
            fun = @(alpha)objectiveFunctionAll(obj, x - H1g*alpha, false, problem);
            options = optimset('Display','off','MaxIter',6,'TolX',1e-4);
            [a,fa,~,out1] = fminbnd(fun,0.1,1.4,options);
            
            fun = @(alpha)objectiveFunctionAll(obj, x - alpha*grad, false, problem);
            limit = 0.5;
            options = optimset('Display','off','MaxIter',4,'TolX',1e-4);
            [aG,fG,~,out2] = fminbnd(fun,0,2*limit,options);
            if fa < fG
                x = x - H1g*a;
                obj.calculations = obj.calculations + out1.funcCount * numofcalc(obj,NaN,"allCombOfTwo");
                %disp('hessian')
            else
                x = x - aG*grad;
                obj.calculations = obj.calculations + out2.funcCount * numofcalc(obj,NaN,"allCombOfTwo");
                %disp('grad')
            end
            obj = obj.decisionVariablesToProblem(x);
        end
        
        % Line search not timed
        function obj = optimizeBFGSNoLine(obj,problem) % vanha versio
            n = length(obj.shapes);
            x = decisionVariablesFromProblem(obj);
            %disp(x);
            try
                H = obj.data("HessianInv");
                gOld = obj.data("previousGrad");
                xOld = obj.data("previousPt");
            catch
                H = eye(length(x));
                gOld = rand(length(x),1)*0.0001;
                xOld = x + rand(length(x),1)*0.1;
            end
            if length(H) ~= length(x)
                H = eye(length(x));
                gOld = rand(length(x),1)*0.0001;
                xOld = x + rand(length(x),1)*0.1;
            end
            [grad, obj] = fullGradient(obj,problem);
            obj.data('previousPt') = x;
            obj.data('previousGrad') = grad;
            s = x - xOld;
            y = grad - gOld;
            %disp(H)
            denominator = s.'*y;
            if abs(denominator) > 1e-4
                H = H + (s.'*y + y.'*H*y)*(s*s.')/(denominator)^2 - (H*y*s.' + s*y.'*H)/denominator;
            end
            obj.data('HessianInv') = H;
            H1g = H*grad; %H2g = H*H*grad; H3g=H*H*H*grad;
            fun = @(alpha)objectiveFunctionAll(obj, x - H1g*alpha, false, problem);
            options = optimset('Display','off','MaxIter',6,'TolX',1e-4);
            [a,fa,~,~] = fminbnd(fun,0.1,1.4,options);
            
            fun = @(alpha)objectiveFunctionAll(obj, x - alpha*grad, false, problem);
            limit = 0.5;
            options = optimset('Display','off','MaxIter',4,'TolX',1e-4);
            [aG,fG,~,~] = fminbnd(fun,0,2*limit,options);
            if fa < fG
                x = x - H1g*a;
                %obj.calculations = obj.calculations + out1.funcCount * numofcalc(obj,NaN,"allCombOfTwo");
                %disp('hessian')
            else
                x = x - aG*grad;
                %obj.calculations = obj.calculations + out2.funcCount * numofcalc(obj,NaN,"allCombOfTwo");
                %disp('grad')
            end
            obj = obj.decisionVariablesToProblem(x);
        end
        
        function obj = optimizeBFGS2(obj,problem) % uusi versio
            n = length(obj.shapes);
            x = decisionVariablesFromProblem(obj);
            %disp(x);
            try
                H = obj.data("HessianInv");
                gOld = obj.data("previousGrad");
                xOld = obj.data("previousPt");
            catch
                H = eye(length(x));
                gOld = rand(length(x),1)*0.0001;
                xOld = x + rand(length(x),1)*0.1;
            end
            if length(H) ~= length(x)
                H = eye(length(x));
                gOld = rand(length(x),1)*0.0001;
                xOld = x + rand(length(x),1)*0.1;
            end
            [grad, obj] = fullGradient(obj,problem);
            obj.data('previousPt') = x;
            obj.data('previousGrad') = grad;
            s = x - xOld;
            y = grad - gOld;
            %disp(H)
            denominator = s.'*y;
            if abs(denominator) < 1e-5
                fun = @(alpha)objectiveFunctionAll(obj, x - alpha*grad, false, problem);
                limit = 0.5;
                options = optimset('Display','off','MaxIter',4,'TolX',1e-4);
                [aG,~,~,out] = fminbnd(fun,0,2*limit,options);
                x = x - aG*grad;
            else
                H = H + (s.'*y + y.'*H*y)*(s*s.')/(denominator)^2 - (H*y*s.' + s*y.'*H)/denominator;
                obj.data('HessianInv') = H;
                H1g = H*grad; %H2g = H*H*grad; H3g=H*H*H*grad;
                fun = @(alpha)objectiveFunctionAll(obj, x - H1g*alpha, false, problem);
                options = optimset('Display','off','MaxIter',6,'TolX',1e-4);
                [a,~,~,out] = fminbnd(fun,0,2,options);
                x = x - H1g*a;
            end
            obj.calculations = obj.calculations + out.funcCount * numofcalc(obj,NaN,"allCombOfTwo");
            
            obj = obj.decisionVariablesToProblem(x);
        end
        
        function obj = optimizeFullGradient(obj,problem)
            n = length(obj.shapes);
            x = decisionVariablesFromProblem(obj);
            [grad, obj] = fullGradient(obj,problem);
            fun = @(alpha)objectiveFunctionAll(obj, x - alpha*grad, false, problem);
            limit = 0.5;
            options = optimset('Display','off','MaxIter',4,'TolX',1e-4);
            [aG,~,~,out] = fminbnd(fun,0,2*limit,options);
            obj.calculations = obj.calculations + out.funcCount * numofcalc(obj,NaN,"allCombOfTwo");
            x = x - aG*grad;
            obj = obj.decisionVariablesToProblem(x);
        end
        
        % Line search not timed
        function obj = optimizeFullGradientNoLine(obj,problem)
            n = length(obj.shapes);
            x = decisionVariablesFromProblem(obj);
            [grad, obj] = fullGradient(obj,problem);
            fun = @(alpha)objectiveFunctionAll(obj, x - alpha*grad, false, problem);
            limit = 0.5;
            options = optimset('Display','off','MaxIter',4,'TolX',1e-4);
            [aG,~,~,~] = fminbnd(fun,0,2*limit,options);
            %obj.calculations = obj.calculations + out.funcCount * numofcalc(obj,NaN,"allCombOfTwo");
            x = x - aG*grad;
            obj = obj.decisionVariablesToProblem(x);
        end
        
        function out = objectiveFunctionAll(obj, x, justCheckSolution, problem)
            n = length(obj.shapes);
            littleToZero = true;
            % if x = NaN, 'obj' does not change. Otherwise we change
            % parameters of 'obj'
            if ~isnan(x(1))
                obj = obj.decisionVariablesToProblem(x);
            end
            
            out = 0;
            for v = 1:n
                for w = (v+1):n
                    area = 2*obj.shapes{v}.intersectArea(obj.shapes{w}, problem("allowDist"));
                    if area > problem('solutionLimit') * obj.shapes{v}.shapeArea() && littleToZero
                        out = out + area;
                    end
                    if justCheckSolution && out ~= 0
                        out = true;
                        return
                    end
                    % factor of 2, so that sum(f) == 2*F
                end
            end
            for q = 1:n
                %obj.shapes{q}.intersectArea(obj.box, "no")
                areaOutsideTheBox = obj.shapes{q}.shapeArea - obj.shapes{q}.intersectArea(obj.box, "no");
                if abs(areaOutsideTheBox) / obj.shapes{q}.shapeArea < problem('solutionLimit')
                    areaOutsideTheBox = 0;
                end
                out = out + areaOutsideTheBox;
                if justCheckSolution && out ~= 0
                    out = true;
                    return
                end
            end
            if justCheckSolution
                out = false;
                return
            end
        end
        
        function x = decisionVariablesFromProblem(obj)
            n = length(obj.shapes);
            len = 0;
            for q = 1:n
                len = len + 3;
                if isa(obj.shapes{q},"capsRect")
                    len = len+2;
                end
            end
            x = zeros(len,1);
            ind = 1;
            for q = 1:n
                if isa(obj.shapes{q},"shape")
                    x(ind)   = obj.shapes{q}.position(1);
                    x(ind+1) = obj.shapes{q}.position(2);
                    x(ind+2) = obj.shapes{q}.theta;
                    ind = ind + 3;
                else
                    x(ind)   = obj.shapes{q}.capsule.position(1);
                    x(ind+1) = obj.shapes{q}.capsule.position(2);
                    x(ind+2) = obj.shapes{q}.capsule.theta;
                    x(ind+3) = obj.shapes{q}.rectangle.position(1);
                    x(ind+4) = obj.shapes{q}.rectangle.position(2);
                    ind = ind + 5;
                end
            end
        end
        
        function obj = decisionVariablesToProblem(obj,x)
            n = length(obj.shapes);
            ind = 1;
            for q = 1:n
                if isa(obj.shapes{q},"shape")
                    obj.shapes{q}.position(1) = x(ind);
                    obj.shapes{q}.position(2) = x(ind+1);
                    obj.shapes{q}.theta       = x(ind+2);
                    ind = ind + 3;
                else
                    obj.shapes{q}.capsule.position(1)           = x(ind);
                    obj.shapes{q}.capsule.position(2)           = x(ind+1);
                    obj.shapes{q}.capsule.theta                 = x(ind+2);
                    obj.shapes{q}.rectangle.position(1) = x(ind+3);
                    obj.shapes{q}.rectangle.position(2) = x(ind+4);
                    ind = ind + 5;
                end
            end
        end
        
        function obj = randomizeShapeIndices(obj)
            n = length(obj.shapes);
            objTmp = obj.shapes;
            r = randperm(n);
            for q = 1:n
                objTmp{q} = obj.shapes{r(q)};
            end
            obj.shapes = objTmp;
        end
        
        function obj = findZeroGrad(obj,problem)
            x = decisionVariablesFromProblem(obj);
            [grad, obj] = fullGradient(obj,problem);
            f0 = objectiveFunctionAll(obj, NaN, false, problem);
            alpha = f0 / max(norm(grad)^2, 1e-3);
            x = x - alpha*grad;
            obj = obj.decisionVariablesToProblem(x);
        end
        
        function obj = optimizeCyclic(obj,type,problem)
            n = length(obj.shapes);
            
            % Load data
            try
                q = mod(obj.data("iterationIndex"), n) + 1;
                k = obj.data("iterationIndex") + 1;
            catch
                q = 1;
                k = 1;
            end
            if obj.shapes{q}.static
                obj.data("iterationIndex") = k;
                return
            end
            
            if problem('squared') == "individual" || problem('squared') == "whole"
                weights = obj.shapes{q}.weights().^2; %%% SQUARED
            else
                weights = obj.shapes{q}.weights(); %%% SQUARED
            end
            
            if type == "Matlab" || problem('squared') == "ones"
                weights = weights * 0 + 1;
            end
            
            if isa(obj.shapes{q}, "shape")
                initialX = obj.shapes{q}.legacyCoordinates();
                initialX = (initialX(3:5).') .* weights;
                %lb = [-obj.box.width/2, -obj.box.height/2, -20] .* weights;
                %ub = [ obj.box.width/2,  obj.box.height/2,  20] .* weights;
                d = obj.shapes{q}.width/2;
                lb = [initialX(1:2) - d, initialX(3)-0.1];
                ub = [initialX(1:2) + d, initialX(3)+0.1];
            elseif isa(obj.shapes{q}, "capsRect")
                initialX = obj.shapes{q}.capsule.position;
                initialX = [initialX, obj.shapes{q}.capsule.theta];
                initialX = [initialX, obj.shapes{q}.rectangle.position(1), obj.shapes{q}.rectangle.position(2)];
                initialX = initialX .* weights;
                %lb = [-obj.box.width/2, -obj.box.height/2, -20, -20, -1] .* weights;
                %ub = [ obj.box.width/2,  obj.box.height/2,  20,  20,  1] .* weights;
                d = obj.shapes{q}.capsule.width/2;
                lb = [initialX(1:2) - d, initialX(3)-0.1, initialX(4:5)-0.2];
                ub = [initialX(1:2) + d, initialX(3)+0.1, initialX(4:5)+0.2];
            end
            
            if problem("h2Step") == "diminishing"
                h2 = 0.4 / sqrt((n+k)/n) + 1e-3;
            else
                h2 = 1;
            end
            
            if type == "Matlab"
                %calcTmp = problem('MatlabCalc');
                options = optimoptions('fmincon',...
                    'Algorithm','active-set',...
                    'MaxIterations',3,'Display','off',...
                    'OptimalityTolerance',1e-16,...
                    'StepTolerance',1e-16);
                [s,~,~,output] = fmincon(@(x)obj.objectiveFunctionShapeWise(x./weights, q, problem), initialX, [],[],[],[],lb,ub,[],options);
                calcTmp = output.funcCount;
            else
                [s, ~, calcTmp] = gradWithNewtonStep(@(x)obj.objectiveFunctionShapeWise(x./weights, q, problem), initialX, 1e-4, h2, type, problem);
            end
            
            s = s ./ weights;
            
            
            if isa(obj.shapes{q}, "shape")
                obj.shapes{q}.position = s(1:2);
                obj.shapes{q}.theta = s(3);
            elseif isa(obj.shapes{q}, "capsRect")
                obj.shapes{q}.capsule.position = s(1:2);
                obj.shapes{q}.capsule.theta = s(3);
                obj.shapes{q}.rectangle.position = s(4:5);
            end
            
            obj.calculations = obj.calculations + calcTmp * numofcalc(obj,q,"objectWise");
            obj.data("iterationIndex") = k;
            
            obj.shapes = obj.box.contain(obj.shapes);
        end
        
        function out = numofcalc(obj,p,type)
            n = length(obj.shapes);
            capsRect = 0;
            for q = 1:n
                if isa(obj.shapes{q},"capsRect")
                    capsRect = capsRect+1;
                end
            end
            N = (n-capsRect) + 2*capsRect;
            if type == "allCombOfTwo"
                out = N*(N-1)/2 - capsRect;
            elseif type == "objectWise" && isa(obj.shapes{p},"shape")
                out = N-1;
            elseif type == "objectWise" && isa(obj.shapes{p},"capsRect")
                out = 2*N-4;
            end
        end
        
        function drawProblem(obj, hidden)
            n = length(obj.shapes);
            fillColor = [101/255 167/255 1];
            fillColor = fillColor.^0.7;
            strokeColor = 'k';
            
            if hidden
                figure('visible','off');
            else
                figure;
            end
            
            if obj.box.type == "rectangle"
                obj.box.drawShape(true, [1,1,1], 'k', 1.5);
                right = obj.box.width/2 + obj.box.position(1);
                left = -obj.box.width/2 + obj.box.position(1);
                height = obj.box.height/2 + obj.box.position(2);
                hold on
                green = [44,205,47]/255;
                plot([left, right], [height,height], 'color', green, 'LineWidth', 1.2);
                text(0, height + 0.9, "EXIT", 'color', green, 'FontSize',16, 'HorizontalAlignment', 'center');
            elseif obj.box.type == "capsule"
                obj.box.drawShape(true, [1,1,1], 'k', 1);
            end
            hold on
            for v = 1:n
                obj.shapes{v}.drawShape(true, fillColor, strokeColor, 0.1);
            end
            for v = 1:n
                obj.shapes{v}.drawShape(false, fillColor, strokeColor, 0.1);
            end
            hold on
            axis off
        end
    end
end

