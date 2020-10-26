function h = drawStadium(s,filled, fillColor, strokeColor)
    hold on
    rotationMatrix = [cos(s(5)), -sin(s(5)); sin(s(5)), cos(s(5))];
    points = [-s(1), -s(1), s(1), s(1), -s(1)
              -s(2), s(2), s(2), -s(2), -s(2)];
    points = rotationMatrix * points;

    circlePoints = [-s(1), s(1); 0, 0];
    circlePoints = rotationMatrix * circlePoints;
    %drawCircle(circlePoints(1,1)+s(3),circlePoints(2,1)+s(4),s(2),true);
    %drawCircle(circlePoints(1,2)+s(3),circlePoints(2,2)+s(4),s(2),true);
    
    if filled
        h = fill(points(1,:)+s(3),points(2,:)+s(4),fillColor);
        h.LineWidth = 0.1;
        drawCircle(circlePoints(1,1)+s(3),circlePoints(2,1)+s(4),s(2),true, fillColor, strokeColor);
        drawCircle(circlePoints(1,2)+s(3),circlePoints(2,2)+s(4),s(2),true, fillColor, strokeColor);
    else
        h = plot(points(1,:)+s(3),points(2,:)+s(4),'-','color',strokeColor);
        drawCircle(circlePoints(1,1)+s(3),circlePoints(2,1)+s(4),s(2),false, fillColor, strokeColor);
        drawCircle(circlePoints(1,2)+s(3),circlePoints(2,2)+s(4),s(2),false, fillColor, strokeColor);
    end
    
    hold off;
    daspect([1 1 1]);
end