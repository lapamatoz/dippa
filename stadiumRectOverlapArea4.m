function [A] = stadiumRectOverlapArea4(s1,s2) % s2 is rect
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

% checks if rectangle and stadium are even close together (could be done better!)

if (norm(s1(3:4)-s2(3:4)) >= s1(1) + s1(2) + s2(1) + s2(2))
    A = 0;
    return;
end

[intPoints, circle] = stadiumRectIntPoints4(s1,s2);

if isempty(intPoints)
    A = 0;
    return;
end

%drawStadium(s1)
%drawStadium(s2)
%daspect([1 1 1])
%hold on
%plot(intPoints(1,:),intPoints(2,:),'o');

if length(intPoints(1,:))==2
	K = [1;2];
else
	try
        K = convhull(intPoints(1,:), intPoints(2,:));
    catch
        A = 0;
        return;
    end
end

%plot(intPoints(1,K), intPoints(2,K),['--','b']);


rotationS1 = [cos(s1(5)), -sin(s1(5)); sin(s1(5)), cos(s1(5))];
%rotationS2 = [cos(s2(5)), -sin(s2(5)); sin(s2(5)), cos(s2(5))];

if length(K) > 2
    A = polyarea(intPoints(1,K), intPoints(2,K));
else
    A = 0;
end

% if true

 %plot(intPoints(1,K), intPoints(2,K),['-','m']);
 
% Segment areas
% E
 center = rotationS1*[s1(1);0]+[s1(3);s1(4)];
 v=1;
 while v < length(K)
     if circle(K(v)) == 0 && circle(K(v+1)) == 0
     %if pointOnCircle(intPoints(:,K(v)), center, s1(2))% && ~insideStadium(intPoints(:,K(v)),s1)
         acenter = arcCenter2(intPoints(:,K(v+1)),intPoints(:,K(v)),center,s1(3:4));
         %ahcenter = 0.08*acenter + 0.92*center;
         %ahcenter = arcHalfCenter(intPoints(:,K(v+1)),intPoints(:,K(v)),center);
         if inRectangle(acenter,s2)% && ~inpolygon(ahcenter(1),ahcenter(2),intPoints(1,K),intPoints(2,K)) % && ~insideStadium(intPoints(:,K(v+1)),s1)
             A = A + segmentArea(intPoints(:,K(v)), intPoints(:,K(v+1)), s1(2));
             %intPoints = [intPoints, arcCenter(intPoints(:,K(v+1)),intPoints(:,K(v)),center)];
             %K = [K(1:v); length(intPoints); K(v+1:end)];
             %if norm(intPoints(:,K(v+1)) - intPoints(:,K(v))) > 1e-5
                 v = v+1;
             %end
             %K(v)
             %area
         end
     end
     v = v+1;
 end
 
 % F
 center = rotationS1*[-s1(1);0]+[s1(3);s1(4)];
 v=1;
 while v < length(K)
     if circle(K(v)) == 1 && circle(K(v+1)) == 1
         acenter = arcCenter2(intPoints(:,K(v+1)),intPoints(:,K(v)),center,s1(3:4));
         if inRectangle(acenter,s2)
             A = A + segmentArea(intPoints(:,K(v)), intPoints(:,K(v+1)), s1(2));
                 v = v+1;
         end
     end
     v = v+1;
 end
 
%plot(intPoints(1,K), intPoints(2,K),['--','g']);
 %A = norm(A);
end

