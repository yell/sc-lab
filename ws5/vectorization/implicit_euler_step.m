function [T_next, exitflag, iter] = implicit_euler_step(T_prev, dt)
%{
Perform one step of implicit Euler method 
for spatially discretized heat equation:

	T_t = T_xx + T_yy

with respect to the time variable t using
the vectorised parallel Gauss-Seidel method.

Alternating nodes (1 & 2) vs (3 & 4) 
are accessed using an indexing scheme.
for N=7. Note that the right and bottom 
zeros are conceptually defined but
ommitted by matlab

The following matlab code:
m = 7; n = 7;
i = 2:2:m-1; j = 2:2:n-1; U(i,j) = 1
i = 3:2:m-1; j = 3:2:n-1; U(i,j) = 2
i = 2:2:m-1; j = 3:2:n-1; U(i,j) = 3
i = 3:2:m-1; j = 2:2:n-1; U(i,j) = 4

creates this matrix:

U=  |0     0     0     0     0     0|
    |0     1     3     1     3     1|
    |0     4     2     4     2     4|
    |0     1     3     1     3     1|
    |0     4     2     4     2     4|
    |0     1     3     1     3     1|
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


[p q] = size(T_prev);
N_x = p - 2;
N_y = q - 2;
C_x = (1 + N_x) ^ 2;        % = 1/hx^2
C_y = (1 + N_y) ^ 2;
tol = N_x*N_y * tol ^ 2;    % now check SSE < tol
den=1/(2*(C_x+C_y)*dt+1);   % for conveenience


% the algorithm
iter = 0;
T_next = T_prev;     %best starting point is the previous step
T_prev_approx = zeros(p, q);    % predefine matrix size
r = inf;

while not ( tol > r )
	iter = iter + 1;
	if iter > maxiter
		exitflag = -1;
		iter = iter - 1;
		return;
    end
    
    % access nodes 1 and 2
    i = 2:2:p-1; j = 2:2:q-1;
		T_next(i,j) = ( T_prev(i,j)  + dt*( C_x*T_next(i-1,j) ...
					+ C_x*T_next(i+1,j) +C_y* T_next(i,j-1) ...
								+C_y*T_next(i,j+1) ) )*den;
    i = 3:2:p-1; j = 3:2:q-1;
       T_next(i,j) = ( T_prev(i,j)  + dt*( C_x*T_next(i-1,j) ...
				+ C_x*T_next(i+1,j) +C_y* T_next(i,j-1)  ...
								+C_y*T_next(i,j+1) ) )*den;
    % access nodes 3 and 4
    i = 2:2:p-1; j = 3:2:q-1;
       T_next(i,j) = ( T_prev(i,j)  + dt*( C_x*T_next(i-1,j) ...
				+ C_x*T_next(i+1,j) +C_y* T_next(i,j-1)  ...
								+C_y*T_next(i,j+1) ) )*den;
    i = 3:2:p-1; j = 2:2:q-1;
       T_next(i,j) = ( T_prev(i,j)  + dt*( C_x*T_next(i-1,j) ...
					+ C_x*T_next(i+1,j) +C_y* T_next(i,j-1) ...
								+C_y*T_next(i,j+1) ) )*den;
    
    % Vectorised (I-dt*A)*T_next to find approximate T_prev value
    i = 2:p-1; j = 2:q-1;
		T_prev_approx(i,j) = (1+(2*(C_x+C_y))*dt)*T_next(i,j) ...
				- dt*( C_x*T_next(i-1,j) + C_x*T_next(i+1,j) ...
						+ C_y*T_next(i,j-1) + C_y*T_next(i,j+1) ) ;
    
    %work out the residual
    n=1:numel(T_prev);
    r =  sum ( ( T_prev_approx(n) - T_prev(n) ).^2  );
    
end
r=0;
exitflag = 0;
end