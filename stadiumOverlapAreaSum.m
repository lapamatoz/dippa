function [out] = stadiumOverlapAreaSum(x,v,stadiums,sq)
%UNTITLED8 Summary of this function goes here
%   x as a vertical
out = 0;
pivotStadium = [stadiums(1:2,v); x.'];

if v > 1
    for q = 1:v-1
        if sq
            out = out + xsq(stadiumOverlapArea4(pivotStadium, stadiums(:,q)));
        else
            out = out + stadiumOverlapArea4(pivotStadium, stadiums(:,q));
        end
    end
end

if v ~= length(stadiums(1,:))
    for q = v+1:length(stadiums(1,:))
        if sq
            out = out + xsq(stadiumOverlapArea4(pivotStadium, stadiums(:,q)));
        else
            out = out + stadiumOverlapArea4(pivotStadium, stadiums(:,q));
        end
    end
end

    function out = xsq(x)
        out = (x^2 - x)*(2/((x + 1)^8 + 1)) + x;
    end


end