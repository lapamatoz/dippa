%%%%% BIG BOX
bigbox = shape;
bigbox.height = 1700 / 100;
bigbox.width = 2350 / 100;
bigbox.type = 'rectangle';

%%%%% MID BOX
midbox = shape;
midbox.height = 1400 / 100;
midbox.width = 2000 / 100;
midbox.type = 'rectangle';

%%%%% SMALL BOX
smabox = shape;
smabox.height = 1350 / 100;
smabox.width = 1400 / 100;
smabox.type = 'rectangle';

BFGS = resultsAnalysis;
for q = 1:6
    BFGS(q) = resultsAnalysis;
    BFGS(q).problem = containers.Map;
    BFGS(q) = BFGS(q).initialize();
    BFGS(q).problem('method2') = @(P,p)P.optimizeBFGS(p);
    BFGS(q).problem('squared') = 'no';
    BFGS(q).problem('changeIter') = 0;
    BFGS(q).problem('h2Step') = 'no';
    BFGS(q).problem('staticShape') = [];
    BFGS(q).name = "BFGS";
    if q == 1 || q == 4
        BFGS(q).problem('box') = bigbox;
        BFGS(q).name = join([BFGS(q).name, "bigBox"]);
    elseif q == 2 || q == 5
        BFGS(q).problem('box') = midbox;
        BFGS(q).name = join([BFGS(q).name, "midBox"]);
    elseif q == 3 || q == 6
        BFGS(q).problem('box') = smabox;
        BFGS(q).name = join([BFGS(q).name, "smallBox"]);
    end
    if q<=3
        BFGS(q).problem('shape1') = BFGS(q).problem('shape1').capsule;
        BFGS(q).name = join([BFGS(q).name, "capsules"]);
    else
        BFGS(q).name = join([BFGS(q).name, "capsRect"]);
    end
end

Matlab = resultsAnalysis;
for q = 1:6
    Matlab(q) = resultsAnalysis;
    Matlab(q).problem = containers.Map;
    Matlab(q) = Matlab(q).initialize();
    Matlab(q).problem('method2') = @(P,p)P.optimizeCyclic('Matlab',p);
    Matlab(q).problem('squared') = 'no';
    Matlab(q).problem('changeIter') = 0;
    Matlab(q).problem('h2Step') = 'no';
    Matlab(q).problem('staticShape') = [];
    Matlab(q).name = "Matlab (BSc Thesis)";
    if q == 1 || q == 4
        Matlab(q).problem('box') = bigbox;
        Matlab(q).name = join([Matlab(q).name, "bigBox"]);
    elseif q == 2 || q == 5
        Matlab(q).problem('box') = midbox;
        Matlab(q).name = join([Matlab(q).name, "midBox"]);
    elseif q == 3 || q == 6
        Matlab(q).problem('box') = smabox;
        Matlab(q).name = join([Matlab(q).name, "smallBox"]);
    end
    if q<=3
        Matlab(q).problem('shape1') = Matlab(q).problem('shape1').capsule;
        Matlab(q).name = join([Matlab(q).name, "capsules"]);
    else
        Matlab(q).name = join([Matlab(q).name, "capsRect"]);
    end
end

cyclic = resultsAnalysis;
for q = 1:6
    cyclic(q) = resultsAnalysis;
    cyclic(q).problem = containers.Map;
    cyclic(q) = cyclic(q).initialize();
    cyclic(q).problem('method2') = @(P,p)P.optimizeCyclic('Matlab',p);
    cyclic(q).problem('squared') = 'no';
    cyclic(q).problem('changeIter') = 0;
    cyclic(q).problem('h2Step') = 'no';
    cyclic(q).problem('staticShape') = [];
    cyclic(q).name = "New Algorithm";
    if q == 1 || q == 4
        cyclic(q).problem('box') = bigbox;
        cyclic(q).name = join([cyclic(q).name, "bigBox"]);
    elseif q == 2 || q == 5
        cyclic(q).problem('box') = midbox;
        cyclic(q).name = join([cyclic(q).name, "midBox"]);
    elseif q == 3 || q == 6
        cyclic(q).problem('box') = smabox;
        cyclic(q).name = join([cyclic(q).name, "smallBox"]);
    end
    if q<=3
        cyclic(q).problem('shape1') = cyclic(q).problem('shape1').capsule;
        cyclic(q).name = join([cyclic(q).name, "capsules"]);
    else
        cyclic(q).name = join([cyclic(q).name, "capsRect"]);
    end
end

cyclicShoppingCart = resultsAnalysis;
for q = 1:6
    cyclicShoppingCart(q) = resultsAnalysis;
    cyclicShoppingCart(q).problem = containers.Map;
    cyclicShoppingCart(q) = cyclicShoppingCart(q).initialize();
    cyclicShoppingCart(q).problem('method2') = @(P,p)P.optimizeCyclic('triangle',p);
    cyclicShoppingCart(q).problem('squared') = 'no';
    cyclicShoppingCart(q).problem('changeIter') = 0;
    cyclicShoppingCart(q).problem('h2Step') = 'no';
    cyclicShoppingCart(q).name = "New Algorithm Shopping Carts";
    if q == 1 || q == 4
        cyclicShoppingCart(q).problem('box') = bigbox;
        cyclicShoppingCart(q).name = join([cyclicShoppingCart(q).name, "bigBox"]);
    elseif q == 2 || q == 5
        cyclicShoppingCart(q).problem('box') = midbox;
        cyclicShoppingCart(q).name = join([cyclicShoppingCart(q).name, "midBox"]);
    elseif q == 3 || q == 6
        cyclicShoppingCart(q).problem('box') = smabox;
        cyclicShoppingCart(q).name = join([cyclicShoppingCart(q).name, "smallBox"]);
    end
    cyclicShoppingCart(q).problem('shape1') = cyclicShoppingCart(q).problem('shape1').capsule;
    if q<=3
        r = cyclicShoppingCart(q).problem("staticShape");
        B = cyclicShoppingCart(q).problem('box');
        shoppingCartWidth = r.width;
        r.width = r.height;
        r.height = shoppingCartWidth;
        r.position = [B.width/2  -  r.width/2,...
                     -B.height/2 + r.height/2];
        cyclicShoppingCart(q).problem("staticShape") = r;
        cyclicShoppingCart(q).name = join([cyclicShoppingCart(q).name, "horz"]);
    else
        cyclicShoppingCart(q).name = join([cyclicShoppingCart(q).name, "vert"]);
    end
end


twoShoppingCarts = resultsAnalysis;
q = 1;
for orient1 = 1:2 % 1: pysty, 2: vaaka
    for orient2 = 1:2 % 1: pysty, 2: vaaka
        for corner1 = 1
            for corner2 = 1:5 % 1: ekan päällä, 2: ekan vasemmalla puolella, 3: ylä-o, 4: ylä-v, 5: ala-v
                for boxSize = 1:3 % 1: big, 2: mid, 3: small
                    twoShoppingCarts(q).name = "New Algorithm Shopping Carts";
                    twoShoppingCarts(q) = resultsAnalysis;
                    twoShoppingCarts(q).name = join([twoShoppingCarts(q).name, "box-", num2str(boxSize),...
                                                                                   "_orient1-", num2str(orient1),...
                                                                                   "_orient2-", num2str(orient2),...
                                                                                   "_corner2-", num2str(corner2),...
                                                                                   ]);
                    twoShoppingCarts(q).problem = containers.Map;
                    twoShoppingCarts(q) = twoShoppingCarts(q).initialize();
                    twoShoppingCarts(q).problem('method2') = @(P,p)P.optimizeCyclic('Matlab',p);
                    twoShoppingCarts(q).problem('squared') = 'no';
                    twoShoppingCarts(q).problem('changeIter') = 0;
                    twoShoppingCarts(q).problem('h2Step') = 'diminishing';
                    twoShoppingCarts(q).problem('shape1') = twoShoppingCarts(q).problem('shape1').capsule;
                    sc1 = twoShoppingCarts(q).problem('staticShape');
                    sc2 = sc1;
                    
                    if boxSize == 1
                        twoShoppingCarts(q).problem('box') = bigbox;
                    elseif boxSize == 2
                        twoShoppingCarts(q).problem('box') = midbox;
                    elseif boxSize == 3
                        twoShoppingCarts(q).problem('box') = smabox;
                    end
                    B = twoShoppingCarts(q).problem('box');
                    if orient1 == 2
                        scWidth = sc1.width;
                        sc1.width = sc1.height;
                        sc1.height = scWidth;
                        sc1.position = [B.width/2  - sc1.width/2,...
                                       -B.height/2 + sc1.height/2];
                    elseif orient1 == 1
                        sc1.position = [B.width/2  - sc1.width/2,...
                                       -B.height/2 + sc1.height/2];
                    end
                    if orient2 == 2
                        scWidth = sc2.width;
                        sc2.width = sc2.height;
                        sc2.height = scWidth;
                    end
                    
                    if corner2 == 1
                        sc2.position = [B.width/2  - sc2.width/2,...
                                       -B.height/2 + sc1.height + sc2.height/2];
                    elseif corner2 == 2
                        sc2.position = [B.width/2  - sc1.width - sc2.width/2,...
                                       -B.height/2 + sc2.height/2];
                    elseif corner2 == 3
                        sc2.position = [B.width/2  - sc2.width/2,...
                                        B.height/2 - sc2.height/2];
                    elseif corner2 == 4
                        sc2.position = [-B.width/2  + sc2.width/2,...
                                         B.height/2 - sc2.height/2];
                    elseif corner2 == 5
                        sc2.position = [-B.width/2  + sc2.width/2,...
                                        -B.height/2 + sc2.height/2];
                    end
                    twoShoppingCarts(q).problem('staticShape') = [sc1,sc2];
                    q = q+1;
                end
            end
        end
    end
end