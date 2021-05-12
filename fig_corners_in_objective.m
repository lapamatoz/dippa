% FIRST FIGURE; (a)
P = elevatorProblem;
%        shapes = {}
%        box
%        data = containers.Map
%        calculations = 0

s1 = shape;

s1.position = [-4,0.3];
s1.theta = pi/2;

s1.width = 5;
s1.height = 2;

box = shape;

box.type = "rectangle";
box.height = 10;
box.width = 10;

P.shapes = {s1};
P.box = box;

problem = containers.Map;
problem("squared") = "no";
problem("allowDist") = "allowDistances";

% FIRST FIGURE; (b)
s2 = shape;
s2.theta = pi/2;
s1.theta = pi/4;
s1.position(2) = -0.5;

s2.width = 5;
s2.height = 2;

x = linspace(-4,4,300);
y = zeros(1,length(x));

P.shapes = {s1,s2};

P.drawProblem(false)

for q = 1:length(x)
    y(q) = P.objectiveFunctionShapeWise([x(q),-0.5,pi/2], 1, problem)^.5;
end
figure;
plot(x,y)