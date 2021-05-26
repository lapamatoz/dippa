r = 0;

load = true;

if load
    for q = 1:6
        gradM(q) = gradM(q).load(gradM(q).name);
        BFGS(q) = BFGS(q).load(BFGS(q).name);
        %gradMNoLine(q) = gradMNoLine(q).load(gradMNoLine(q).name);
        %BFGSNoLine(q) = BFGSNoLine(q).load(BFGSNoLine(q).name);
        Matlab(q) = Matlab(q).load(Matlab(q).name);
        cyclic(q) = cyclic(q).load(cyclic(q).name);
        %%% OTA POIS SEURAAVALLA KERRALLA
        %gradM(q).res = {};
        %gradM(q).Pbest = [];
        cyclicShoppingCart(q) = cyclicShoppingCart(q).load(cyclicShoppingCart(q).name);
        %cyclicShoppingCart(q).res = {};
        %cyclicShoppingCart(q).res{end} = {};
        %cyclicShoppingCart(q).problem('objectPlacement') = "anywhere";
        %cyclicShoppingCart(q).problem('staticObjectPlacement') = "leaveBe";
    end
    %for q = 1:length(twoShoppingCarts)
        %twoShoppingCarts(q) = twoShoppingCarts(q).load(twoShoppingCarts(q).name);
        %twoShoppingCarts(q).res{end} = {};
        %twoShoppingCarts(q).problem('objectPlacement') = "anywhere";
        %twoShoppingCarts(q).problem('staticObjectPlacement') = "leaveBe";
    %end
end

maxLen = 0;
for q = 1:6
    %maxLen = max(maxLen, length(gradM(q).res));
    %maxLen = max(maxLen, length(BFGS(q).res));
    maxLen = max(maxLen, length(gradMNoLine(q).res));
    maxLen = max(maxLen, length(BFGSNoLine(q).res));
    %maxLen = max(maxLen, length(Matlab(q).res));
    %maxLen = max(maxLen, length(cyclic(q).res));
    %maxLen = max(maxLen, length(cyclicShoppingCart(q).res));
end

%for q = 1:length(twoShoppingCarts)
%    maxLen = max(maxLen, length(twoShoppingCarts(q).res));
%end

for q = 1:3 % !!HUOM!!
    %gradM(q) = gradM(q).simulate(min(3*r, maxLen + r - length(gradM(q).res)),"no");
    %gradM(q).save();
    %BFGS(q) = BFGS(q).simulate(min(3*r, maxLen + r - length(BFGS(q).res)),"no");
    %BFGS(q).save();
    %gradMNoLine(q) = gradMNoLine(q).simulate(min(3*r, maxLen + r - length(gradMNoLine(q).res)),"no");
    %gradMNoLine(q).save();
    %BFGSNoLine(q) = BFGSNoLine(q).simulate(min(3*r, maxLen + r - length(BFGSNoLine(q).res)),"no");
    %BFGSNoLine(q).save();
    %Matlab(q) = Matlab(q).simulate(min(3*r, maxLen + r - length(Matlab(q).res)),"no");
    %Matlab(q).save();
    %cyclic(q) = cyclic(q).simulate(min(3*r, maxLen + r - length(cyclic(q).res)),"no");
    %cyclic(q).save();
    %cyclicShoppingCart(q) = cyclicShoppingCart(q).simulate(min(3*r, maxLen + r - length(cyclicShoppingCart(q).res)),"no");
    %cyclicShoppingCart(q).save();
end

%for q = 1:length(twoShoppingCarts)
    %twoShoppingCarts(q) = twoShoppingCarts(q).simulate(min(3*r, maxLen + r - length(twoShoppingCarts(q).res)),"no");
    %twoShoppingCarts(q).save();
%end

%for q = 1:6
%    cyclic(q).plotTwo(BFGS(q))
%    cyclic(q).plotTwo(Matlab(q))
%end

% Plotting, capsules, BFGS and Matlab

%cyclic(1).plotTwo([BFGS(1),Matlab(1)]);

%BFGS(1).plotTwo(BFGSNoLine(1));
%gradM(1).plotTwo(gradMNoLine(1));
    
% Matlab(1).plot('Progression of cyclic Matlab m., just capsules',true)
% cyclic(1).plot('Progression of new cyclic m., just capsules',true)
% 
% cyclic(4).plot('Progression of new cyclic m., with capsules and luggage',true)
% BFGS(4).plot('Progression of BFGS, with capsules and luggage',true)
% Matlab(4).plot('Progression of cyclic Matlab m., with capsules and luggage',true)
% 
% Matlab(1).plotTwo(cyclic(1),BFGS(1),'Expected solving time, with just capsules','n',true)
% Matlab(4).plotTwo(cyclic(4),BFGS(4),'Expected solving time, with capsules and luggage','n',true)

% m = [];
% for q = 1:length(twoShoppingCarts)
%     m(q) = 0;
%     for w = 1:length(twoShoppingCarts(q).res)
%         m(q) = max(m(q), length(twoShoppingCarts(q).res{w}));
%     end
%     m(q) = m(q)-1;
%     disp(['q = ', num2str(q), ': ', num2str(m(q))]);
% end

% [~,bigBoxMax] = max(m(mod(1:60,3)==1));
% [~,midBoxMax] = max(m(mod(1:60,3)==2));
% [~,smaBoxMax] = max(m(mod(1:60,3)==0));
% 
% m(bigBoxMax*3-2)
% m(midBoxMax*3-1)
% m(smaBoxMax*3)
% 
% twoShoppingCarts(bigBoxMax*3-2).name
% twoShoppingCarts(midBoxMax*3-1).name
% twoShoppingCarts(smaBoxMax*3).name
% 
% figure; hold on;
% bar(1:3:60,m(mod(1:60,3)==1))
% bar(1:3:60,m(mod(1:60,3)==2))
% bar(1:3:60,m(mod(1:60,3)==0))
% xlabel("Different locations and orientations of shopping carts")
% ylabel("Max persons")
% legend("Big box", "Mid box", 'Location', 'southwest')
% title("Two shopping carts")

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