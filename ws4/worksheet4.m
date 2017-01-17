clc
clear


% rhs
f = @(x, y) (-2 * pi^2 * sin(pi * x) * sin(pi * y));

% dimensions of grid
N_xs = 2 .^ (3:7) - 1; % 7, 15, ..., 127

% solving methods
solving_methods_strs = {'Full matrix', 'Sparse matrix', 'Gauss-Seidel method'};
solving_methods = 1:numel(solving_methods_strs);

% precompute b's
B = {};
for j = 1:numel(N_xs)
	[none, b] = make_system(N_xs(j), {'f', f, 'compute_A', false}); % compute b only
	B{j} = b;
end

% whether to plot solutions
plot_solutions = true;

% errors for Gauss-Seidel
E = zeros(numel(N_xs), 1);

% main loop
fprintf('Computing and plotting ...\n');
for i = solving_methods

	runtimes = {};
	storages = {};

	for j = 1:numel(N_xs)

		N_x = N_xs(j);
		N_y = N_x;
		N = N_x * N_y;

		switch i
		case 1 % solving using full matrix
			if j == numel(N_xs) % do not compute for N_x = 127
				continue;
			end
			A = make_system(N_x, {'sparse', false}); % compute A only
			t_start = tic;
			x = A\B{j};
			t_total = toc(t_start);
			runtimes{j} = t_total;
			num_elements = numel(A) + numel(B{j}) + numel(x);
			storages{j} = num_elements;
			assert( num_elements == N ^ 2 + N + N );
			
		case 2 % solving using sparse matrix
			if j == numel(N_xs) % do not compute for N_x = 127
				continue;
			end
			A_sparse = make_system(N_x, {'sparse', true}); % compute A only
			t_start = tic;
			x = A_sparse\B{j};
			t_total = toc(t_start);
			runtimes{j} = t_total;
			num_elements = nnz(A_sparse) + numel(B{j}) + numel(x);
			storages{j} = num_elements;
			assert( num_elements == (N_x * N_y + 2*N_y*(N_x - 1) + 2*N_x*(N_y - 1)) + N + N );

		case 3 % solving iteratively using Gauss-Seidel method
			t_start = tic;
			[x, exitflag, iter] = gauss_seidel_poisson(N_x, B{j}, {'maxiter', 1000});
			t_total = toc(t_start);
			runtimes{j} = t_total;
			num_elements = numel(B{j}) + numel(x);
			storages{j} = num_elements;
			assert( num_elements == N + N );
			% exact solution
			[X, Y] = meshgrid((1:N_x)/(1 + N_x), (1:N_y)/(1 + N_y));
			T_exact = sin(pi * X) .* sin(pi * Y);
			% error
			E(j) = rmse(x, reshape(T_exact, [N_x * N_x, 1]));
		end

		% plot the solution
		if plot_solutions
			if j == numel(N_xs) % do not plot for N_x = 127
				continue;
			end
			T = reshape(x, [N_x, N_y]);
			T = zero_pad(T);
			title_str = strcat(solving_methods_strs{i}, ', N_x = ', num2str(N_x));
			surface_plot(T, title_str);
			contour_plot(T, title_str);
		end
	end

	% print runtime and storage
	fprintf('\n');
	fprintf('%s\n', solving_methods_strs{i});
	fprintf(repmat('-', 1, 64));
	fprintf('\n  N_x = N_y ');
	for j = 1:(numel(N_xs) - 1)
		fprintf('|         %2d ', N_xs(j));
	end
	fprintf('\n    runtime ');
	for j = 1:(numel(N_xs) - 1)
		fprintf('|  %4.3e ', runtimes{j});
	end
	fprintf('\n    storage ');
	for j = 1:(numel(N_xs) - 1)
		fprintf('|   %8d ', storages{j});
	end
	fprintf('\n');
end

% print errors and error reductions for Gauss-Seidel
fprintf('\n%s (max. 1000 iterations)\n', solving_methods_strs{3});
fprintf(repmat('-', 1, 77));
fprintf('\n  N_x = N_y ');
for j = 1:numel(N_xs)
	fprintf('|        %3d ', N_xs(j));
end
fprintf('\n      error ');
for j = 1:numel(N_xs)
	fprintf('| %1.4e ', E(j));
end
fprintf('\n error red. ');
for j = 1:numel(N_xs)
    
	if j == 1
		fprintf('|          - ');	
	else
		fprintf('|   %8.5f ', E(j - 1)/E(j));	
	end
end
fprintf('\n');