numOfCarts = 2;
size = 1;

if numOfCarts == 1
    for q = 1:length(oneShoppingCart(size).Pbest)
        oneShoppingCart(size).Pbest(q).drawProblem(false)
    end
elseif numOfCarts == 2
    for q = 1:length(twoShoppingCarts(size).Pbest)
        twoShoppingCarts(size).Pbest(q).drawProblem(false)
    end
else
    for q = 1:length(threeShoppingCarts(size).Pbest)
        threeShoppingCarts(size).Pbest(q).drawProblem(false)
    end
end