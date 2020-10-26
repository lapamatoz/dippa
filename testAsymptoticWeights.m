s1 = 150*rand(5,1);

s2 = s1;
s2(1:2) = s2(1:2)*1.000001;

negativeRotMat = [cos(-s1(5)), -sin(-s1(5)); sin(-s1(5)), cos(-s1(5))];
e1 = negativeRotMat * [1; 0];
e1y = e1(2)
e2 = negativeRotMat * [0; 1];
e2y = e2(2)
a = s1(1)*2;
r = s1(2);
h = s1(2)*2;
w = s1(1)*2;

%weights = [abs(a*e1y) + 2*r, abs(a*e2y) + 2*r, a*(r+a/4)];
weights = [h*e1(1) + w*e1(2),...
           h*e2(1) + w*e2(2),...
    w^2/4 + h^2/4];

x = linspace(-5,5,601);
y = zeros(1,length(x));

for p = 1:length(x)
    y(p) = w*h - rectIntersectArea(s1,s2+ [0;0;0;0;x(p)]);
end

plot(x,y)
hold on
yAsymp = abs(x)*weights(3);
plot(x,yAsymp)
title('Theta')



x = linspace(-500,500,601);
y = zeros(1,length(x));
for p = 1:length(x)
    %y(p) = s1(2)*(pi*s1(2) + 4*s1(1)) - stadiumOverlapArea4(s1,s2+ [0;0;x(p);0;0]);
    y(p) = w*h - rectIntersectArea(s1,s2+ [0;0;x(p);0;0]);
end

figure;
plot(x,y)
hold on
yAsymp = abs(x)*abs(weights(1));
plot(x,yAsymp)
title('x')

distr = rand(3,1);

x = linspace(-5,5,901);
y = zeros(1,length(x));
for p = 1:length(x)
    %y(p) = s1(2)*(pi*s1(2) + 4*s1(1)) - stadiumOverlapArea4(s1,s2+ [0;0;x(p)*distr]);
    y(p) = w*h - rectIntersectArea(s1,s2+ [0;0;x(p)*distr]);
end

figure;
plot(x,y)
hold on
coefficient = sqrt((distr(1)*weights(1))^2 + (distr(2)*weights(2))^2 + (distr(3)*weights(3))^2);
yAsymp = x* coefficient;
plot(x,yAsymp)
title('kaikki yhdessä')

capsArea = s1(2)*(pi*s1(2) + 4*s1(1));
proportion = 0.1;

displacement = proportion / coefficient * capsArea;
realProportion = (capsArea - stadiumOverlapArea4(s1,s2+ [0;0;displacement*distr])) / capsArea



