function [x, exitflag, iter] = gauss_seidel_poisson(sz, b, params)
%{
Solve discretized system for Poisson equation with Dirichlet
boundary conditions (see details in `make_system.m`) 
using (inplace) Gauss-Seidel method.

Parameters
----------
sz : positive int or (int, int) tuple
	Govern dimensions of discretization grid.
	`sz` == [N_x, N_y] or `sz` == [N_x], then N_y := N_x.
b : (N,) vector
	Rhs.
maxiter : int, optional
	Maximum number of iterations to perform. Default if 200.
tol : float, optional
	Rmse between `b` and A * `x`. Default is 1e-4.

Returns
-------
x : (N,) vector
	The solution.
exitflag : int
	encodes the exit condition, meaning the reason `gauss_seidel` 
	stopped its iteratons.
	 0 : success
	-1 : maximum number of iterations reached
iter : int
	number of iterations performed
%}

% set default values
tol = 1e-4;
maxiter = 200;

% process optional parameters
if nargin == 3
	for i = 1:2:numel(params)
		switch params{i}
		case 'tol'
			tol = params{i + 1};
		case 'maxiter'
			maxiter = params{i + 1};
		otherwise
			error(['unrecognized parameter: ', params{i}])
		end
	end
end

% set some variables for convenience
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

% validate params
assert( numel(b) == N );

	function d = a_k_x(k, y)
	%{
	Compute the product of k-th row of A and vector `y`.

	Parameters
	----------
	k : positive int
	y : (N,) vector

	Returns
	-------
	d : float
		A_k * y.
	%}
		assert( numel(y) == N );
		i = floor((k - 1) / N_x) + 1;
		j = mod(k - 1, N_x) + 1;
		assert( k == flat_index(i, j, N_y, N_x) );
		d = -2 * (C_x + C_y) * y(k);
		if i > 1
			d = d + C_x * y( flat_index(i - 1, j, N_y, N_x) );
		end
		if i < N_y
			d = d + C_x * y( flat_index(i + 1, j, N_y, N_x) );
		end
		if j > 1
			d = d + C_y * y( flat_index(i, j - 1, N_y, N_x) );
		end
		if j < N_x
			d = d + C_y * y( flat_index(i, j + 1, N_y, N_x) );
		end
	end

% the algorithm
iter = 0;
x = zeros(N, 1);
r = inf;

while( r > tol )
	iter = iter + 1;
	if iter > maxiter
		exitflag = -1;
		iter = iter - 1;
		return;
	end

	for k = 1:N
		S1 = a_k_x( k, [ x(1:(k - 1)); zeros(N - k + 1, 1) ] );
		S2 = a_k_x( k, [  zeros(k, 1);        x((k + 1):N) ] );
		x(k) = -0.5 / (C_x + C_y) * ( b(k) - S1 - S2 );
	end

	r = rmse(b, arrayfun(@(k) a_k_x(k, x), 1:N).');
end

exitflag = 0;
end