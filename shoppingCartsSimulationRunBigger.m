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

caps = shape;
caps.height = 275 / 100 * 1.2;
caps.width  = 455 / 100 * 1.5;

q = 1;
oneShoppingCart = resultsAnalysis;
for boxSize = 1:3
    oneShoppingCart(q) = resultsAnalysis;
    oneShoppingCart(q).name = "One shopping cart, placed randomly, bigger";
    oneShoppingCart(q).name = join([oneShoppingCart(q).name, "box-", num2str(boxSize)]);
    
    oneShoppingCart(q).problem = containers.Map;
    oneShoppingCart(q) = oneShoppingCart(q).initialize();
    oneShoppingCart(q).problem('method2') = @(P,p)P.optimizeCyclic('triangle',p);
    oneShoppingCart(q).problem('squared') = 'no';
    oneShoppingCart(q).problem('changeIter') = 0;
    oneShoppingCart(q).problem('h2Step') = 'diminishing';
    oneShoppingCart(q).problem('shape1') = caps;
    oneShoppingCart(q).problem('shape2') = caps;
    sc1 = oneShoppingCart(q).problem('staticShape');
    sc1.static = false;
    
    oneShoppingCart(q).problem("objectPlacement") = "anywhere";
    oneShoppingCart(q).problem("staticObjectPlacement") = "anywhere";
            
    sc2 = sc1;

    if boxSize == 1
        oneShoppingCart(q).problem('box') = bigbox;
    elseif boxSize == 2
        oneShoppingCart(q).problem('box') = midbox;
    elseif boxSize == 3
        oneShoppingCart(q).problem('box') = smabox;
    end
    B = oneShoppingCart(q).problem('box');
    oneShoppingCart(q).problem('staticShape') = sc1;
    q = q+1;
end

q = 1;
twoShoppingCarts = resultsAnalysis;
for boxSize = 1:2
    twoShoppingCarts(q) = resultsAnalysis;
    twoShoppingCarts(q).name = "Two shopping carts, placed randomly, bigger";
    twoShoppingCarts(q).name = join([twoShoppingCarts(q).name, "box-", num2str(boxSize)]);
    
    twoShoppingCarts(q).problem = containers.Map;
    twoShoppingCarts(q) = twoShoppingCarts(q).initialize();
    twoShoppingCarts(q).problem('method2') = @(P,p)P.optimizeCyclic('triangle',p);
    twoShoppingCarts(q).problem('squared') = 'no';
    twoShoppingCarts(q).problem('changeIter') = 0;
    twoShoppingCarts(q).problem('h2Step') = 'diminishing';
    twoShoppingCarts(q).problem('shape1') = caps;
    twoShoppingCarts(q).problem('shape2') = caps;
    sc1 = twoShoppingCarts(q).problem('staticShape');
    sc1.static = false;
    
    twoShoppingCarts(q).problem("objectPlacement") = "anywhere";
    twoShoppingCarts(q).problem("staticObjectPlacement") = "anywhere";

    if boxSize == 1
        twoShoppingCarts(q).problem('box') = bigbox;
    elseif boxSize == 2
        twoShoppingCarts(q).problem('box') = midbox;
    elseif boxSize == 3
        twoShoppingCarts(q).problem('box') = smabox;
    end
    B = twoShoppingCarts(q).problem('box');
    twoShoppingCarts(q).problem('staticShape') = [sc1,sc1];
    q = q+1;
end

q = 1;
threeShoppingCarts = resultsAnalysis;
for boxSize = 1:1
    threeShoppingCarts(q) = resultsAnalysis;
    threeShoppingCarts(q).name = "Three shopping carts, placed randomly, bigger";
    threeShoppingCarts(q).name = join([threeShoppingCarts(q).name, "box-", num2str(boxSize)]);
    
    threeShoppingCarts(q).problem = containers.Map;
    threeShoppingCarts(q) = threeShoppingCarts(q).initialize();
    threeShoppingCarts(q).problem('method2') = @(P,p)P.optimizeCyclic('triangle',p);
    threeShoppingCarts(q).problem('squared') = 'no';
    threeShoppingCarts(q).problem('changeIter') = 0;
    threeShoppingCarts(q).problem('h2Step') = 'diminishing';
    threeShoppingCarts(q).problem('shape1') = caps;
    threeShoppingCarts(q).problem('shape2') = caps;
    sc1 = threeShoppingCarts(q).problem('staticShape');
    sc1.static = false;
    
    threeShoppingCarts(q).problem("objectPlacement") = "anywhere";
    threeShoppingCarts(q).problem("staticObjectPlacement") = "anywhere";

    if boxSize == 1
        threeShoppingCarts(q).problem('box') = bigbox;
    elseif boxSize == 2
        threeShoppingCarts(q).problem('box') = midbox;
    elseif boxSize == 3
        threeShoppingCarts(q).problem('box') = smabox;
    end
    B = threeShoppingCarts(q).problem('box');
    threeShoppingCarts(q).problem('staticShape') = [sc1,sc1,sc1];
    q = q+1;
end

r = 2;
r1 = r;

load = true;

if load
    for q = 1:length(twoShoppingCarts)
        twoShoppingCarts(q) = twoShoppingCarts(q).load(twoShoppingCarts(q).name);
    end
    for q = 1:length(oneShoppingCart)
        oneShoppingCart(q) = oneShoppingCart(q).load(oneShoppingCart(q).name);
    end
    for q = 1:length(threeShoppingCarts)
        threeShoppingCarts(q) = threeShoppingCarts(q).load(threeShoppingCarts(q).name);
    end
end

maxLen = 0;
for q = 1:length(twoShoppingCarts)
    maxLen = max(maxLen, length(twoShoppingCarts(q).res));
end
for q = 1:length(oneShoppingCart)
    maxLen = max(maxLen, length(oneShoppingCart(q).res));
end
for q = 1:length(threeShoppingCarts)
    maxLen = max(maxLen, length(threeShoppingCarts(q).res));
end

for q = 1:length(twoShoppingCarts)
    twoShoppingCarts(q) = twoShoppingCarts(q).simulate(min(3*r, maxLen + r - length(twoShoppingCarts(q).res)),"no");
    twoShoppingCarts(q).save();
end
for q = 1:length(oneShoppingCart)
    oneShoppingCart(q) = oneShoppingCart(q).simulate(min(3*r, maxLen + r - length(oneShoppingCart(q).res)),"no");
    oneShoppingCart(q).save();
end
for q = 1:length(threeShoppingCarts)
    threeShoppingCarts(q) = threeShoppingCarts(q).simulate(min(3*r, maxLen + r - length(threeShoppingCarts(q).res)),"no");
    threeShoppingCarts(q).save();
end

disp('One cart')
m = [];
for q = 1:length(oneShoppingCart)
    m(q) = 0;
    for w = 1:length(oneShoppingCart(q).res)
        m(q) = max(m(q), length(oneShoppingCart(q).res{w}));
    end
    m(q) = m(q)-1;
    disp(['q = ', num2str(q), ': ', num2str(m(q))]);
end

disp('Two carts')
m = [];
for q = 1:length(twoShoppingCarts)
    m(q) = 0;
    for w = 1:length(twoShoppingCarts(q).res)
        m(q) = max(m(q), length(twoShoppingCarts(q).res{w}));
    end
    m(q) = m(q)-1;
    disp(['q = ', num2str(q), ': ', num2str(m(q))]);
end

disp('Three carts')
m = [];
for q = 1:length(threeShoppingCarts)
    m(q) = 0;
    for w = 1:length(threeShoppingCarts(q).res)
        m(q) = max(m(q), length(threeShoppingCarts(q).res{w}));
    end
    m(q) = m(q)-1;
    disp(['q = ', num2str(q), ': ', num2str(m(q))]);
end



%%% NOT RANDOMIZED

cyclicShoppingCart = resultsAnalysis;
for q = 1:6
    cyclicShoppingCart(q) = resultsAnalysis;
    cyclicShoppingCart(q).problem = containers.Map;
    cyclicShoppingCart(q) = cyclicShoppingCart(q).initialize();
    cyclicShoppingCart(q).problem('method2') = @(P,p)P.optimizeCyclic('triangle',p);
    cyclicShoppingCart(q).problem('squared') = 'no';
    cyclicShoppingCart(q).problem('changeIter') = 0;
    cyclicShoppingCart(q).problem('h2Step') = 'diminishing';
    cyclicShoppingCart(q).problem("objectPlacement") = "anywhere";
    cyclicShoppingCart(q).problem("staticObjectPlacement") = "leaveBe"; %"anywhere";
    
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
    cyclicShoppingCart(q).problem('shape1') = caps;
    cyclicShoppingCart(q).problem('shape2') = caps;
    if q<=3
        r = cyclicShoppingCart(q).problem("staticShape");
        B = cyclicShoppingCart(q).problem('box');
        shoppingCartWidth = r.width;
        r.width = r.height;
        r.height = shoppingCartWidth;
        r.position = [B.width/2  -  r.width/2,...
                     -B.height/2 + r.height/2];
        cyclicShoppingCart(q).problem("staticShape") = r;
        cyclicShoppingCart(q).name = join([cyclicShoppingCart(q).name, "horz bigger"]);
    else
        r = cyclicShoppingCart(q).problem("staticShape");
        B = cyclicShoppingCart(q).problem('box');
        r.position = [B.width/2  -  r.width/2,...
                     -B.height/2 + r.height/2];
        cyclicShoppingCart(q).problem("staticShape") = r;
        cyclicShoppingCart(q).name = join([cyclicShoppingCart(q).name, "vert bigger"]);
    end
end

if load
    for q = 1:6
        cyclicShoppingCart(q) = cyclicShoppingCart(q).load(cyclicShoppingCart(q).name);
    end
end

maxLen = 0;
for q = 1:6
    maxLen = max(maxLen, length(cyclicShoppingCart(q).res));
end

for q = 1:6
    cyclicShoppingCart(q) = cyclicShoppingCart(q).simulate(min(3*r1, maxLen + r1 - length(cyclicShoppingCart(q).res)),"no");
    cyclicShoppingCart(q).save();
end

mS = [];
for q = 1:length(cyclicShoppingCart)
    mS(q) = 0;
    for w = 1:length(cyclicShoppingCart(q).res)
        mS(q) = max(mS(q), length(cyclicShoppingCart(q).res{w}));
    end
    mS(q) = mS(q)-1;
    disp(['q = ', num2str(q), ': ', num2str(mS(q))]);
end

figure; hold on;
bar(1:3:6,mS(mod(1:6,3)==1))
bar(1:3:6,mS(mod(1:6,3)==2))
bar(1:3:6,mS(mod(1:6,3)==0))
xlabel("Shopping cart orientation (vertical / horizontal)")
ylabel("Max persons")
legend("Big box", "Mid box", "Small box", 'Location', 'southwest')
title("One shopping cart")

% One cart
% q = 1: 25
% q = 2: 15
% q = 3: 8
% Two carts
% q = 1: 18
% q = 2: 8
% q = 3: 0
% Three carts
% q = 1: 12
% q = 2: 0
% q = 3: 0