function [T_init] = make_initial(sz)
%{
Construct matrix with computed initial conditions (solution at t=0), 
that is constant (== 1.0) in this case along with (homogeneous) boundary 
conditions padded.

Parameters
----------
sz : positive int or (int, int) tuple
	Govern dimensions of discretization grid.
	`sz` == [N_x, N_y] or `sz` == [N_x], then N_y := N_x.

Returns
-------
T_init : (N_x + 2, N_y + 2) matrix
	Initial conditions with boundary values included.

Examples
--------
>> make_initial(3)

ans =

     0     0     0     0     0
     0     1     1     1     0
     0     1     1     1     0
     0     1     1     1     0
     0     0     0     0     0

>> make_initial([3 2])

ans =

     0     0     0     0
     0     1     1     0
     0     1     1     0
     0     1     1     0
     0     0     0     0
%}

% validate parameter
if numel(sz) == 1
	[N_x] = sz;
	N_y = N_x;
elseif numel(sz) >= 2
	N_x = sz(1);
	N_y = sz(2);
else
	error('parameter `sz` cannot be empty')
end

T_init = zero_pad(ones(N_x, N_y));