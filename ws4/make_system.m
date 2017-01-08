function [A, b] = make_system(sz, params)
%{
Construct a resulting system for discretized Poisson equation
with Dirichlet boundary conditions:

	T_xx + T_yy = `f`(x, y)
	T(x, y) = 0 on boundary of (0; 1)^2

using discretization formulae:

	T_xx ~ h_x ^ (-2) * [ T_{i - 1, j} - 2T_ij + T_{i + 1, j} ]
	T_yy ~ h_y ^ (-2) * [ T_{i, j - 1} - 2T_ij + T_{i, j + 1} ],

where h_x := (1 + N_x)^(-1), 
      h_y := (1 + N_y)^(-1).

The system is aimed to satisfy the equation:

	`A` * x = `b`,

where x = (T_11, T_21, ..., T_{N_x, 1}, T_12, ....., T_{N_x, N_y})^T --
	  vector of unrolled (column-wise) unknowns T_ij := T(i * h_x, j * h_y).

Parameters
----------
sz : positive int or (int, int) tuple
	Govern dimensions of discretization grid.
	`sz` == [N_x, N_y] or `sz` == [N_x], then N_y := N_x.
rhs : 2-ary function, optional
	Rhs of Poisson equation. If provided, `b` is computed. Default is false.
sparse : bool, optional
	Whether to return sparse matrix (`A`). Default is true.

Returns
-------
A : (N, N) matrix
	The resulting matrix, N := N_x * N_y.
b : (N,) vector, optional
	Rhs of the linear system.
%}

% set default values
rhs = [];
sparse_matrix = true;

% process optional parameters
if nargin == 2
	for i = 1:2:numel(params)
		switch params{i}
		case 'rhs'
			rhs = params{i + 1};
		case 'sparse'
			sparse_matrix = params{i + 1};
		otherwise
			error(['unrecognized parameter: ', params{i}])
		end
	end
end

% set some variables for convenience
compute_rhs = ~isempty(rhs);
if numel(sz) == 1
	[N_x] = sz;
	N_y = N_x;
elseif numel(sz) >= 2
	N_x = sz(1);
	N_y = sz(2);
else
	error('parameter `sz` cannot be empty')
end

N = N_x * N_y;
C_x = (1 + N_x) ^ 2;
C_y = (1 + N_y) ^ 2;

% initialize variables to return
if sparse_matrix
	A = sparse(N, N);
else
	A = zeros(N);
end
if compute_rhs
	b = zeros(N, 1);
else
	b = false;
end

% main loop
for i = 1:N_y
	for j = 1:N_x
		current_row = flat_index(i, j, N_y, N_x); % == (i - 1) * N_x + j
		A( current_row, current_row ) = -2 * (C_x + C_y);
		if i > 1
			A( current_row, flat_index(i - 1, j, N_y, N_x) ) = C_x;
		end
		if i < N_y
			A( current_row, flat_index(i + 1, j, N_y, N_x) ) = C_x;
		end
		if j > 1
			A( current_row, flat_index(i, j - 1, N_y, N_x) ) = C_y;
			% flat_index(i, j - 1, ...) == current_row - 1
		end
		if j < N_x
			A( current_row, flat_index(i, j + 1, N_y, N_x) ) = C_y;
			% flat_index(i, j + 1, ...) == current_row + 1
		end
		if compute_rhs
			b( current_row ) = rhs( i/(1 + N_x), j/(1 + N_y) );
		end
	end
end