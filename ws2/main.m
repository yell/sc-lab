% rhs
f = @(t, p) (1 - p./10) .* p;

% exact solution
p_exact = @(t) 10 ./ (1 + 9 .* exp(-t));

% initial condition
p0 = 1;

% step sizes
dt = [1, 0.5, 0.25, 0.125];

% time endpoint
t_end = 5;

% numerical methods
num_methods = { @explicit_euler, @heun, @rk4 };

% for plotting
num_methods_strs = { 'Explicit Euler', 'Heun', 'Runge-Kutta (4th order)' };

% time points for exact solution
t_exact = 0:0.01:t_end;

% main loop
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
	plot_comparison(t_exact, p_exact(t_exact), T_collection, P_collection, labels, num_methods_strs{i});
end