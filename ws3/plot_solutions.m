function plot_solutions(t_exact, y_exact, T_approx, Y_approx, labels, title_str)
%{
Plot exact solution along with approximations to it and
store as png image to the root

Parameters
----------
t_exact, y_exact : vector of floats
	time points and values of the exact solution
T_approx, Y_approx : cell array of vector of floats
	time points and values of the approximation
labels : vector of strings
	labels of the corresponding approximation methods
title_str : string
	title of the plot
%}
fig = figure;

plot(t_exact, y_exact, '-k', 'LineWidth', 2);
for i=1:numel(T_approx)
	hold on;
	plot(T_approx{i}, Y_approx{i}, '-o', 'LineWidth', 1, 'MarkerSize', 3, 'MarkerFaceColor', 'auto');
end
hold off;

xlabel('t');
ylabel('y(t)');
ylim([0 20]);
title(title_str);
legend(['Exact solution'; labels], 'Location','Best');
grid on;

set(fig, 'Position', [100, 100, 960, 640]);
res = 144;
print(fig, title_str, '-dpng', strcat('-r', num2str(res)));