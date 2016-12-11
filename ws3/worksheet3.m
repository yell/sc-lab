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
implicit_methods = { @implicit_euler, @adams_moulton2 };
linearized_methods = { @adams_moulton2_L1, @adams_moulton2_L2 };
num_methods = { explicit_methods, implicit_methods, linearized_methods };

% for plotting
explicit_methods_strs = { 'Explicit Euler', 'Heun' };
implicit_methods_strs = { 'Implicit Euler', 'Adams-Moulton (2nd order)' };
linearized_methods_strs = { 'Adams-Moulton Linearized v1', 'Adams-Moulton Linearized v2' };
num_methods_strs = { explicit_methods_strs, implicit_methods_strs, linearized_methods_strs };

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
		exitflags = zeros(numel(dt), 1);
		labels = strings(numel(dt), 1);

		for k = 1:numel(dt)
			switch i
			case 1 % explicit
				[T, P, F, exitflag] = num_methods{i}{j}(f, p0, dt(k), t_end);
			case 2 % implicit
				[T, P, F, exitflag] = num_methods{i}{j}(f, p0, fprime, dt(k), t_end);
			case 3 % linearized
				[T, P, exitflag] = num_methods{i}{j}(p0, dt(k), t_end);
			end
			exitflags(k) = exitflag;
			T_collection{k} = T;
			P_collection{k} = P;
			labels(k) = strcat(num_methods_strs{i}{j}, ', dt = ', num2str(dt(k)));
		end

		% for explicit compute also for dt = 1
		if i == 1
			k = numel(dt) + 1;
			[T, P] = num_methods{i}{j}(f, p0, 1, t_end);
			T_collection{k} = T;
			P_collection{k} = P;
			labels(k) = strcat(num_methods_strs{i}{j}, ', dt = 1');
		end

		% plot and save the image to the root folder
		plot_solutions(t_exact, p_exact, T_collection, P_collection, labels, num_methods_strs{i}{j});

		% print error values
		fprintf('\n\n');
		fprintf('%s\n', num_methods_strs{i}{j});
		fprintf(repmat('-', 1, 75));

		fprintf('\n        dt ');
		for k = 1:numel(dt)
			fprintf('|     %1.4f ', dt(k));
		end

		E = zeros(numel(dt), 1);
		fprintf('\n     error ');
		for k = 1:numel(dt)
			p_ref = p_exact_f(T_collection{k})';
			p_approx = P_collection{k};
			if exitflags(k) < 0
				E(k) = inf;
				fprintf('|        N/A ');
			else	
				E(k) = approximation_error(p_ref, p_approx, dt(k), t_end);
				if isinf(E(k))
					fprintf('|        inf ');
				else	
					fprintf('| %1.4e ', E(k));
				end
			end
		end

		fprintf('\nerror red. ');
		for k = 1:numel(dt)
			if k == 1
				fprintf('|          - ');
			elseif isinf(E(k - 1))
				fprintf('|        N/A ');
			else
				fprintf('|   %8.5f ', E(k - 1)/E(k));	
			end
		end

		fprintf('\n stability ');
		for k = 1:numel(dt)
			if exitflags(k) < 0
				stable = false;
			else
				dp0 = 1e-4 * abs(p0) * abs(p0) / (1 + abs(p0));
				p1 = p0 + dp0;

				switch i
				case 1 % explicit
					[T1, P1, F1, exitflag] = num_methods{i}{j}(f, p1, dt(k), t_end);
				case 2 % implicit
					[T1, P1, F1, exitflag] = num_methods{i}{j}(f, p1, fprime, dt(k), t_end);
				case 3 % linearized
					[T1, P1, exitflag] = num_methods{i}{j}(p1, dt(k), t_end);
				end

				if exitflag < 0;
					stable = false;
				else	
					S = norm(P1 - P_collection{k}, inf);
					if S > dp0 * (1 + 1e-4)
						stable = false;
					else
						stable = true;	
					end
				end
			end
			if stable
				fprintf('|          + ');
			else
				fprintf('|          - ');
			end
		end

		fprintf('\n');
	end
end