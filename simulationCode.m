runs = 2;

%%%%% BIG BOX
box = shape;
box.height = 1700 / 100;
box.width = 2350 / 100;
box.type = "rectangle";

%M = resultsAnalysis;
Bbig = Bbig.initialize();
Bbig.problem("method2") = @(P,p)P.optimizeBFGS(p);
Bbig.problem("squared") = "no";
Bbig.problem("changeIter") = 0;
Bbig.problem("h2Step") = "no";
Bbig.problem("box") = box;
Bbig.name = "BFGS-big";

%C = resultsAnalysis;
Mbig = Mbig.initialize();
Mbig.problem("method2") = @(P,p)P.optimizeCyclic("Matlab",p);
Mbig.problem("squared") = "no";
Mbig.problem("changeIter") = 0; % change at changeIter*n
Mbig.problem("h2Step") = "no";
Mbig.problem("box") = box;
Mbig.name = "Matlab (BSc thesis)-big";

%S = resultsAnalysis;
Wbig = Wbig.initialize;
Wbig.problem("method2") = @(P,p)P.optimizeCyclic("triangle",p);
Wbig.problem("squared") = "no";
Wbig.problem("changeIter") = 0; % change at changeIter*n
Wbig.problem("h2Step") = "diminishing";
Wbig.problem("box") = box;
Wbig.name = "New algorithm-big";

%W = resultsAnalysis;
Nbig = Nbig.initialize;
Nbig.problem("method2") = @(P,p)P.optimizeCyclic("triangle",p);
Nbig.problem("squared") = "ones";
Nbig.problem("changeIter") = 0; % change at changeIter*n
Nbig.problem("h2Step") = "diminishing";
Nbig.problem("box") = box;
Nbig.name = "No diag. scaling-big";

Bbig = Bbig.simulate(runs,"no");
Mbig = Mbig.simulate(runs,"no");
Wbig = Wbig.simulate(runs,"no");
Nbig = Nbig.simulate(runs,"no");

Bbig.plotTwo(Wbig)
Mbig.plotTwo(Wbig)
Wbig.plotTwo(Nbig)
title('Just capsules, big lift');

%%%%% MID BOX
box = shape;
box.height = 1400 / 100;
box.width = 2000 / 100;
box.type = "rectangle";

%M = resultsAnalysis;
Bmid = Bmid.initialize();
Bmid.problem("method2") = @(P,p)P.optimizeBFGS(p);
Bmid.problem("squared") = "no";
Bmid.problem("changeIter") = 0;
Bmid.problem("h2Step") = "no";
Bmid.problem("box") = box;
Bmid.name = "BFGS-mid";

%C = resultsAnalysis;
Mmid = Mmid.initialize();
Mmid.problem("method2") = @(P,p)P.optimizeCyclic("Matlab",p);
Mmid.problem("squared") = "no";
Mmid.problem("changeIter") = 0; % change at changeIter*n
Mmid.problem("h2Step") = "no";
Mmid.problem("box") = box;
Mmid.name = "Matlab (BSc thesis)-mid";

%S = resultsAnalysis;
Wmid = Wmid.initialize;
Wmid.problem("method2") = @(P,p)P.optimizeCyclic("triangle",p);
Wmid.problem("squared") = "no";
Wmid.problem("changeIter") = 0; % change at changeIter*n
Wmid.problem("h2Step") = "diminishing";
Wmid.problem("box") = box;
Wmid.name = "New algorithm-mid";

%W = resultsAnalysis;
Nmid = Nmid.initialize;
Nmid.problem("method2") = @(P,p)P.optimizeCyclic("triangle",p);
Nmid.problem("squared") = "ones";
Nmid.problem("changeIter") = 0; % change at changeIter*n
Nmid.problem("h2Step") = "diminishing";
Nmid.problem("box") = box;
Nmid.name = "No diag. scaling-mid";

Bmid = Bmid.simulate(runs,"no");
Mmid = Mmid.simulate(runs,"no");
Wmid = Wmid.simulate(runs,"no");
Nmid = Nmid.simulate(runs,"no");

Bmid.plotTwo(Wmid)
Mmid.plotTwo(Wmid)
Wmid.plotTwo(Nmid)
title('Just capsules, mid lift');

%%%%% SMALL BOX
box = shape;
box.height = 1400 / 100;
box.width = 2000 / 100;
box.type = "rectangle";

%M = resultsAnalysis;
Bsma = Bsma.initialize();
Bsma.problem("method2") = @(P,p)P.optimizeBFGS(p);
Bsma.problem("squared") = "no";
Bsma.problem("changeIter") = 0;
Bsma.problem("h2Step") = "no";
Bsma.problem("box") = box;
Bmid.name = "BFGS-mid";

%C = resultsAnalysis;
Mmid = Mmid.initialize();
Mmid.problem("method2") = @(P,p)P.optimizeCyclic("Matlab",p);
Mmid.problem("squared") = "no";
Mmid.problem("changeIter") = 0; % change at changeIter*n
Mmid.problem("h2Step") = "no";
Mmid.problem("box") = box;
Mmid.name = "Matlab (BSc thesis)-mid";

%S = resultsAnalysis;
Wmid = Wmid.initialize;
Wmid.problem("method2") = @(P,p)P.optimizeCyclic("triangle",p);
Wmid.problem("squared") = "no";
Wmid.problem("changeIter") = 0; % change at changeIter*n
Wmid.problem("h2Step") = "diminishing";
Wmid.problem("box") = box;
Wmid.name = "New algorithm-mid";

%W = resultsAnalysis;
Nmid = Nmid.initialize;
Nmid.problem("method2") = @(P,p)P.optimizeCyclic("triangle",p);
Nmid.problem("squared") = "ones";
Nmid.problem("changeIter") = 0; % change at changeIter*n
Nmid.problem("h2Step") = "diminishing";
Nmid.problem("box") = box;
Nmid.name = "No diag. scaling-mid";

Bmid = Bmid.simulate(runs,"no");
Mmid = Mmid.simulate(runs,"no");
Wmid = Wmid.simulate(runs,"no");
Nmid = Nmid.simulate(runs,"no");

Bmid.plotTwo(Wmid)
Mmid.plotTwo(Wmid)
Wmid.plotTwo(Nmid)
title('Just capsules, mid lift');

% Different sized box = different results
% How to conceur this?
% Well, the big case matters the most so,...

% If time doesn't matter, why not optimize the whole lot?
%   Use light gradient, smart line search method.
%   Scaling is no use with BFGS

% New method is just marginally better. Not significant - why bother?
% I can still compare it with BFGS etc.
% Hyppymenetelmä? Cyclic Matlab -> BFGS

% Gauss-Southwell
% Random indices
% ...
% Acceleration / Hooke & Jeeves (parempi analyysi)

% Vain ratkaisulla on merkitystä; ei ajalla.
% -> BFGS löytäisi 

% Syklisen menetelmän suppenemisnopeus?