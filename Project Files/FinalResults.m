%setup grid dimensions
x = (0:0.05:0.8)';
y = (0:0.05:0.5)';
[X, Y] = meshgrid(x, y);

%getting a variable that'll store the points to plot
Z = zeros(length(x), length(y))';

%1 means mic
Z(1, 1) = 1;
Z(1, cast(0.5*length(y), "int16")) = 1;
Z(length(x), cast(0.5*length(y), "int16")) = 1;
Z(length(x), 1) = 1;

%2 means actual source
t = cast(src(1)*length(x), "int16");
u = cast(src(2)*length(y), "int16");
Z(t, u) = 2;

%3 means calculated value
%Z(l) = 3;

map2 = [0 1 0; 0 0.8 0;1 1 1;0.6 0 0;1 0 0 ];
%use the user defined colormap for figure.
colormap(map2);
%plot the figure
pcolor(X,Y,Z);
%set the x and y labels
set(gca,'XTick',[1 2 3 4 5 6],'YTick',[1 2 3 4],'XTicklabel',[' ';'a';'b'; 'c'; 'd';'e'],'YTicklabel',[' ';'f';'g';'h']);
%set the color limits
%clim([-2 2])