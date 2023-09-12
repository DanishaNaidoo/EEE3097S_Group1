%Localization Algorithm - Danisha Naidoo (NDXDAN019)
%Find the location of a sound source by finding the intersections of
%multiple hyperbolas.
%These hyperbolas are found from the TDoA values for each microphone pai

%Variables

%Symbolic Variables
syms x y;

%TDoA Values
%Give the TDoA between a mic and the reference mic
TDoA12 = -0.00032876;
TDoA13 = -0.0014496;
TDoA14 = -0.00079804;

%Microphone coordinates
micPos1 = [0, 0];
micPos2 = [0, 0.5];
micPos3 = [0.8, 0.5];
micPos4 = [0.8, 0];

%Calculating the distances from the TDoA for each mic pair
distance12 = getDistance(TDoA12);
distance13 = getDistance(TDoA13);
distance14 = getDistance(TDoA14);

%Calculate the hyperbolas for each mic pair
h12 = getHyperbola(distance12, micPos1(1), micPos1(2), micPos2(1), micPos2(2));
h13 = getHyperbola(distance13, micPos1(1), micPos1(2), micPos3(1), micPos3(2));
h14 = getHyperbola(distance14, micPos1(1), micPos1(2), micPos4(1), micPos4(2));

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
title('Hyperbolas for Sound Localization');
xlabel('X Coordinate');
ylabel('Y Coordinate');
legend('h12', 'h13', 'h14', "Reference Mic", "Mics");
grid on;
hold off;


% Solve the system of equations symbolically
solutions1213 = solve([h12, h13], [x, y]);
solutions1214 = solve([h12, h14], [x, y]);
solutions1314 = solve([h13, h14], [x, y]);
solutionsAll = solve([h12, h13, h14], [x, y]);

% Evaluate the solutions (x, y coordinates)
x1213 = round(double(solutions1213.x), 1);
y1213 = round(double(solutions1213.y), 1);
c_1213 = [x1213, y1213];
disp("Intersection of h12 and h13: ")
disp(c_1213);

x1214 = round(double(solutions1214.x), 1);
y1214 = round(double(solutions1214.y), 1);
c_1214 = [x1214, y1214];
disp("Intersection of h12 and h14: ");
disp(c_1214);

x1314 = round(double(solutions1314.x), 1);
y1314 = round(double(solutions1314.y), 1);
c_1314 = [x1314, y1314];
disp("Intersection of h13 and h14: ");
disp(c_1314);


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

%Function to find the distances given the TDoA
function result = getDistance(TDoA)
    result = TDoA*343.21; %speed of sound in air = 343m/s
end

%Function to form the hyperbola for each mic pair 
function result = getHyperbola(distance, xPos1, yPos1, xPos2, yPos2)
    %symbolic values
    syms x y;
    %these two equations seem to give the same result
    result = sqrt((x-xPos2)^2+(y-yPos2)^2)-sqrt((x-xPos1)^2+(y-yPos1)^2)-distance; 
    %result = sqrt((x-xPos2)^2+(y-yPos2)^2)-sqrt(x^2+y^2)-distance;
end

