R = resultsAnalysis;
R.initialize;
R.problem('method2') = @(P,p)P.optimizeCyclic('triangle',p);
R.problem('squared') = 'no';
R.problem('changeIter') = 0;
R.problem('h2Step') = 'no';
R.problem('staticShape') = [];
R.problem('shape1') = R.problem('shape1').capsule;
R.problem("solutionLimit") = 1e-3 / 10;

box = shape;

box.type = "rectangle";
box.height = 10;
box.width = 10;

R.problem("box") = box;

R = R.simulate(30,"no");
R.Pbest(1).drawProblem(false);