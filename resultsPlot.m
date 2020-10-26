% A20 = [0.225814253364292, 0.137011164561185; %500
%        0.127520411329432, 0.030746217781013; % 50
%        0.051647518596740, 0.020753982475066;
%        10, 10];
%    
% A40 = [0.333852894870501, 0.176351186762379; %200
%        0.164004014699913, 0.078933838407536; 
%        0.061890529809208, 0.017287831158549;
%        0.019915235224615, 0.004073577167807];
%    
% A60 = [0.331813713734658, 0.251813713734731; % 200
%        0.164702679837660, 0.085297320162289;
%        0.063507246532026, 0.020908337883555;
%        0.026018890474831, 0.010010492626776];
%   
%    
%    
%    %%%%
% T20 = [0.195096793228796, 26.968710151179138;
%        1.015344977603530, 0.021253006506701;
%        0.999709096494338, 0.030053778907352;
%        1, 444];
%    
% T40 = [0.500000000000000, 0.793403306608384;
%        0.233582897422722, 8.418525267976407e+04;
%        1.689839028829114, 4.470589654116570;
%        1.060106538718702, 0.059701989083043];
%    
% T60 = [0.500000000000000, 0.618740711997256;
%        8.331471387235112e-07, 1.180345582225204;
%        0.818740668133451, 2.172970235953113e+04;
%        1.796961145951490, 2.626184117065459];
   
theoreticalX = linspace(1,45^0.5,50).^2;
theoreticalY = 4./(3.*theoreticalX + 1);

Nset = [5,10,20,40];

directoryResults;

figure;
hold on
%errorbar(Nset(1:3), A20(1:3,1).', A20(1:3,2),'k');
errorbar(Nset(1:3), A20(1:3,1).', B20(1:3,1)-A20(1:3,1), B20(1:3,2)-A20(1:3,1),'k');
%plot(Nset(1:4), A40(:,1).',['k',':']);
%plot(Nset(1:4), A60(:,1).',['k',':']);
plot(theoreticalX,theoreticalY,['b','--']);
%plot([1,45],[0,0],['k','--']);
axis([1, 45, -0, 0.8])
%ylabel('Estimate for $\alpha$','Interpreter','latex');
ylabel('Estimate for alpha');
%xlabel('$n$, number of capsules','Interpreter','latex');
xlabel('n, number of capsules');
%xlabel({'$n\text{, number of capsules}$'},'Interpreter','latex');
%title('box = 20')
%legend({'$b=20$','$b=40$ and $b=60$'},'Interpreter','latex')
%legend({'$b=20$','Theoretical performance'},'Interpreter','latex')
legend('b=20 with quartiles','Theoretical performance')
figuresize(8.3,8.7,'cm');
saveas(gcf,'results-20.pdf');
saveas(gcf,'results-20.png');
%matlab2tikz('filename', 'results-20.tex','standalone', false);

figure;
hold on
%errorbar(Nset(1:4), A40(:,1).', A40(:,2),'k');
errorbar(Nset(1:4), A40(1:4,1).', B40(1:4,1)-A40(1:4,1), B40(1:4,2)-A40(1:4,1),'k');
%plot(Nset(1:3), A20(1:3,1).',['k',':']);
%plot(Nset(1:4), A60(:,1).',['k',':']);
plot(theoreticalX,theoreticalY,['b','--']);
%plot([0,45],[0,0],['k','--']);
axis([0, 45, -0, 0.8])
%ylabel('Estimate for $\alpha$','Interpreter','latex');
ylabel('Estimate for alpha');
%xlabel('$n$, number of capsules','Interpreter','latex');
xlabel('n, number of capsules');
%xlabel({'$n\text{, number of capsules}$'},'Interpreter','latex');
%title('box = 40')
%legend({'$b=40$','$b=20$ and $b=60$'},'Interpreter','latex')
%legend({'$b=40$','Theoretical performance'},'Interpreter','latex')
legend('b=40 with quartiles','Theoretical performance')
figuresize(8.3,8.7,'cm');
saveas(gcf,'results-40.pdf');
saveas(gcf,'results-40.png');
%matlab2tikz('filename', 'results-40.tex','standalone', false);

figure;
hold on
%errorbar(Nset(1:4), A60(:,1).', A60(:,2),'k');
errorbar(Nset(1:4), A60(1:4,1).', B60(1:4,1)-A60(1:4,1), -B60(1:4,2)+A60(1:4,1),'k');
%plot(Nset(1:3), A20(1:3,1).',['k',':']);
%plot(Nset(1:4), A40(:,1).',['k',':']);
plot(theoreticalX,theoreticalY,['b','--']);
%plot([0,45],[0,0],['k','--']);
axis([0, 45, -0, 0.8])
%ylabel('Estimate for $\alpha$','Interpreter','latex');
ylabel('Estimate for alpha');
%xlabel('$n$, number of capsules','Interpreter','latex');
xlabel('n, number of capsules');
%xlabel({'$n\text{, number of capsules}$'},'Interpreter','latex');
%title('box = 60')
%legend({'$b=60$','Theoretical performance'},'Interpreter','latex')
legend('b=60 with quartiles','Theoretical performance')
figuresize(8.3,8.7,'cm');
saveas(gcf,'results-60.pdf');
saveas(gcf,'results-60.png');
%matlab2tikz('filename', 'results-60.tex','standalone', false);

directoryFiles;

table = ['&5&', num2str(A20(1,1),3), '$\pm$',num2str(A20(1,2),2), '&', num2str(A40(1,1),3),'$\pm$',num2str(A40(1,2),2), '&', num2str(A60(1,1),3),'$\pm$',num2str(A60(1,2),2),'\\ ',...
        '&10&', num2str(A20(2,1),3), '$\pm$',num2str(A20(2,2),2), '&', num2str(A40(2,1),3),'$\pm$',num2str(A40(2,2),2), '&', num2str(A60(2,1),3),'$\pm$',num2str(A60(2,2),2), '\\ ',...
        '&20&', num2str(A20(3,1),3), '$\pm$',num2str(A20(3,2),2), '&', num2str(A40(3,1),3),'$\pm$',num2str(A40(3,2),2), '&', num2str(A60(3,1),3),'$\pm$',num2str(A60(3,2),2), '\\ ',...
        '&40&', '--'                                            , '&', num2str(A40(4,1),3),'$\pm$',num2str(A40(4,2),2), '&', num2str(A60(4,1),3),'$\pm$',num2str(A60(4,2),2), '\\']

table2= ['&5&', num2str(T20(1,1),3), ', ',num2str(T20(1,2),2), '&', num2str(T40(1,1),3),', ',num2str(T40(1,2),2), '&', num2str(T60(1,1),3),', ',num2str(T60(1,2),2),'\\ ',...
        '&10&', num2str(T20(2,1),3), ', ',num2str(T20(2,2),2), '&', num2str(T40(2,1),3),', ',num2str(T40(2,2),2), '&', num2str(T60(2,1),3),', ',num2str(T60(2,2),2), '\\ ',...
        '&20&', num2str(T20(3,1),3), ', ',num2str(T20(3,2),2), '&', num2str(T40(3,1),3),', ',num2str(T40(3,2),2), '&', num2str(T60(3,1),3),', ',num2str(T60(3,2),2), '\\ ',...
        '&40&', '--'                                         , '&', num2str(T40(4,1),3),', ',num2str(T40(4,2),2), '&', num2str(T60(4,1),3),', ',num2str(T60(4,2),2), '\\']
