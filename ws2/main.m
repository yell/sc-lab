% rhs
f = @(t, p) (1 - p./10) .* p;

% time endpoint
t_end = 5;

% initial condition
p0 = 1;

% step sizes
dt = [1, 0.5, 0.25, 0.125];

% numerical methods
num_methods = { @explicit_euler, @heun, @rk4 };

% for plotting
num_methods_strs = { 'Explicit Euler', 'Heun', 'Runge-Kutta (4th order)' };

% exact solution
p_exact_f = @(t) 10 ./ (1 + 9 .* exp(-t));

% time points for exact solution
t_exact = 0:0.01:t_end;

% exact solution evaluated on the respective domain 
p_exact = p_exact_f(t_exact)';


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
	plot_comparison(t_exact, p_exact, T_collection, P_collection, labels, num_methods_strs{i});

	% print error values
	fprintf('\n\n');
	fprintf('%s\n', num_methods_strs{i});
	fprintf(repmat('-', 1, 66));
	
	fprintf('\n            dt ');
	for j = 1:numel(dt)
		fprintf('|     %1.4f ', dt(j));
	end

	fprintf('\n         error ');
	for j = 1:numel(dt)
		p_ref = p_exact_f(T_collection{j})';
		p_approx = P_collection{j};
		E = approximation_error(p_ref, p_approx, dt(j), t_end);
		fprintf('| %1.4e ', E);
	end

	fprintf('\n error approx. ');
	for j = 1:numel(dt)
		p_ref = P_collection{numel(dt)}; % the most precise approximation
		K = int8(dt(j)/dt(numel(dt)));   % skip every K-th element of p_ref,
		p_ref = p_ref(1:K:numel(p_ref)); % ... in order for dimensions to be matched
		p_approx = P_collection{j};
		E_approx = approximation_error(p_ref, p_approx, dt(j), t_end);
		fprintf('| %1.4e ', E_approx);
	end

	fprintf('\n');
    end