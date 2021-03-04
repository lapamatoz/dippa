s1 = rand(5,1)+0.01;
s2 = rand(5,1)+0.01;
s1(2) = s2(2);
n = 20000;
S = rand(5,n)+0.01;

drawStadiums(s1,true, [0.9,0.9,0.9], [0.2 0.2 0.2])
drawRectangles(s2,true, [0.9,0.9,0.9], [0.2 0.2 0.2])

drawStadiums(s1,false, [0.9,0.9,0.9], [0.2 0.2 0.2])
drawRectangles(s2,false, [0.9,0.9,0.9], [0.2 0.2 0.2])

hold on;
tic
for i = 1:(n-1)
    stadiumOverlapArea4(S(:,i),[S(1,i+1); S(2,i); S(3:5,i+1)]);
end
t1 = toc;

tic
for i = 1:(n-1)
    stadiumOverlapArea5(S(:,i),[S(1,i+1); S(2,i); S(3:5,i+1)]);
end
t2 = toc;

t2/t1