%Function to form the hyperbola for each mic pair 
function result = getHyperbola(distance, xPos1, yPos1, xPos2, yPos2)
    %symbolic values
    syms x y;
    %these two equations seem to give the same result
    result = sqrt((x-xPos2)^2+(y-yPos2)^2)-sqrt((x-xPos1)^2+(y-yPos1)^2)-distance; 
    %result = sqrt((x-xPos2)^2+(y-yPos2)^2)-sqrt(x^2+y^2)-distance;
end