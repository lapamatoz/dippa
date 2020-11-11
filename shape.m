classdef shape
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        position = [0;0];
        theta = 0;
        width = 1;
        height = 1;
        type = "capsule"
        static = false;
    end
    
    methods
        function out = legacyCoordinates(obj)
            if obj.type == "capsule"
                r = obj.height / 2;
                a = (obj.width - obj.height )/2;
            elseif obj.type == "rectangle"
                r = obj.height / 2;
                a = obj.width  / 2;
            end
            out = [a; r; obj.position(1); obj.position(2); obj.theta];
        end
        
        function out = shapeArea(obj)
            s = legacyCoordinates(obj);
            if obj.type == "capsule"
                out = s(2)*(pi*s(2) + 4*s(1));
            elseif obj.type == "rectangle"
                out = 4 * s(1) * s(2);
            end
        end
        
        function obj = createRandomShape(box)
            obj = shape;
            obj.position = (2*rand(1,2) - 1) .* [box.width, box.height] / 2;
            obj.theta = rand() * 2*pi;
            obj.height = 1;
            obj.width = 2;
            obj.type = "rectangle";
        end
        
        function out = intersectArea(obj1, obj2, condition)
            if condition == "allowDistances" && isa(obj2, "shape") && obj1.type == "capsule" && obj2.type == "capsule"
                out = overlappingDistance(obj1, obj2);
            elseif isa(obj2, "shape")
                s1 = legacyCoordinates(obj1);
                s2 = legacyCoordinates(obj2);
                if obj1.type == "capsule" && obj2.type == "capsule"
                    out = stadiumOverlapArea4(s1, s2);
                elseif obj1.type == "capsule" && obj2.type == "rectangle"
                    out = stadiumRectOverlapArea4(s1, s2);
                elseif obj1.type == "rectangle" && obj2.type == "capsule"
                    out = stadiumRectOverlapArea4(s2, s1);
                elseif obj1.type == "rectangle" && obj2.type == "rectangle"
                    out = rectIntersectArea(s1, s2);
                end
            elseif isa(obj2, "capsRect")
                out = obj2.intersectArea(obj1,condition);
            end
            %if out < 4e-3 * obj1.shapeArea
            %    out = 0;
            %end
        end
        
        function R = rotationMatrix(obj)
            t = obj.theta;
            R = [cos(t), -sin(t); sin(t), cos(t)];
        end
        
        function out = overlappingDistance(obj1, obj2)
            if ~iscolumn(obj1.position)
                obj1.position = obj1.position.';
            end
            if ~iscolumn(obj2.position)
                obj2.position = obj2.position.';
            end
            A = obj1.rotationMatrix*[+(obj1.width - obj1.height)/2;0] + obj1.position;
            B = obj1.rotationMatrix*[-(obj1.width - obj1.height)/2;0] + obj1.position;
            a = obj2.rotationMatrix*[+(obj2.width - obj2.height)/2;0] + obj2.position;
            b = obj2.rotationMatrix*[-(obj2.width - obj2.height)/2;0] + obj2.position;
            out = min([distanceLineSegPt(A,B,a),...
                       distanceLineSegPt(A,B,b),...
                       distanceLineSegPt(a,b,A),...
                       distanceLineSegPt(a,b,B)]);
            out = -out + obj1.height/2 + obj1.height/2;
            % Calculate intersection point
            M = [A-B, b-a];
            M = 1/(M(1,1)*M(2,2) - M(1,2)*M(2,1)) * [M(2,2), -M(1,2); -M(2,1), M(1,1)];
            ts = M * (b - B);
            if 0 <= ts(1) && ts(1) <= 1 && 0 <= ts(2) && ts(2) <= 1
                P = ts(1) * A + (1-ts(1)) * B;
                dist = min([norm(A-P),...
                            norm(B-P),...
                            norm(a-P),...
                            norm(b-P)]);
                out = out + dist*1; % 100 tähän?
            end
            if out < 0
                out = 0;
            end
            out = out^2;
        end
        
        function w = weights(obj)
            s = legacyCoordinates(obj);
            negativeRotMat = [cos(-s(5)), -sin(-s(5)); sin(-s(5)), cos(-s(5))];
            e1 = negativeRotMat * [1; 0];
            e2 = negativeRotMat * [0; 1];
            if obj.type == "capsule"
                a = s(1)*2;
                r = s(2);
                w = [abs(a*e1(2)) + 2*r,...
                     abs(a*e2(2)) + 2*r,...
                     a*(r+a/4)];
            elseif obj.type == "rectangle"
                w = [s(2)*2*abs(e1(1)) + s(1)*2*abs(e1(2)),...
                     s(2)*2*abs(e2(1)) + s(1)*2*abs(e2(2)),...
                     (s(1)*2)^2/4 + (s(2)*2)^2/4];
            end
            w = w / w(3); % onko pakollinen?
            %weights = [1,1,a]; % this works pretty well
        end
        
        function shapes = contain(box, shapes)
            n = length(shapes);
            for q = 1:n
                if isa(shapes{q}, "shape")
                    shapes{q}.position(1) = min(box.width/2, max(-box.width/2, shapes{q}.position(1)));
                    shapes{q}.position(2) = min(box.height/2, max(-box.height/2, shapes{q}.position(2)));
                    shapes{q}.theta = mod(shapes{q}.theta, 2*pi);
                elseif isa(shapes{q}, "capsRect")
                    tmp = box.contain({shapes{q}.capsule});
                    shapes{q}.capsule = tmp{1};
                    shapes{q}.rectangle.position(1) = mod(shapes{q}.rectangle.position(1), 4*pi);
                    shapes{q}.rectangle.position(2) = min(1, max(-1, shapes{q}.rectangle.position(2)));
                end
            end
        end
        
        function h = drawShape(obj,filled, fillColor, strokeColor, strokeWidth)
            s = legacyCoordinates(obj);
            hold on
            rotationMatrix = [cos(s(5)), -sin(s(5)); sin(s(5)), cos(s(5))];
            points = [-s(1), -s(1), s(1),  s(1), -s(1)
                      -s(2),  s(2), s(2), -s(2), -s(2)];
            points = rotationMatrix * points;
            if obj.type == "capsule"
                circlePoints = [-s(1), s(1); 0, 0];
                circlePoints = rotationMatrix * circlePoints;
                if filled
                    h = fill(points(1,:)+s(3),points(2,:)+s(4),fillColor);
                    h.LineWidth = strokeWidth;
                    drawCircle(circlePoints(1,1)+s(3),circlePoints(2,1)+s(4),s(2),true, fillColor, strokeColor);
                    drawCircle(circlePoints(1,2)+s(3),circlePoints(2,2)+s(4),s(2),true, fillColor, strokeColor);
                else
                    h = plot(points(1,:)+s(3),points(2,:)+s(4),'-','color',strokeColor);
                    drawCircle(circlePoints(1,1)+s(3),circlePoints(2,1)+s(4),s(2),false, fillColor, strokeColor);
                    drawCircle(circlePoints(1,2)+s(3),circlePoints(2,2)+s(4),s(2),false, fillColor, strokeColor);
                end
            elseif obj.type == "rectangle"
                if filled
                    h = fill(points(1,:)+s(3),points(2,:)+s(4), fillColor);
                    h.LineWidth = strokeWidth; % 0.1
                else
                    h = plot(points(1,:)+s(3),points(2,:)+s(4),'-','color',strokeColor);
                end
            end
            daspect([1 1 1]);
            hold off
        end
    end
end
