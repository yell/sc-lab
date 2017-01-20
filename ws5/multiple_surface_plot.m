function multiple_surface_plot(T_collection, title_str, title_strs)
%{
Plot the whole collection of matrices each 
evenly spaced in [0; 1] x [0; 1].

Parameters
----------
T_collection : (M, N) cell-array of matrices
	Collection of matrices to plot.
title_str : string
	Title of the plot.
title_strs : (M, N) cell-array of strings
	Corresponding titles for subplots.
%}
fig = figure;
[M N] = size(T_collection);
set(fig, 'position', [10, 10, (280 * N + 180), 800]);
set(fig, 'visible', 'on');

colormap jet;
grid on;

for p = 1:numel(1:M)
	for q = 1:numel(1:N)
		num_subplot = (p - 1) * N + (q - 1) + 1;
		g = subplot(M, N, num_subplot);
		
		% make subplots wider and reduce margins
		pos = get(g, 'position');
		pos(1) = pos(1) - 0.08 + 0.022 * (q - 1);
		pos(2) = pos(2) - 0.03 - 0.01 * (p - 1);
		pos(3) = pos(3) * 1.22; 
		set(g, 'position', pos);
		
		[m n] = size(T_collection{p, q});
		x = linspace(0, 1, n);
		y = linspace(0, 1, m);
		surf(x, y, T_collection{p, q});
		colorbar;
		title(g, title_strs{p, q});
	end
end

% crazy workaround to set main title :/
ha = axes('Position', [0 0 1 1], 'Xlim', [0 1], 'Ylim', [0 1], ...
	      'Box', 'off', 'Visible', 'off', ...
	      'Units', 'normalized', 'clipping', 'off');
text(0.5, 1, strcat('\bf ', title_str), 'HorizontalAlignment', 'center', ...
	'VerticalAlignment', 'top', 'fontsize', 18);

res = 144;
print(fig, strcat(title_str, '.png'), '-dpng', strcat('-r', num2str(res)));