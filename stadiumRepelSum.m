function [out] = stadiumRepelSum(x,v,stadiums,boxSize)
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here
out = 0;
pivotStadium = [stadiums(1:2,v); x.'];
% if v > 2
%     for q = 1:v-1
%         out = out + 1/((pivotStadium(3) - stadiums(3,q))^2 + (pivotStadium(4) - stadiums(4,q))^2 + 1);
%     end
% end
% 
% if v ~= length(stadiums(1,:))
%     for q = v+1:length(stadiums(1,:))
%         out = out + 1/((pivotStadium(3) - stadiums(3,q))^2 + (pivotStadium(4) - stadiums(4,q))^2 + 1);
%     end
% end
bSq = boxSize(1)*boxSize(2);
%norm(pivotStadium(3:4) - stadiums(3:4,q))
out = sum(1./(vecnorm(stadiums(3:4,:)-pivotStadium(3:4)).^2/bSq+1));
out = out - 1./(vecnorm(stadiums(3:4,v)-pivotStadium(3:4)).^2/bSq+1);

end

