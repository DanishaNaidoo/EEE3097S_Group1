function [] = LocalizationFunction(TDoA12,TDoA13, TDoA14, src)
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

% Check if the solutions are empty


% Evaluate the solutions (x, y coordinates)
%Intersection between hyperbola 12 and 13
x1213 = round(double(solutions1213.x), 2);
y1213 = round(double(solutions1213.y), 2);
c_1213 = [x1213, y1213];
%Intersection between hyperbola 12 and 14
x1214 = round(double(solutions1214.x), 2);
y1214 = round(double(solutions1214.y), 2);
c_1214 = [x1214, y1214];
%Intersection between hyperbola 13 and 14
x1314 = round(double(solutions1314.x), 2);
y1314 = round(double(solutions1314.y), 2);
c_1314 = [x1314, y1314];

% Create a cell array to store the non-empty arrays
arrays = {c_1213, c_1214, c_1314};

% Filter out the empty arrays
non_empty_arrays = arrays(~cellfun('isempty', arrays));

% Calculate the average if there are non-empty arrays
if ~isempty(non_empty_arrays)
    location = mean(cell2mat(non_empty_arrays), 1)
    
    if (location(1) < 0) || (location(1) > 0.5) || (location(2) < 0) || (location(2) > 0.8)
        disp('No locations found within the defined grid.');
    end 
% No intersections found and hence no locations found    
else
    disp('No locations found.');    
    location = [-1, -1];
    
end


% %Display the location of the source
% if ((all(c_1213==c_1214) & (all(c_1213==c_1314))))
%     %disp(['Estimated location of the sound source: [' num2str(c_1213(1)) ', ' num2str(c_1213(2)) ']']);
%     %disp(c_1213);
% 
%    % median_x = median(c_1213(1))
%     %median_y = median(c_1213(2))
% else
%     % disp('Possible locations for the source: ');
%     % disp(c_1213);
%     % disp(c_1214);
%     % disp(c_1314);
%     x_array = [c_1213(1), c_1214(1), c_1314(1)];
%     y_array = [c_1213(2), c_1214(2), c_1314(2)];
%     median_x = median(x_array);
%     median_y = median(y_array);
%     estimated_location = [median_x, median_y];
%     %disp(['Estimated location of the sound source: [' num2str(estimated_location(1)) ', ' num2str(estimated_location(2)) ']']);
%     %disp(estimated_location);
% 
% 
% end

% Plot the hyperbolas
gcf = figure('visible', 'off');
fimplicit(h12, [0, 0.8, 0, 0.5]);  % Adjust the plot limits as needed
hold on;
fimplicit(h13, [0, 0.8, 0, 0.5]);
fimplicit(h14, [0, 0.8, 0, 0.5]);
%Define mic positions
scatter(location(1), location(2), "m");
scatter(src(1), src(2), "g");
scatter(micPos1(1), micPos1(2), 'g', 'filled');
scatter(micPos2(1), micPos2(2), 'r', 'filled');
scatter(micPos3(1), micPos3(2), 'r', 'filled');
scatter(micPos4(1), micPos4(2), 'r', 'filled');
title('Hyperbolas for Sound Localization');
xlabel('X Coordinate');
ylabel('Y Coordinate');
legend('Hyperbola 12', 'Hyperbola 13', 'Hyperbola 14', 'Estimated Location', 'Actual Location');
legend('Location','eastoutside');
grid on;
hold off;
saveas(gcf, 'hyperbola_plot.png');
close(gcf);


end