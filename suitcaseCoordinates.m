function [out] = suitcaseCoordinates(sc, st, alpha, offset)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% returns x,y and theta for suitcase and stadium with x,y,theta=0.
% -1 <= offset <= 1
% 0 <= alpha <= 2*pi
alpha = mod(alpha,2*pi);
offset = offset*sc(1);

% if alpha < pi/2
%     x = (alpha-pi/4)*4/pi*st(1)/2 + offset;
%     y = st(2) + sc(2);
%     theta = 0;
%     
% elseif alpha < 2*pi/2
%     temp1 = (3*pi/4 - alpha)*2;
%     x = st(1)/2 + cos(temp1)*(st(2)+sc(2)) + cos(temp1 - pi/2) * offset;
%     y = sin(temp1)*(st(2)+sc(2)) + sin(temp1 - pi/2) * offset;
%     theta = temp1 + pi/2;
%     
% elseif alpha < 3*pi/2
%     x = -(alpha-5*pi/4)*4/pi*st(1)/2 - offset;
%     y = -st(2) - sc(2);
%     theta = 0;
%     
% else
%     temp1 = (7*pi/4 - alpha)*2 + pi;
%     x = -st(1)/2 + cos(temp1)*(st(2)+sc(2)) + cos(temp1 - pi/2) * offset;
%     y = sin(temp1)*(st(2)+sc(2)) + sin(temp1 - pi/2) * offset;
%     theta = temp1 + pi/2;
% end

if alpha < pi/2
    x = (4*alpha/pi-1)*st(1) + offset;
    y = st(2) + sc(2);
    theta = 0;
    
elseif alpha < 2*pi/2
    %temp1 = (3*pi/4 - alpha)*2;
    x = st(1) - sin(2*alpha)*(st(2)+sc(2)) - cos(2*alpha) * offset;
    y = -cos(2*alpha)*(st(2)+sc(2)) + sin(2*alpha) * offset;
    theta = -2*alpha;
    
elseif alpha < 3*pi/2
    x = (5-4*alpha/pi)*st(1) - offset;
    y = -st(2) - sc(2);
    theta = 0;
    
else
    %temp1 = (7*pi/4 - alpha)*2 + pi;
    x = -st(1) + sin(2*alpha)*(st(2)+sc(2)) + cos(2*alpha) * offset;
    y = cos(2*alpha)*(st(2)+sc(2)) - sin(2*alpha) * offset;
    theta = pi-2*alpha;
end

out = [x;y;theta];
end