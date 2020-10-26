M = resultsAnalysis;
M = M.initialize();
M.problem("method2") = @(P,p)P.optimizeBFGS(p);
M.problem("squared") = "no";
M.problem("changeIter") = 0;
M.problem("h2Step") = "no";
M.name = "BFGS";

C = resultsAnalysis;
C = C.initialize();
C.problem("method2") = @(P,p)P.optimizeCyclic("Matlab",p);
C.problem("squared") = "no";
C.problem("changeIter") = 0; % change at changeIter*n
C.problem("h2Step") = "no";
C.name = "Matlab (BSc thesis)";

M = M.simulate(4,"no");
C = C.simulate(4,"no");

C.plotTwo(M)
title('Just capsules, big lift');

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