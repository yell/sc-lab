function [T_next, exitflag, iter] = implicit_euler_step(T_prev, dt, params)
%{
Perform one step of implicit Euler method 
for spatially discretized heat equation:

	T_t = T_xx + T_yy

with respect to the time variable t using
Gauss-Seidel method.

Parameters
----------
T_prev : (N_x + 2, N_y + 2) matrix
	Computed solution at the current time `t`
	with boundary values included (hence "+2").
dt : positive float
	Step size.
maxiter : int, optional
	Maximum number of iterations to perform. 
	Default is inf.
tol : float, optional
	RMSE between `b` and A * `x`. Default is 1e-6.

Returns
-------
T_next : (N_x + 2, N_y + 2) matrix
	Computed solution for the next time step (`t` + `dt`).
exitflag : int
	encodes the exit condition, meaning the reason 
	`implicit_euler_step` stopped its iteratons.
	 0 : success
	-1 : maximum number of iterations reached
iter : int
	number of iterations performed
%}

% set default values
tol = 1e-6;
maxiter = inf;

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

[m n] = size(T_prev);
N_x = m - 2;
N_y = n - 2;
C_x = (1 + N_x) ^ 2; % == h_x ^ (-2)
C_y = (1 + N_y) ^ 2; % == h_y ^ (-2)
tol = (N_x * N_y) * tol ^ 2; % now check SSE < tol

T_next = zeros(N_x + 2, N_y + 2);

% the algorithm
iter = 0;
r = inf;

while( r > tol )
	iter = iter + 1;
	if iter > maxiter
		exitflag = -1;
		iter = iter - 1;
		return;
	end

	% update T_next{i, j}
	for j = 2:(N_y + 1)
		for i = 2:(N_x + 1)
			% (i, j) are always in "genuine" domain of T_prev/T_next
			S1 = -dt * C_x * T_next( i - 1, j ) - dt * C_y * T_next( i, j - 1 );
			S2 = -dt * C_x * T_next( i + 1, j ) - dt * C_y * T_next( i, j + 1 );
			T_next(i, j) = 1 / (1 + 2 * dt * (C_x + C_y)) * ( T_prev(i, j) - S1 - S2 );
		end
	end

	% update residual
	r = 0;
	for j = 2:(N_y + 1)
		for i = 2:(N_x + 1)
			% (i, j) are always in "genuine" domain of T_prev/T_next
            T_approx = (1 + 2 * dt * (C_x + C_y)) * T_next(i, j) ...
			           - dt * C_x * ( T_next( i - 1, j ) + T_next( i + 1, j ) ) ...
			           - dt * C_y * ( T_next( i, j - 1 ) + T_next( i, j + 1 ) );
			r = r + ( T_prev(i, j) - T_approx ) ^ 2;
		end
	end
end

exitflag = 0;
end