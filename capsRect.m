classdef capsRect
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        capsule = shape;
        rectangle = shape; % theta = 0, position = [alpha,beta]
    end
    
    methods
        function rectangle = rectangleCoordinates(obj)
            rL = obj.rectangle.height / 2;
            r = obj.capsule.height / 2;
            aL = obj.rectangle.width / 2;
            a = (obj.capsule.width - 2*r) / 2;
            q = [0;0];
            alpha = mod(obj.rectangle.position(1), 4*pi);
            beta = obj.rectangle.position(2);
            if 0 <= alpha && alpha < pi
                q(1) = (2*alpha/pi-1)*a + beta*aL;
                q(2) = rL + r;
                rho = 0;
            elseif pi <= alpha && alpha < 2*pi
                q(1) = a - (rL+r)*sin(alpha) - beta*aL*cos(alpha);
                q(2) =   - (rL+r)*cos(alpha) + beta*aL*sin(alpha);
                rho = pi - alpha;
            elseif 2*pi <= alpha && alpha < 3*pi
                q(1) = (5-2*alpha/pi)*a - beta*aL;
                q(2) = -r-rL;
                rho = 0;
            elseif 3*pi <= alpha && alpha < 4*pi
                q(1) = -a + (rL + r)*sin(alpha) + beta*aL*cos(alpha);
                q(2) =      (rL + r)*cos(alpha) - beta*aL*sin(alpha);
                rho = pi - alpha;
            end
            rectangle = shape;
            theta = obj.capsule.theta;
            rotMat = [cos(theta), -sin(theta); sin(theta), cos(theta)];
            p = [obj.capsule.position(1); obj.capsule.position(2)];
            rectangle.position = rotMat * q + p;
            rectangle.theta = rho + obj.capsule.theta;
            rectangle.width = obj.rectangle.width;
            rectangle.height = obj.rectangle.height;
            rectangle.type = "rectangle";
        end
        
        function out = shapeArea(obj)
            out = obj.capsule.shapeArea() + obj.rectangle.shapeArea();
        end
        
        function out = intersectArea(obj1, obj2, problem)
            r1 = obj1.rectangleCoordinates();
            if isa(obj2,'capsRect')
                r2 = obj2.rectangleCoordinates();
                out =       intersectArea(obj1.capsule,   obj2.capsule, problem);
                out = out + intersectArea(obj1.capsule,   r2,           problem);
                out = out + intersectArea(r1,             obj2.capsule, problem);
                out = out + intersectArea(r1,             r2,           problem);
            elseif isa(obj2,'shape')
                out = intersectArea(obj1.capsule, obj2, problem) +...
                      intersectArea(r1,           obj2, problem);
            end
        end
        
        function w = weights(obj)
            w = [1,1,1/8,1,1]/10; % bigger => slower
            wCapsule = obj.capsule.weights;
            bigCapsule = obj.capsule;
            bigCapsule.width = bigCapsule.width + 2*obj.rectangle.width;
            wBigCapsule = bigCapsule.weights;
            w(3) = wCapsule(3) + 1/2 * wBigCapsule(3);
            rect = obj.rectangleCoordinates;
            wRectangle = rect.weights;
            w(1:2) = wCapsule(1:2) + wRectangle(1:2);
            w(4:5) = [1,1];
        end
        
        function drawShape(obj,filled, fillColor, strokeColor)
            obj.capsule.drawShape(filled, fillColor, strokeColor);
            rect = obj.rectangleCoordinates;
            rect.drawShape(filled, fillColor, strokeColor);
        end
    end
end

