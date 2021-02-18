% Problem with rectangle corners
BFGS(4).Pbest(1).drawProblem(false)
figuresize(16, 10, 'cm')
if save1
    saveas(gcf, ['rectangleCorners-',num2str(scenario),'.pdf']);
end