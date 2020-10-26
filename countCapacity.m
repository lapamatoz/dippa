function [nPeople, stadiums, types] = countCapacity(steps, boxSize, draw)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
nPeople = 0;
value = 0;
stadiums = [];
%stadiumsOld = [];
%stadiumsOldOld = [];
types = [];

%nSuitcases = 0;
%suitcases = 5*[normrnd(38.942,3.035,[1,nSuitcases]); normrnd(22.395,2.368,[1,nSuitcases]); zeros(1,nSuitcases); zeros(1,nSuitcases)];
%suitcaseC = 1;

if draw == "video"
    videoFile = VideoWriter('elokuva.avi');
    open(videoFile);
    d = true;
else
    videoFile = NaN;
    d = false;
end

while value <= 4*nPeople && nPeople < 30
    [st_temp,type] = createRandomPeople_2();
    st_temp(3) = (rand()-0.5)*boxSize(1);
    st_temp(4) = boxSize(2);
    st_temp(5) = (rand()-0.5)*0.5;
    stadiums = [stadiums, st_temp];
    types = [types, type];
    %suitcases = [suitcases, sc_temp];
    disp(suitcases)
    nPeople = nPeople + 1;
    nSuitcases = nSuitcases + 1;
    %stadiumsOldOld = stadiumsOld;
    %stadiumsOld = stadiums;
    if sum(objectAreas(stadiums, types)) > 4*boxSize(1)*boxSize(2)
        disp("The problem has become impossible");
        break
    end
    [stadiums, value] = optimizeSystem_2020_2(stadiums,types,steps*nPeople,d,videoFile,boxSize);    
end

if draw == "video"
    close(videoFile);
end

nPeople = nPeople-1;

end