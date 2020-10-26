function [points, circle] = stadiumRectIntPoints4(s1,s2)
%UNTITLED9 Summary of this function goes here
% s1 is capsule and s2 is rectangle
%   returns intersectionpoints [x1 x2 ... ; y1 y2 ...]
rotationS1 = [cos(s1(5)), -sin(s1(5)); sin(s1(5)), cos(s1(5))];
rotationS2 = [cos(s2(5)), -sin(s2(5)); sin(s2(5)), cos(s2(5))];

points = ones(2,32)*NaN;
circle = single(ones(1,36)*NaN);

% E   0
% F   1

% points a b c d in s2

p = rotationS1 * [s1(1); s1(2)] + [s1(3); s1(4)];
if (inRectangle(p, s2))
    points(:,1) = p;
    circle(1) = 0;
end

p = rotationS1 * [-s1(1); s1(2)] + [s1(3); s1(4)];
if (inRectangle(p, s2))
    points(:,2) = p;
    circle(2) = 1;
end

p = rotationS1 * [-s1(1); -s1(2)] + [s1(3); s1(4)];
if (inRectangle(p, s2))
    points(:,3) = p;
    circle(3) = 1;
end

p = rotationS1 * [s1(1); -s1(2)] + [s1(3); s1(4)];
if (inRectangle(p, s2))
    points(:,4) = p;
    circle(4) = 0;
end

% points a' b' c' d' in s1

p = rotationS2 * [s2(1); s2(2)] + [s2(3); s2(4)];
if (inStadium(p, s1))
    points(:,5) = p;
end

p = rotationS2 * [-s2(1); s2(2)] + [s2(3); s2(4)];
if (inStadium(p, s1))
    points(:,6) = p;
end

p = rotationS2 * [-s2(1); -s2(2)] + [s2(3); s2(4)];
if (inStadium(p, s1))
    points(:,7) = p;
end

p = rotationS2 * [s2(1); -s2(2)] + [s2(3); s2(4)];
if (inStadium(p, s1))
    points(:,8) = p;
end

% line segments, starting from ab's

onePoints = [s1(1), -s1(1), -s1(1),  s1(1), s1(1)
             s1(2),    s1(2),   -s1(2),   -s1(2),   s1(2)];
twoPoints = [s2(1), -s2(1), -s2(1),  s2(1), s2(1)
             s2(2),    s2(2),   -s2(2),   -s2(2),   s2(2)];

onePoints = rotationS1 * onePoints;
twoPoints = rotationS2 * twoPoints;

for k = [0:3,8:11]
    A1x = onePoints(1,floor(k/4)+1) + s1(3);
    A1y = onePoints(2,floor(k/4)+1) + s1(4);
    B1x = onePoints(1,floor(k/4)+2) + s1(3);
    B1y = onePoints(2,floor(k/4)+2) + s1(4);
    
    A2x = twoPoints(1, mod(k,4)+1) + s2(3);
    A2y = twoPoints(2, mod(k,4)+1) + s2(4);
    B2x = twoPoints(1, mod(k,4)+2) + s2(3);
    B2y = twoPoints(2, mod(k,4)+2) + s2(4);
    
    t1 = (A2y * B1x - A2x * B1y - A2y * B2x + B1y * B2x + A2x * B2y - B1x * B2y)/(A1y * A2x - A1x * A2y + A2y * B1x - A2x * B1y - A1y * B2x + B1y * B2x + A1x * B2y - B1x * B2y);
    t2 = (A1y*B1x - A1x*B1y - A1y*B2x + B1y*B2x + A1x*B2y - B1x*B2y)/(A1y*A2x - A1x*A2y + A2y*B1x - A2x*B1y - A1y*B2x + B1y*B2x + A1x*B2y - B1x * B2y);
    
    if (t1 <= 1 && t1 >= 0 && t2 <= 1 && t2 >= 0)
        pTemp = [A1x*t1+(1-t1)*B1x ; A1y*t1+(1-t1)*B1y];
        %if ~insideStadium(pTemp,s1)
            if k < 4
                points(:,9+k) = pTemp;
            else
                points(:,13+k-8) = pTemp;
            end
        %end
    end
end

% circles and line segments

% s1 circle and s2 lines

circle(17:20) = 0;
circle(25:28) = 0;

circle(21:24) = 1;
circle(29:32) = 1;

r = s1(2);

center = [s1(1), -s1(1); 0, 0];

center = rotationS1 * center;


for k = 0:7
    
    A2x = twoPoints(1, mod(k,4)+1) + s2(3);
    A2y = twoPoints(2, mod(k,4)+1) + s2(4);
    B2x = twoPoints(1, mod(k,4)+2) + s2(3);
    B2y = twoPoints(2, mod(k,4)+2) + s2(4);
    
    x0 = center(1, floor(k/4)+1) + s1(3);
    y0 = center(2, floor(k/4)+1) + s1(4);
    
    radical = (4*(-B2x^2 + A2x*(B2x - x0) + B2x*x0 + (A2y - B2y)*(B2y - y0))^2 - 4*(A2x^2 + A2y^2 - 2*A2x*B2x + B2x^2 - 2*A2y*B2y + B2y^2)*(B2x^2 + B2y^2 - r^2 - 2*B2x*x0 + x0^2 - 2*B2y*y0 + y0^2));
 
    if radical >= 0
        t2 = (-A2x*B2x + B2x^2 - A2y*B2y + B2y^2 + A2x*x0 - B2x*x0 + A2y*y0 - B2y*y0 - 0.5*sqrt(radical))/(A2x^2 + A2y^2 - 2*A2x*B2x + B2x^2 - 2*A2y*B2y + B2y^2);
        if (t2 <= 1 && t2 >= 0)
            pTemp = [A2x*t2+(1-t2)*B2x ; A2y*t2+(1-t2)*B2y];
            %if ~insideStadium(pTemp, s1)
            if onOuterEdgeOfStadiumCircle(pTemp,s1,floor(k/4))
                points(:,17+k) = pTemp;
            end
        end
        
        t2 = (-A2x*B2x + B2x^2 - A2y*B2y + B2y^2 + A2x*x0 - B2x*x0 + A2y*y0 - B2y*y0 + 0.5*sqrt(radical))/(A2x^2 + A2y^2 - 2*A2x*B2x + B2x^2 - 2*A2y*B2y + B2y^2);
        if (t2 <= 1 && t2 >= 0)
            pTemp = [A2x*t2+(1-t2)*B2x ; A2y*t2+(1-t2)*B2y];
            %if ~insideStadium(pTemp, s1)
            if onOuterEdgeOfStadiumCircle(pTemp,s1,floor(k/4))
                points(:,25+k) = pTemp;
            end
        end
    end
end

nanValues = ~isnan(points(1,:));
circle = circle(nanValues);
points = points(:,nanValues);

end