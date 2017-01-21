function [T, exitflag, iter] = gauss_seidel_poisson(sz, b, params)
%{
Solve discretized system for Poisson equation with Dirichlet
boundary conditions (see details in `make_system.m`) 
using (inplace) Gauss-Seidel method.

TODO :  This line b = b / C_x; means this implementation is only
        good for square matricies.
        However, by removing all the 1/h^2 coeffieients
        the code looks really nice. 

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
tol = 1e-6;
maxiter = 10000;

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
	%N_x = sz(1);
	%N_y = sz(2);
    error('only square matricies valid')
else
	error('parameter `sz` cannot be empty')
end
p = N_x + 2;  %total x lines including boundaries
q = N_y + 2;
N = N_x * N_y; %number of non boundary points
C_x = (1 + N_x) ^ 2;  % = 1/hx^2
C_y = (1 + N_y) ^ 2;
b = b / C_x;
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

	% Set indexing where N_x is number of "non-boundary" points
    % ie 5 points total = 3 non-boundary ; 2:3+1 itterates non-boundary

    i = 2:2:(N_x + 1); 
    j = 2:2:(N_y + 1);
    
    % Imagine the space discretization as a checkerboard.  The black
    % squares can all be updated at once since they dont depend on the white squares.
    % I guess updating say 30 squares at once is the same as 30 sequential passes
    % through a "for" loop.  Same for white squares.  The alternating
    % squares can be identified by the mod command
    
    %as usual we need the boundary condtions attached
    b_full = zero_pad(b);
    
    %case 1 (white squares): mod(i+j,2)
    T(i,j) = (-b_full(i,j) + T(i-1,j) + T(i+1,j) + T(i,j-1) + T(i,j+1))/4;
    i = 3:2:p-1; j = 3:2:q-1;
    T(i,j) = (-b_full(i,j) + T(i-1,j) + T(i+1,j) + T(i,j-1) + T(i,j+1))/4;
    % case 2 (black squares): mod(i+j,2) == 1
    i = 2:2:p-1; j = 3:2:q-1;
    T(i,j) = (-b_full(i,j) + T(i-1,j) + T(i+1,j) + T(i,j-1) + T(i,j+1))/4;
    i = 3:2:p-1; j = 2:2:q-1;
    T(i,j) = (-b_full(i,j) + T(i-1,j) + T(i+1,j) + T(i,j-1) + T(i,j+1))/4;
    
    % Vectorised A*T (withouth A)to find approximate b value
    j = 2:(N_x + 1);
    i = 2:(N_y + 1);
    b_approx(i,j) =  -4*T(i,j) + T(i-1,j) + T(i+1,j) + T(i,j-1) + T(i,j+1);
    
    %remove the unwanted residual zeros 
    b_approx = b_approx(2:end,2:end);
    
    %work out the residual
    n=1:numel(b);
   
    r =  sum ( ( b_approx(n)-b(n) ).^2  );
    
end
r=0;
T;
exitflag = 0;
end
