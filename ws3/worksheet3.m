clc
clear


% rhs
f = @(t, p) 7 * (1 - p./10) .* p;

% time endpoint
t_end = 5;

% initial condition
p0 = 20;

% step sizes
dt = 2 .^ (0:-1:-5); % 1, 1/2, ..., 1/32

% numerical methods
num_methods = { @explicit_euler, @heun };

% for plotting
num_methods_strs = { 'Explicit Euler', 'Heun' };

% exact solution
p_exact_f = @(t) 200 ./ (20 - 10 .* exp(-7 * t));

% time points for exact solution
t_exact = 0:0.01:t_end;

% exact solution evaluated on the respective domain 
p_exact = p_exact_f(t_exact)';

% plot the exact solution alone
plot_solutions(t_exact, p_exact, {}, {}, [], 'Exact solution');


% explicit methods
for i = 1:numel(num_methods)

	% needed for plotting
	T_collection = cell(numel(dt), 1);
	P_collection = cell(numel(dt), 1);
	labels = strings(numel(dt), 1);

	for j = 1:numel(dt)
		[T, P, F] = num_methods{i}(f, p0, dt(j), t_end);
		T_collection{j} = T;
		P_collection{j} = P;
		labels(j) = strcat(num_methods_strs{i}, ', dt = ', num2str(dt(j)));
	end

	% plot and save the image to the root folder
	plot_solutions(t_exact, p_exact, T_collection, P_collection, labels, num_methods_strs{i});
end