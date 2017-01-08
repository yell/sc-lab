clc
clear


% rhs and its derivative
f = @(x, y) (-2 * pi^2 * sin(pi * x) * sin(pi * y));

% dimensions of grid
N_x = 2 .^ (3:7) - 1; % 7, 15, ..., 127

% solving methods
solving_methods_strs = {'Full matrix', 'Sparse matrix', 'Gauss-Seidel'};
solving_methods = 1:numel(solving_methods_strs);

% main loop
for i = solving_methods

	runtimes = {};
	storages = {};
	B = {};

	for j = 1:numel(N_x)

		[none, b] = make_system(N_x(j), {'f', f, 'compute_A', false}); % compute b only
		B{j} = b;

		switch i
		case 1 % solving using full matrix
			if j == numel(N_x) % do not compute for N_x = 127
				continue;
			end
			A = make_system(N_x(j), {'sparse', false}); % compute A only
			t_start = tic;
			x = A\B{j};
			t_total = toc(t_start);
			runtimes{j} = t_total;
			num_elements = numel(A) + numel(B{j}) + numel(x);
			storages{j} = num_elements;

			n_x = N_x(j);
			n_y = n_x;
			N = n_x * n_y;
			assert( num_elements == N ^ 2 + N + N );
			
		case 2 % solving using sparse matrix
			if j == numel(N_x) % do not compute for N_x = 127
				continue;
			end
			A_sparse = make_system(N_x(j), {'sparse', true}); % compute A only
			t_start = tic;
			x = A_sparse\B{j};
			t_total = toc(t_start);
			runtimes{j} = t_total;
			num_elements = nnz(A_sparse) + numel(B{j}) + numel(x);
			storages{j} = num_elements;

			n_x = N_x(j);
			n_y = n_x;
			N = n_x * n_y;
			assert( num_elements == (n_x ^ 2 + 2*n_x*(n_x - 1) + 2*n_y*(n_y - 1)) + N + N );
			

		case 3 % solving iteratively using Gauss-Seidel method
			t_start = tic;
			% TODO gauss_seidel_poisson(N_x{j}, B{j})
			t_total = toc(t_start);
			runtimes{j} = t_total;
			num_elements = 2 * numel(B{j});
			storages{j} = num_elements;

			n_x = N_x(j);
			n_y = n_x;
			N = n_x * n_y;
			assert( num_elements == N + N );
		end
	end

	% print runtime and storage
	fprintf('\n\n');
	fprintf('%s\n', solving_methods_strs{i});
	fprintf(repmat('-', 1, 67));
	fprintf('\n N_x = N_y ');
	for j = 1:(numel(N_x) - 1)
		fprintf('|          %2d ', N_x(j));
	end
	fprintf('\n   runtime ');
	for j = 1:(numel(N_x) - 1)
		fprintf('|   %4.3e ', runtimes{j});
	end
	fprintf('\n   storage ');
	for j = 1:(numel(N_x) - 1)
		fprintf('|    %8d ', storages{j});
	end
	fprintf('\n');
end