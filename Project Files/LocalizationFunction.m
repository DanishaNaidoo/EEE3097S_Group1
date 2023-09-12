function [] = LocalizationFunction(TDoA12,TDoA13, TDoA14)
%Localization Algorithm - Danisha Naidoo (NDXDAN019)
%Find the location of a sound source by finding the intersections of
%multiple hyperbolas.
%These hyperbolas are found from the TDoA values for each microphone pair

%Variables

%Symbolic Variables
syms x; 
syms y;

%Microphone coordinates
micPos1 = [0, 0];
micPos2 = [0, 0.5];
micPos3 = [0.8, 0.5];
micPos4 = [0.8, 0];

%Calculating the distances from the TDoA for each mic pair
distance12 = TDoA12*343.21;
distance13 = TDoA13*343.21;
distance14 = TDoA14*343.21;

%Calculate the hyperbolas for each mic pair
h12 = getHyperbola(distance12, micPos1(1), micPos1(2), micPos2(1), micPos2(2));
h13 = getHyperbola(distance13, micPos1(1), micPos1(2), micPos3(1), micPos3(2));
h14 = getHyperbola(distance14, micPos1(1), micPos1(2), micPos4(1), micPos4(2));


% Solve the system of equations symbolically
solutions1213 = solve([h12, h13], [x, y]);
solutions1214 = solve([h12, h14], [x, y]);
solutions1314 = solve([h13, h14], [x, y]);

% Evaluate the solutions (x, y coordinates)
%Intersection between hyperbola 12 and 13
x1213 = round(double(solutions1213.x), 3);
y1213 = round(double(solutions1213.y), 3);
c_1213 = [x1213, y1213];
%Intersection between hyperbola 12 and 14
x1214 = round(double(solutions1214.x), 3);
y1214 = round(double(solutions1214.y), 3);
c_1214 = [x1214, y1214];
%Intersection between hyperbola 13 and 14
x1314 = round(double(solutions1314.x), 3);
y1314 = round(double(solutions1314.y), 3);
c_1314 = [x1314, y1314];

% Plot the hyperbolas
fimplicit(h12, [0, 0.8, 0, 0.5]);  % Adjust the plot limits as needed
hold on;
fimplicit(h13, [0, 0.8, 0, 0.5]);
fimplicit(h14, [0, 0.8, 0, 0.5]);
%Define mic positions
scatter(micPos1(1), micPos1(2), 'g', 'filled');
scatter(micPos2(1), micPos2(2), 'r', 'filled');
scatter(micPos3(1), micPos3(2), 'r', 'filled');
scatter(micPos4(1), micPos4(2), 'r', 'filled');
scatter(c_1314(1), c_1214(2), "r");
title('Hyperbolas for Sound Localization');
xlabel('X Coordinate');
ylabel('Y Coordinate');
legend('Hyperbola 12', 'Hyperbola 13', 'Hyperbola 14');
grid on;
hold off;

%Display the location of the source
if ((all(c_1213==c_1214) && (all(c_1213==c_1314))))
    disp('The estimated location of the source is: ');
    disp(c_1213);
else
    disp('Possible locations for the source: ');
    disp(c_1213);
    disp(c_1214);
    disp(c_1314);
end

end