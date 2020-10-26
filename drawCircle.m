function [] = drawCircle(x,y,r, filled, fillColor, strokeColor)
    th = 0:pi/50:2*pi;
    xunit = r * cos(th) + x;
    yunit = r * sin(th) + y;
    
    if filled
        h = fill(xunit, yunit, fillColor);
        h.LineWidth = 0.1;
    else
        plot(xunit, yunit,'-','color',strokeColor);
    end
end