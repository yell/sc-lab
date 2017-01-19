function surface_plot(T, title_str)
%{
Plot surface plot of a marix with values evenly spaced in [0; 1] x [0; 1].

Parameters
----------
T : (m, n) matrix
	matrix to plot
title_str : string
	title of the plot
%}
fig = figure;
set(gcf, 'Visible', 'off');

[m n] = size(T);
x = linspace(0, 1, n);
y = linspace(0, 1, m);
colormap jet;
surf(x, y, T);
colorbar;

fontsize = 16;
xlabel('x', 'fontsize', fontsize);
ylabel('y', 'fontsize', fontsize);
zlabel('T(x, y)', 'fontsize', fontsize);
title(title_str, 'fontsize', 18);
grid on;

set(fig, 'Position', [100, 100, 960, 640]);
res = 144;
print(fig, strcat(title_str, '.png'), '-dpng', strcat('-r', num2str(res)));