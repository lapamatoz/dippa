save1 = true;
zoomfactor = 1.1;

% Intuitive settings
for scenario = 1:6

    cyclicShoppingCart(scenario).Pbest(1).drawProblem(false);
    w = cyclicShoppingCart(scenario).problem('box').width;
    h = cyclicShoppingCart(scenario).problem('box').height;
    axis([-w/2 w/2 -h/2 h/2]*zoomfactor)
    figuresize(14, 9, 'cm')
    if save1
        saveas(gcf, ['shoppingCart-arrangement-',num2str(scenario),'.pdf']);
    end

end

close all

% Random settings

arrangements = [2,3,4];
for arr = arrangements
    threeShoppingCarts(1).Pbest(arr).drawProblem(false);
    w = threeShoppingCarts(1).problem('box').width;
    h = threeShoppingCarts(1).problem('box').height;
    axis([-w/2 w/2 -h/2 h/2]*zoomfactor)
    figuresize(14, 9, 'cm')
    if save1
        saveas(gcf, ['shoppingCart-rand-arrangement-three-',num2str(arr),'.pdf']);
    end
end

close all

arrangements = [1,2,5];
for arr = arrangements
    twoShoppingCarts(1).Pbest(arr).drawProblem(false);
    w = twoShoppingCarts(1).problem('box').width;
    h = twoShoppingCarts(1).problem('box').height;
    axis([-w/2 w/2 -h/2 h/2]*zoomfactor)
    figuresize(14, 9, 'cm')
    if save1
        saveas(gcf, ['shoppingCart-rand-arrangement-two-big-',num2str(arr),'.pdf']);
    end
end

close all

arrangements = [1,2,5];
for arr = arrangements
    twoShoppingCarts(2).Pbest(arr).drawProblem(false);
	w = twoShoppingCarts(2).problem('box').width;
    h = twoShoppingCarts(2).problem('box').height;
    axis([-w/2 w/2 -h/2 h/2]*zoomfactor)
    figuresize(14, 9, 'cm')
    if save1
        saveas(gcf, ['shoppingCart-rand-arrangement-two-mid-',num2str(arr),'.pdf']);
    end
end

close all

arrangements = [1,2,3];
for arr = arrangements
    oneShoppingCart(1).Pbest(arr).drawProblem(false);
    w = oneShoppingCart(1).problem('box').width;
    h = oneShoppingCart(1).problem('box').height;
    axis([-w/2 w/2 -h/2 h/2]*zoomfactor)
    figuresize(14, 9, 'cm')
    if save1
        saveas(gcf, ['shoppingCart-rand-arrangement-one-big-',num2str(arr),'.pdf']);
    end
end

close all

arrangements = [1,3,4];
for arr = arrangements
    oneShoppingCart(2).Pbest(arr).drawProblem(false);
    w = oneShoppingCart(2).problem('box').width;
    h = oneShoppingCart(2).problem('box').height;
    axis([-w/2 w/2 -h/2 h/2]*zoomfactor)
    figuresize(14, 9, 'cm')
    if save1
        saveas(gcf, ['shoppingCart-rand-arrangement-one-mid-',num2str(arr),'.pdf']);
    end
end

close all

arrangements = [1,3,4];
for arr = arrangements
    oneShoppingCart(3).Pbest(arr).drawProblem(false);
    w = oneShoppingCart(3).problem('box').width;
    h = oneShoppingCart(3).problem('box').height;
    axis([-w/2 w/2 -h/2 h/2]*zoomfactor)
    figuresize(14, 9, 'cm')
    if save1
        saveas(gcf, ['shoppingCart-rand-arrangement-one-sma-',num2str(arr),'.pdf']);
    end
end