function h = drawRectangle(r, filled, fillColor, strokeColor)
    hold on
    rotationMatrix = [cos(r(5)), -sin(r(5)); sin(r(5)), cos(r(5))];
    points = [-r(1), -r(1), r(1), r(1), -r(1)
              -r(2), r(2), r(2), -r(2), -r(2)];
    points = rotationMatrix * points;
    if filled
        h1 = fill(points(1,:)+r(3),points(2,:)+r(4), fillColor);
        h1.LineWidth = 0.1;
    else
        h = plot(points(1,:)+r(3),points(2,:)+r(4),'-','color',strokeColor);
    end
    daspect([1 1 1]);
    hold off
end