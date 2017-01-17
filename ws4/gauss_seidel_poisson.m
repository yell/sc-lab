function [T, exitflag, iter] = gauss_seidel_poisson(sz, b, params)
%{
Solve discretized system for Poisson equation with Dirichlet
boundary conditions (see details in `make_system.m`) 
using (inplace) Gauss-Seidel method.

Parameters
----------
sz : positive int or (int, int) tuple
	Govern dimensions of discretization grid.
	`sz` == [N_x, N_y] or `sz` == [N_x], then N_y := N_x.
b : (N_y, N_x) matrix
	Rhs.
maxiter : int, optional
	Maximum number of iterations to perform. Default if 200.
tol : float, optional
	RMSE between `b` and A * `x`. Default is 1e-4.

Returns
-------
T : (N_y + 2, N_x + 2) matrix
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
if maxiter <= 0
	maxiter = inf;
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
tol = N * tol ^ 2; % now check SSE < tol

% the algorithm
iter = 0;
T = zeros(N_y + 2, N_x + 2);
r = inf;

while( r > tol )
	iter = iter + 1;
	if iter > maxiter
		exitflag = -1;
		iter = iter - 1;
		return;
	end

	% update T_{i, j}
	for j = 2:(N_x + 1)
		for i = 2:(N_y + 1)
			% (i, j) are always in "genuine" domain of T
			z = T(i, j);
			S1 = C_y * T( i - 1, j ) + C_x * T( i, j - 1 );
			S2 = C_y * T( i + 1, j ) + C_x * T( i, j + 1 );
			T(i, j) = -0.5 / (C_x + C_y) * ( b(i - 1, j - 1) - S1 - S2 );
		end
	end

	% update residual
	r = 0;
	for j = 2:(N_x + 1)
		for i = 2:(N_y + 1)
			% (i, j) are always in "genuine" domain of T
			b_approx = - 2 * (C_x + C_y) * T(i, j) ...
			           + C_y * T( i - 1, j ) + C_x * T( i, j - 1 ) ...
			           + C_y * T( i + 1, j ) + C_x * T( i, j + 1 );
			r = r + ( b(i - 1, j - 1) - b_approx ) ^ 2;
		end
	end
end

exitflag = 0;
end