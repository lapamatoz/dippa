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
            l = length(obj.shapes);
            obj.shapes{l+1} = shape;
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
            out = obj.decisionVariablesFromProblem * 0;
            ind = 1;
            objShapes = obj.shapes;
            fun = @(x,q,weights,p)obj.objectiveFunctionShapeWise(x./weights, q, p);
            objCalculations = obj.calculations;
            
            for q = 1:n
                weights = objShapes{q}.weights();
                if isa(objShapes{q},"shape")
                    initialX = objShapes{q}.legacyCoordinates();
                    initialX = (initialX(3:5).') .* weights;
                
                    [grad, f0, calcTmp] = triangleGrad(@(x)fun(x,q,weights,problem), initialX, 1e-4, true);
                    objCalculations = objCalculations + calcTmp * numofcalc(obj,q,"objectWise");
                    out(ind:(ind+2)) = grad; % joku kerroin ???
                
                    if f0 == 0
                        grad = grad ./ weights;
                        objShapes{q}.position = grad(1:2);
                        objShapes{q}.theta = grad(3);
                        out(ind:(ind+2)) = out(ind:(ind+2))*0;
                    end
                    ind = ind + 3;
                else
                    initialX = objShapes{q}.capsule.legacyCoordinates();
                    initialX = [initialX(3:5), objShapes{q}.rectangle.position];
                    initialX = (initialX.') .* weights;
                
                    [grad, f0, calcTmp] = triangleGrad(@(x)fun(x,q,weights), initialX, 1e-4, true);
                    objCalculations = objCalculations + calcTmp * numofcalc(obj,q,"objectWise");
                    
                    out(ind:(ind+4)) = grad; % joku kerroin ???
                
                    if f0 == 0
                        grad = grad ./ weights;
                        objShapes{q}.capsule.position = grad(1:2);
                        objShapes{q}.capsule.theta = grad(3);
                        objShapes{q}.rectangle.position = grad(4:5);
                        out(ind:(ind+4)) = out(ind:(ind+4))*0;
                    end
                    ind = ind + 5;
                end
            end
            
            obj.shapes = objShapes;
            obj.calculations = objCalculations;
        end
        
        function obj = optimizeBFGS(obj,problem)
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
                denominator = 1e-5;
            end
            H = H + (s.'*y + y.'*H*y)*(s*s.')/(denominator)^2 - (H*y*s.' + s*y.'*H)/denominator;
            obj.data('HessianInv') = H;
            H1g = H*grad; H2g = H*H*grad; H3g=H*H*H*grad;
            fun = @(alpha)objectiveFunctionAll(obj, x - H1g*alpha, false, problem);
            options = optimset('Display','off','MaxIter',6,'TolX',1e-5);
            [a,fa,~,out] = fminbnd(fun,0,1.3,options);
            obj.calculations = obj.calculations + out.funcCount * numofcalc(obj,NaN,"allCombOfTwo");
            fun = @(alpha)objectiveFunctionAll(obj, x - alpha*grad, false, problem);
            limit = 0.5;
            options = optimset('Display','off','MaxIter',4,'TolX',1e-5);
            [aG,fG,~,out] = fminbnd(fun,0,2*limit,options);
            obj.calculations = obj.calculations + out.funcCount * numofcalc(obj,NaN,"allCombOfTwo");
            if fa < fG
                x = x - H1g*a;
                %disp('hessian')
            else
                x = x - aG*grad;
                %disp('grad')
            end
            obj = obj.decisionVariablesToProblem(x);
        end
        
        function obj = optimizeFullGradient(obj,problem)
            n = length(obj.shapes);
            try
                obj.data("iterationIndex") = obj.data("iterationIndex") + 1;
            catch
                obj.data("iterationIndex") = 0;
            end
            [grad, obj] = fullGradient(obj,problem);
            limit = 0.5;
            %funx0 = objectiveFunctionAll(obj, NaN, false, problem);
            %objective = funx0;
            x = decisionVariablesFromProblem(obj);
            x0 = x;
            %k = 0;
            fun = @(alpha)objectiveFunctionAll(obj, x0 - alpha*grad, false, problem);
            options = optimset('Display','off','MaxIter',3,'TolX',1e-7);
            [a,~,out] = fminbnd(fun,0,2*limit,options);
            obj.calculations = obj.calculations + out.funcCount * numofcalc(obj,NaN,"allCombOfTwo");
            x = x0 - a*grad;
%             while funx0 <= objective && k < 5
%                 x = x0 - limit*grads;
%                 obj.calculations = obj.calculations + n/2* (n-1);
%                 objective = objectiveFunctionAll(obj, x, false, problem);
%                 if objective == 0
%                     obj = obj.decisionVariablesToProblem(x);
%                     return
%                 end
%                 limit = limit/2;
%                 k = k+1;
%             end
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
                    obj.shapes{q}.position(1)           = x(ind);
                    obj.shapes{q}.position(2)           = x(ind+1);
                    obj.shapes{q}.theta                 = x(ind+2);
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
                h2 = 1e-3;
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
                obj.box.drawShape(true, [1,1,1], 'k');
            end
            hold on
            for v = 1:n
                obj.shapes{v}.drawShape(true, fillColor, strokeColor);
            end
            for v = 1:n
                obj.shapes{v}.drawShape(false, fillColor, strokeColor);
            end
            hold on
            axis off
        end
    end
end

