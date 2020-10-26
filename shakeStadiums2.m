function [stadiums] = shakeStadiums2(stadiums, boxSize)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
minR = max(stadiums(2,:));
minA = max(stadiums(1,:));
n = length(stadiums(1,:));

r = randperm(n);
%r=1:n;

boxSize = boxSize - [minA/2+minR, minR];

width = boxSize(1)*2;
height = boxSize(2)*2;
totalArea = width*height;
pointArea = totalArea/n;
len = sqrt(pointArea);
q = 1;

for i = 0.5:width/len
    for j = 0.5:height/len
        if q <= n/2
                stadiums(3,r(q))   =   (i)*len - boxSize(1) - len/2;
                stadiums(4,r(q))   =   j*len - boxSize(2) - len/2;
                
                
                stadiums(3,r(n-q+1))   =   -((i)*len - boxSize(1) - len/2);
                stadiums(4,r(n-q+1))   =   -(j*len - boxSize(2) - len/2);
        end
        q = q+1;
    end
end

q = 1;

for i = 0.5:width/len
    for j = 0.5:height/len
        if q <= n/4 && mod(q,2)==1
                stadiums(3,r(q+1))   =   -((i)*len - boxSize(1) - len/2);
                stadiums(4,r(q+1))   =   j*len - boxSize(2) - len/2;
                
                
                stadiums(3,r(n-q))   =   ((i)*len - boxSize(1) - len/2);
                stadiums(4,r(n-q))   =   -(j*len - boxSize(2) - len/2);
        end
        q = q+1;
    end
end

%stadiums(3:4,r(ceil(n/4-1))) = [0,minR];
%stadiums(3:4,r(floor(n/2+1))) = [0,-minR];

%stadiums(5,:) = rand(1,n)*2*pi;
%stadiums(5,:) = zeros(1,n);
stadiums(5,:) = (2*rand(1,n)-1)*0.5;

for q = 1:n
    stadiums(3,q) = stadiums(3,q) + 0.5*(2*rand()-1)*stadiums(1,2);
    stadiums(4,q) = stadiums(4,q) + 0.5*(2*rand()-1)*stadiums(1,2);
end

end