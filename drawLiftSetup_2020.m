function [] = drawLiftSetup(stadiums,types,boxSize, cycleColor, cycleIndex)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    fillColor = [101/255 167/255 1];
    fillColor = fillColor.^0.7;
    %strokeColor = fillColor*0.8;
    strokeColor = 'k';
    suitcaseColor = sqrt(fillColor);
    
    
    figure;
    hold on
    for v = 1:length(stadiums(1,:))
        if types(v) == "capsule"
            drawStadium(stadiums(1:5,v), true, fillColor, strokeColor);
        elseif types(v) == "rectangle"
            drawRectangle(stadiums(1:5,v), true, suitcaseColor, strokeColor);
        end
    end
    
    for v = 1:length(stadiums(1,:))
        if types(v) == "capsule"
            drawStadium(stadiums(1:5,v), false, fillColor, strokeColor);
        elseif types(v) == "rectangle"
            drawRectangle(stadiums(1:5,v), false, suitcaseColor, strokeColor);
        end
    end
    %drawStadiums(stadiums, true, fillColor, strokeColor);
    %feetStadiums = [stadiums(1:2,:)*suitcaseC; stadiums(3:5,:)];
    %drawRectangles(suitcaseCoordinates2(suitcases, feetStadiums),true, suitcaseColor, strokeColor);
    
    %drawStadiums(feetStadiums,false, fillColor, strokeColor);
    
    %drawRectangles(suitcaseCoordinates2(suitcases, feetStadiums),false, suitcaseColor, strokeColor);
    %drawStadiums(stadiums,false, fillColor, strokeColor);
    hold on
    
    if cycleColor
        hold on
        drawStadium(stadiums(:,cycleIndex),true, [1 103/255 71/255], strokeColor);
        hold on
        drawStadium(stadiums(:,cycleIndex),false, [1 103/255 71/255], strokeColor);
    end
    
    hold on
    plot([boxSize(1); -boxSize(1); -boxSize(1); boxSize(1); boxSize(1)], [boxSize(2); boxSize(2); -boxSize(2); -boxSize(2); boxSize(2)],'k');
    axis off
    %title(['A/n = ' num2str(finalArea/1e6) ' m²'])
end