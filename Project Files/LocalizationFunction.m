function [xAll, yAll] = LocalizationFunction(TDoA12,TDoA13, TDoA14, x, y)
%Localization Algorithm - Danisha Naidoo (NDXDAN019)
%Find the location of a sound source by finding the intersections of
%multiple hyperbolas.
%These hyperbolas are found from the TDoA values for each microphone pai

%Variables

%Symbolic Variables
syms x; 
syms y;

%TDoA Values
%Give the TDoA between a mic and the reference mic
%TDoA12 = 0.0008;
%TDoA13 = 0.0010;
%TDoA14 = 0.0020;

%Microphone coordinates
micPos1 = [0, 0];
micPos2 = [0, 0.5];
micPos3 = [0.8, 0.5];
micPos4 = [0.8, 0];

%Calculating the distances from the TDoA for each mic pair
%distance12 = getDistance(TDoA12);
%distance13 = getDistance(TDoA13);
%distance14 = getDistance(TDoA14);

distance12 = TDoA12*343.21;
distance13 = TDoA13*343.21;
distance14 = TDoA14*343.21;

%Calculate the hyperbolas for each mic pair
h12 = getHyperbola(distance12, micPos1(1), micPos1(2), micPos2(1), micPos2(2));
h13 = getHyperbola(distance13, micPos1(1), micPos1(2), micPos3(1), micPos3(2));
h14 = getHyperbola(distance14, micPos1(1), micPos1(2), micPos4(1), micPos4(2));



% Plot the hyperbolas
fimplicit(h12, [0, 0.8, 0, 0.5]);  % Adjust the plot limits as needed
hold on;
fimplicit(h13, [0, 0.8, 0, 0.5]);
fimplicit(h14, [0, 0.8, 0, 0.5]);
title('Hyperbolas for Sound Localization');
xlabel('X Coordinate');
ylabel('Y Coordinate');
legend('h12', 'h13', 'h14');
grid on;

hold off;

% Solve the system of equations symbolically
solutions1213 = solve([h12, h13], [x, y]);
solutions1214 = solve([h12, h14], [x, y]);
solutions1314 = solve([h13, h14], [x, y]);
solutionsAll = solve([h12, h13, h14], [x, y]);
% Evaluate the solutions (x, y coordinates)
x1213 = double(solutions1213.x);
y1213 = double(solutions1213.y);
disp("Intersection of h12 and h13: ")
disp(x1213)
disp(y1213)

x1214 = double(solutions1214.x);
y1214 = double(solutions1214.y);
disp("Intersection of h12 and h14: ")
disp(x1214)
disp(y1214)

x1314 = double(solutions1314.x);
y1314 = double(solutions1314.y);
disp("Intersection of h13 and h14: ")
disp(x1314)
disp(y1314)

xAll = double(solutionsAll.x);
yAll = double(solutionsAll.y);
disp("Intersection of h12 and h13 and h14: ")
disp(xAll)
disp(yAll)

%Function to find the distances given the TDoA
%function result = getDistance(TDoA)
 %   result = TDoA*343.21; %speed of sound in air = 343m/s
%end
end