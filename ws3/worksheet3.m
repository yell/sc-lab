clc
clear


% rhs and its derivative
f = @(t, p) 7 * (1 - p./10) .* p;
fprime = @(t, p) 7 * (1 - p./5);

% time endpoint
t_end = 5;

% initial condition
p0 = 20;

% step sizes
dt = 2 .^ (-1:-1:-5); % 1/2, ..., 1/32

% numerical methods
explicit_methods = { @explicit_euler, @heun };
implicit_methods = { @implicit_euler };
num_methods = { explicit_methods, implicit_methods };

% for plotting
explicit_methods_strs = { 'Explicit Euler', 'Heun' };
implicit_methods_strs = { 'Implicit Euler' };
num_methods_strs = { explicit_methods_strs, implicit_methods_strs }

% exact solution
p_exact_f = @(t) 200 ./ (20 - 10 .* exp(-7 * t));

% time points for exact solution
t_exact = 0:0.01:t_end;

% exact solution evaluated on the respective domain 
p_exact = p_exact_f(t_exact)';

% plot the exact solution alone
plot_solutions(t_exact, p_exact, {}, {}, [], 'Exact solution');


% main loop
for i = 1:numel(num_methods)

	for j = 1:numel(num_methods{i})

		% needed for plotting
		T_collection = cell(numel(dt), 1);
		P_collection = cell(numel(dt), 1);
		labels = strings(numel(dt), 1);

		for k = 1:numel(dt)
			switch i
			case 1 % explicit
				[T, P] = num_methods{i}{j}(f, p0, dt(k), t_end);
			case 2 % implicit
				[T, P] = num_methods{i}{j}(f, p0, fprime, dt(k), t_end);
			end
			T_collection{k} = T;
			P_collection{k} = P;
			labels(k) = strcat(num_methods_strs{i}{j}, ', dt = ', num2str(dt(k)));
		end

		% for explicit compute also for dt = 1
		if i == 1
			k = numel(dt) + 1
			[T, P] = num_methods{i}{j}(f, p0, 1, t_end);
			T_collection{k} = T;
			P_collection{k} = P;
			labels(k) = strcat(num_methods_strs{i}{j}, ', dt = 1');
		end

		% plot and save the image to the root folder
		plot_solutions(t_exact, p_exact, T_collection, P_collection, labels, num_methods_strs{i}{j});
	end
end