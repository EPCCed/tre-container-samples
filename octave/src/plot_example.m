% declaring variable var_x
var_x = [0:0.01:1];

% declaring variable var_y1
var_y1 = sin(4 * pi * var_x);

% declaring variable var_y2
var_y2 = cos(3 * pi * var_x);

% plot var_x with var_y1
plot(var_x, var_y1);

% hold the above plot or figure
hold on;

% plot var with var_y2 with red color
plot(var_x, var_y2, 'r');

% adding label to the x-axis
xlabel('time');

% adding label to the y-axis
ylabel('value');

% adding title for the plot
title('my first plot');

% add legends for these 2 curves
legend('sin', 'cos');

print -dpng 'plot.png'
