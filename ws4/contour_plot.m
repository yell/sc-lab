function contour_plot(T, title_str)
%{
Plot contour plot of a marix with values evenly spaced in [0; 1] x [0; 1].

Parameters
----------
T : matrix
	matrix to plot
title_str : string
	title of the plot
%}
fig = figure;
set(gcf, 'Visible', 'off');

[M, N] = size(T);
x = linspace(0, 1, N);
y = linspace(0, 1, M);
colormap jet;
contour(x, y, T);
colorbar;

fontsize = 16;
xlabel('x', 'fontsize', fontsize);
ylabel('y', 'fontsize', fontsize);
title(title_str, 'fontsize', 18);
axis square;
grid on;

set(fig, 'Position', [100, 100, 960, 640]);
res = 144;
print(fig, strcat(title_str, ' (contour)'), '-dpng', strcat('-r', num2str(res)));