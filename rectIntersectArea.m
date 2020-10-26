function A = rectIntersectArea(r1,r2)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
rotationR1 = [cos(r1(5)), -sin(r1(5)); sin(r1(5)), cos(r1(5))];
rotationR2 = [cos(r2(5)), -sin(r2(5)); sin(r2(5)), cos(r2(5))];
shift1 = [r1(3); r1(4)];
shift2 = [r2(3); r2(4)];

rect1 = [r1(1), -r1(1), -r1(1), r1(1); r1(2),    r1(2),   -r1(2),   -r1(2)];
rect2 = [r2(1), -r2(1), -r2(1), r2(1); r2(2),    r2(2),   -r2(2),   -r2(2)];
rect1 = rotationR1*rect1 + shift1;
rect2 = rotationR2*rect2 + shift2;

%points = 1i*ones(2,16+8);
points = ones(2,16+8)*NaN;

for a = 0:3
    for b = 1:4
        temp = lineIntersect(rect1(:,mod(a,4)+1), rect1(:,mod(a+1,4)+1), rect2(:,mod(b,4)+1), rect2(:,mod(b+1,4)+1));
        if ~isempty(temp)
            points(:,a*4+b) = temp;
        end
    end
end

for p = 1:4
    if inRectangle(rect1(:,p), r2)
        points(:,16+p) = rect1(:,p);
    end
end
for p = 1:4
    if inRectangle(rect2(:,p), r1)
        points(:,16+4+p) = rect2(:,p);
    end
end

nanValues = ~isnan(points(1,:));
points = points(:,nanValues);

%ptsarray = (points(1,:)==real(points(1,:))).*(1:length(points(1,:)));
%ptsarray = ptsarray(ptsarray~=0);
%points = points(:,ptsarray);

if length(points(1,:)) <= 2
    A = 0;
    return
else
	try
        K = convhull(points(1,:), points(2,:));
    catch
        A = 0;
        return
    end
end

A = polyarea(points(1,K), points(2,K));

%hold on
%plot(polycut);

end