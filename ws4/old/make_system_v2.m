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
compute_A : bool, optional
	Whether to compute `A`. Default is true.
f : 2-ary function, optional
	Rhs of Poisson equation. If provided, `b` is computed. Default is none.
sparse : bool, optional
	Whether to return sparse matrix (`A`). Default is true.

Returns
-------
A : (N, N) matrix
	The resulting matrix, N := N_x * N_y.
b : (N,) vector, optional
	Rhs of the linear system.

Examples
--------
>> make_system([3, 2], {'sparse', false})

ans =

   -50     9     0    16     0     0
     9   -50     9     0    16     0
     0     9   -50     0     0    16
    16     0     0   -50     9     0
     0    16     0     9   -50     9
     0     0    16     0     9   -50
%}

% set default values
f = [];
compute_A = true;
sparse_matrix = true;

% process optional parameters
if nargin == 2
	for i = 1:2:numel(params)
		switch params{i}
		case 'f'
			f = params{i + 1};
		case 'compute_A'
			compute_A = params{i + 1};
		case 'sparse'
			sparse_matrix = params{i + 1};
		otherwise
			error(['unrecognized parameter: ', params{i}])
		end
	end
end

% ensure we actually compute something
compute_rhs = ~isempty(f);
if (compute_A == false) && (compute_rhs == false)
	error('either `compute_A` must be true or `f` must be provided');
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

% initialize `A`
if compute_A
	if sparse_matrix
		A = sparse(N, N);
	else
		A = zeros(N);
	end
else
	A = false;
end

% initialize `b`
if compute_rhs
	b = zeros(N, 1);
    hx = 1/(N_x+1);
    hy = 1/(N_y+1);
[x,y]=ndgrid( [linspace(0+hx,1-hx,N_x)], [linspace(0+hy,1-hy,N_y)] );
S=@(x,y)-2.*pi.^2.*sin(pi.*x).*sin(pi.*y);
b = S(x,y); 
b=b';
b=b(:);
else
	b = false;
end


% make some diagonals 
[cy,cx,xxU,xxL,yy]= deal ( (ones(N,1) ));
c = -2 * ( C_x*cx + C_y*cy );  
xxU = C_x * xxU;
xxL = C_x * xxL;
yy = C_y * yy;

% Create the inner diagonal patterns 
xxU([N_x+1:N_x:N],:)=0;       %upper x(i+1) set right edges to boundary conditions
xxL([N_x:N_x:N],:)=0;         %lower x(i-1) sets left edges to boundary conditions

% Form the A matrix  
A = spdiags([yy xxL c xxU yy], [-N_x -1 0 1 N_x], N, N);


