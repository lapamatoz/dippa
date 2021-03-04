function points = stadiumIntersectPoints5(s1,s2)
%UNTITLED9 Summary of this function goes here
%   returns intersectionpoints [x1 x2 ... ; y1 y2 ...]

rotationS1 = [cos(s1(5)), -sin(s1(5)); sin(s1(5)), cos(s1(5))];
rotationS2 = [cos(s2(5)), -sin(s2(5)); sin(s2(5)), cos(s2(5))];


points = ones(2,36)*NaN;
%circle = single(ones(1,36)*NaN);

% E   0
% F   1
% E'  2
% F'  3
% EE' 4
% EF' 5
% FE' 6
% FF' 7

% points a b c d in s2

p = rotationS1 * [s1(1); s1(2)] + [s1(3); s1(4)];
if (inStadium(p, s2))
    points(:,1) = p;
    %circle(1) = 0;
end

p = rotationS1 * [-s1(1); s1(2)] + [s1(3); s1(4)];
if (inStadium(p, s2))
    points(:,2) = p;
    %circle(2) = 1;
end

p = rotationS1 * [-s1(1); -s1(2)] + [s1(3); s1(4)];
if (inStadium(p, s2))
    points(:,3) = p;
    %circle(3) = 1;
end

p = rotationS1 * [s1(1); -s1(2)] + [s1(3); s1(4)];
if (inStadium(p, s2))
    points(:,4) = p;
    %circle(4) = 0;
end

% points a' b' c' d' in s1

p = rotationS2 * [s2(1); s2(2)] + [s2(3); s2(4)];
if (inStadium(p, s1))
    points(:,5) = p;
    %circle(5) = 2;
end

p = rotationS2 * [-s2(1); s2(2)] + [s2(3); s2(4)];
if (inStadium(p, s1))
    points(:,6) = p;
    %circle(6) = 3;
end

p = rotationS2 * [-s2(1); -s2(2)] + [s2(3); s2(4)];
if (inStadium(p, s1))
    points(:,7) = p;
    %circle(7) = 3;
end

p = rotationS2 * [s2(1); -s2(2)] + [s2(3); s2(4)];
if (inStadium(p, s1))
    points(:,8) = p;
    %circle(8) = 2;
end

% circle intersections
% https://math.stackexchange.com/questions/256100/how-can-i-find-the-points-at-which-two-circles-intersect
% E and E'
%circle(9:10) = 4;

p1 = rotationS1 * [s1(1); 0] + [s1(3); s1(4)];
p2 = rotationS2 * [s2(1); 0] + [s2(3); s2(4)];
r1 = s1(2);
r2 = s2(2);

R = sqrt((p2(1)-p1(1))^2 + (p2(2)-p1(2))^2);
radical = 2*(r1^2 + r2^2) / R^2 - (r1^2-r2^2)^2 / R^4 - 1;

if (radical >= 0)
    pt1 = 0.5*(p1+p2) + (r1^2 - r2^2)/(2*R^2)*(p2-p1) + 0.5*sqrt(radical)*[p2(2)-p1(2); p1(1)-p2(1)];
    pt2 = 0.5*(p1+p2) + (r1^2 - r2^2)/(2*R^2)*(p2-p1) - 0.5*sqrt(radical)*[p2(2)-p1(2); p1(1)-p2(1)];
    %if ~insideStadium(pt1,s1) && ~insideStadium(pt1,s2)
    if onOuterEdgeOfStadiumCircle(pt1,s1,0) && onOuterEdgeOfStadiumCircle(pt1,s2,0)
        points(:,9) = pt1;
    end
    %if ~insideStadium(pt2,s1) && ~insideStadium(pt2,s2)
    if onOuterEdgeOfStadiumCircle(pt2,s1,0) && onOuterEdgeOfStadiumCircle(pt2,s2,0)
        points(:,10) = pt2;
    end
end

% E and F'
%circle(11:12) = 5;

p1 = rotationS1 * [s1(1); 0] + [s1(3); s1(4)];
p2 = rotationS2 * [-s2(1); 0] + [s2(3); s2(4)];
r1 = s1(2);
r2 = s2(2);

R = sqrt((p2(1)-p1(1))^2 + (p2(2)-p1(2))^2);
radical = 2*(r1^2 + r2^2) / R^2 - (r1^2-r2^2)^2 / R^4 - 1;

if (radical >= 0)
    pt1 = 0.5*(p1+p2) + (r1^2 - r2^2)/(2*R^2)*(p2-p1) + 0.5*sqrt(radical)*[p2(2)-p1(2); p1(1)-p2(1)];
    pt2 = 0.5*(p1+p2) + (r1^2 - r2^2)/(2*R^2)*(p2-p1) - 0.5*sqrt(radical)*[p2(2)-p1(2); p1(1)-p2(1)];
    %if ~insideStadium(pt1,s1) && ~insideStadium(pt1,s2)
    if onOuterEdgeOfStadiumCircle(pt1,s1,0) && onOuterEdgeOfStadiumCircle(pt1,s2,1)
        points(:,11) = pt1;
    end
    %if ~insideStadium(pt2,s1) && ~insideStadium(pt2,s2)
    if onOuterEdgeOfStadiumCircle(pt2,s1,0) && onOuterEdgeOfStadiumCircle(pt2,s2,1)
        points(:,12) = pt2;
    end
end

% F and F'
%circle(13:14) = 7;

p1 = rotationS1 * [-s1(1); 0] + [s1(3); s1(4)];
p2 = rotationS2 * [-s2(1); 0] + [s2(3); s2(4)];
r1 = s1(2);
r2 = s2(2);

R = sqrt((p2(1)-p1(1))^2 + (p2(2)-p1(2))^2);
radical = 2*(r1^2 + r2^2) / R^2 - (r1^2-r2^2)^2 / R^4 - 1;

if (radical >= 0)
    pt1 = 0.5*(p1+p2) + (r1^2 - r2^2)/(2*R^2)*(p2-p1) + 0.5*sqrt(radical)*[p2(2)-p1(2); p1(1)-p2(1)];
    pt2 = 0.5*(p1+p2) + (r1^2 - r2^2)/(2*R^2)*(p2-p1) - 0.5*sqrt(radical)*[p2(2)-p1(2); p1(1)-p2(1)];
    %if ~insideStadium(pt1,s1) && ~insideStadium(pt1,s2)
    if onOuterEdgeOfStadiumCircle(pt1,s1,1) && onOuterEdgeOfStadiumCircle(pt1,s2,1)
        points(:,13) = pt1;
    end
    %if ~insideStadium(pt2,s1) && ~insideStadium(pt2,s2)
    if onOuterEdgeOfStadiumCircle(pt2,s1,1) && onOuterEdgeOfStadiumCircle(pt2,s2,1)
        points(:,14) = pt2;
    end
end

% F and E'
%circle(15:16) = 6;

p1 = rotationS1 * [-s1(1); 0] + [s1(3); s1(4)];
p2 = rotationS2 * [s2(1); 0] + [s2(3); s2(4)];
r1 = s1(2);
r2 = s2(2);

R = sqrt((p2(1)-p1(1))^2 + (p2(2)-p1(2))^2);
radical = 2*(r1^2 + r2^2) / R^2 - (r1^2-r2^2)^2 / R^4 - 1;

if (radical >= 0)
    %points(:,15) = 0.5*(p1+p2) + (r1^2 - r2^2)/(2*R^2)*(p2-p1) + 0.5*sqrt(radical)*[p2(2)-p1(2); p1(1)-p2(1)];
    %points(:,16) = 0.5*(p1+p2) + (r1^2 - r2^2)/(2*R^2)*(p2-p1) - 0.5*sqrt(radical)*[p2(2)-p1(2); p1(1)-p2(1)];
    pt1 = 0.5*(p1+p2) + (r1^2 - r2^2)/(2*R^2)*(p2-p1) + 0.5*sqrt(radical)*[p2(2)-p1(2); p1(1)-p2(1)];
    pt2 = 0.5*(p1+p2) + (r1^2 - r2^2)/(2*R^2)*(p2-p1) - 0.5*sqrt(radical)*[p2(2)-p1(2); p1(1)-p2(1)];
    %if ~insideStadium(pt1,s1) && ~insideStadium(pt1,s2)
    if onOuterEdgeOfStadiumCircle(pt1,s1,1) && onOuterEdgeOfStadiumCircle(pt1,s2,0)
        points(:,15) = pt1;
    end
    %if ~insideStadium(pt2,s1) && ~insideStadium(pt2,s2)
    if onOuterEdgeOfStadiumCircle(pt2,s1,1) && onOuterEdgeOfStadiumCircle(pt2,s2,0)
        points(:,16) = pt2;
    end
end

% line segments, starting from ab's

onePoints = [s1(1), -s1(1), -s1(1),  s1(1), s1(1)
             s1(2),    s1(2),   -s1(2),   -s1(2),   s1(2)];
twoPoints = [s2(1), -s2(1), -s2(1),  s2(1), s2(1)
             s2(2),    s2(2),   -s2(2),   -s2(2),   s2(2)];

onePoints = rotationS1 * onePoints;
twoPoints = rotationS2 * twoPoints;

for k = [0,2,8,10]
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
            if k < 3
                points(:,17+k/2) = pTemp;
            else
                points(:,17+k/2-2) = pTemp;
            end
        %end
    end
end

% circles and line segments
% s2 circle and s1 lines

r = s2(2);

center = [s2(1), -s2(1); 0, 0];

center = rotationS2 * center;

%circle([21:22, 25:26]) = 2;
%circle([23:24, 27:28]) = 3;

for k = [0,2,4,6]
    A1x = onePoints(1,mod(k,4)+1) + s1(3);
    A1y = onePoints(2,mod(k,4)+1) + s1(4);
    B1x = onePoints(1,mod(k,4)+2) + s1(3);
    B1y = onePoints(2,mod(k,4)+2) + s1(4);
    
    x0 = center(1, floor(k/4)+1) + s2(3);
    y0 = center(2, floor(k/4)+1) + s2(4);
    
    radical = (4*(-B1x^2 + A1x*(B1x - x0) + B1x*x0 + (A1y - B1y)*(B1y - y0))^2 - 4*(A1x^2 + A1y^2 - 2*A1x*B1x + B1x^2 - 2*A1y*B1y + B1y^2)*(B1x^2 + B1y^2 - r^2 - 2*B1x*x0 + x0^2 - 2*B1y*y0 + y0^2));
    if radical >= 0
        t1 = (-A1x*B1x + B1x^2 - A1y*B1y + B1y^2 + A1x*x0 - B1x*x0 + A1y*y0 - B1y*y0 - 0.5*sqrt(radical))/(A1x^2 + A1y^2 - 2*A1x*B1x + B1x^2 - 2*A1y*B1y + B1y^2);
        if (t1 <= 1 && t1 >= 0)
            pTemp = [A1x*t1+(1-t1)*B1x ; A1y*t1+(1-t1)*B1y];
            %if ~insideStadium(pTemp, s2)
            if onOuterEdgeOfStadiumCircle(pTemp,s2,floor(k/4))
                points(:,21+k/2) = pTemp;
            end
        end
        
        t1 = (-A1x*B1x + B1x^2 - A1y*B1y + B1y^2 + A1x*x0 - B1x*x0 + A1y*y0 - B1y*y0 + 0.5*sqrt(radical))/(A1x^2 + A1y^2 - 2*A1x*B1x + B1x^2 - 2*A1y*B1y + B1y^2);
        if (t1 <= 1 && t1 >= 0)
            pTemp = [A1x*t1+(1-t1)*B1x ; A1y*t1+(1-t1)*B1y];
            %if ~insideStadium(pTemp, s2)
            if onOuterEdgeOfStadiumCircle(pTemp,s2,floor(k/4))
            	points(:,25+k/2) = pTemp;
            end
        end
    end
end

% s1 circle and s2 lines

%circle([29:30, 33:34]) = 0;
%circle([31:32, 35:36]) = 1;

r = s1(2);

center = [s1(1), -s1(1); 0, 0];

center = rotationS1 * center;

for k = [0,2,4,6]
    
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
                points(:,29+k/2) = pTemp;
            end
        end
        
        t2 = (-A2x*B2x + B2x^2 - A2y*B2y + B2y^2 + A2x*x0 - B2x*x0 + A2y*y0 - B2y*y0 + 0.5*sqrt(radical))/(A2x^2 + A2y^2 - 2*A2x*B2x + B2x^2 - 2*A2y*B2y + B2y^2);
        if (t2 <= 1 && t2 >= 0)
            pTemp = [A2x*t2+(1-t2)*B2x ; A2y*t2+(1-t2)*B2y];
            %if ~insideStadium(pTemp, s1)
            if onOuterEdgeOfStadiumCircle(pTemp,s1,floor(k/4))
                points(:,33+k/2) = pTemp;
            end
        end
    end
end

nanValues = ~isnan(points(1,:));
%circle = circle(nanValues);
points = points(:,nanValues);

%ptsarray = (points(1,:)==real(points(1,:))).*(1:length(points(1,:)));
%ptsarray = ptsarray(ptsarray~=0);
%points = points(:,ptsarray);

end