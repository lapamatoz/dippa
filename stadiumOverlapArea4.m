function A = stadiumOverlapArea4(s1,s2)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

% checks first if the stadiums are even near enough to each other

%d = sqrt((s1(3)-s2(3))^2 + (s1(4)-s2(4))^2);

if (norm(s1(3:4)-s2(3:4)) >= s1(1) + s1(2) + s2(1) + s2(2))
    A = 0;
    return
end

[intPoints, circle] = stadiumIntersectPoints4(s1,s2);

% E   0
% F   1
% E'  2
% F'  3
% EE' 4
% EF' 5
% FE' 6
% FF' 7

if isempty(intPoints)
    A = 0;
    return
end

if length(intPoints(1,:))==2
	K = [1;2];
else
	try
        K = convhull(intPoints(1,:), intPoints(2,:));
    catch
        A = 0;
        return
    end
end

rotationS1 = [cos(s1(5)), -sin(s1(5)); sin(s1(5)), cos(s1(5))];
rotationS2 = [cos(s2(5)), -sin(s2(5)); sin(s2(5)), cos(s2(5))];

if length(K)>2
    A = polyarea(intPoints(1,K), intPoints(2,K));
else
    A=0;
end

% Segment areas
% E

center = rotationS1*[s1(1);0]+[s1(3);s1(4)];
v=1;
while v < length(K)
    if sum(circle(K(v)) == [0 4 5]) && sum(circle(K(v+1)) == [0 4 5])
        acenter = arcCenter2(intPoints(:,K(v+1)),intPoints(:,K(v)),center,s1(3:4));
        if  inStadium(acenter,s2)
            A = A + segmentArea(intPoints(:,K(v)), intPoints(:,K(v+1)), s1(2));
            if norm(intPoints(:,K(v+1)) - intPoints(:,K(v))) > 1e-5
                v = v+1;
            end
        end
    end
    v = v+1;
end

% F
center = rotationS1*[-s1(1);0]+[s1(3);s1(4)];
v=1;
while v < length(K)
    if sum(circle(K(v)) == [1 6 7]) && sum(circle(K(v+1)) == [1 6 7])
        acenter = arcCenter2(intPoints(:,K(v+1)),intPoints(:,K(v)),center,s1(3:4));
        if  inStadium(acenter,s2)
            A = A + segmentArea(intPoints(:,K(v)), intPoints(:,K(v+1)), s1(2));
            if norm(intPoints(:,K(v+1)) - intPoints(:,K(v))) > 1e-5
                v = v+1;
            end
        end
    end
    v = v+1;
end

% F'
center = rotationS2*[-s2(1);0]+[s2(3);s2(4)];
v=1;
while v < length(K)
    if sum(circle(K(v)) == [3 5 7]) && sum(circle(K(v+1)) == [3 5 7])
        acenter = arcCenter2(intPoints(:,K(v+1)),intPoints(:,K(v)),center,s2(3:4));
        if  inStadium(acenter,s1)
            A = A + segmentArea(intPoints(:,K(v)), intPoints(:,K(v+1)), s2(2));
            if norm(intPoints(:,K(v+1)) - intPoints(:,K(v))) > 1e-5
                v = v+1;
            end
        end
    end
    v = v+1;
end

% E'
center = rotationS2*[s2(1);0]+[s2(3);s2(4)];
v=1;
while v < length(K)
    if sum(circle(K(v)) == [2 4 6]) && sum(circle(K(v+1)) == [2 4 6])
        acenter = arcCenter2(intPoints(:,K(v+1)),intPoints(:,K(v)),center,s2(3:4));
        if inStadium(acenter,s1)
            A = A + segmentArea(intPoints(:,K(v)), intPoints(:,K(v+1)), s2(2));
            if norm(intPoints(:,K(v+1)) - intPoints(:,K(v))) > 1e-5
                v = v+1;
            end
        end
    end
    v = v+1;
end

%A = norm(A);
end
