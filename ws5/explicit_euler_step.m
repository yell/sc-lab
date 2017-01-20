function [T_next] = explicit_euler_step(T_prev, dt)
%{
Perform one step of explicit Euler method 
for spatially discretized heat equation:

	T_t = T_xx + T_yy

with respect to the time variable t.

Parameters
----------
T_prev : (N_x + 2, N_y + 2) matrix
	Computed solution at the current time `t`
	with boundary values included (hence "+2").
dt : positive float
	Step size.

Returns
-------
T_next : (N_x + 2, N_y + 2) matrix
	Computed solution for the next time step (`t` + `dt`).
%}

[m n] = size(T_prev);
N_x = m - 2;
N_y = n - 2;
C_x = (1 + N_x) ^ 2; % == h_x ^ (-2)
C_y = (1 + N_y) ^ 2; % == h_y ^ (-2)

T_next = zeros(N_x + 2, N_y + 2);

for j = 2:(N_y + 1)
	for i = 2:(N_x + 1)
		% (i, j) are always in "genuine" domain of T_prev/T_next
		T_next(i, j) = (1 - 2 * dt * (C_x + C_y) ) * T_prev(i, j) ...
					 + dt * C_x * ( T_prev(i - 1, j) + T_prev(i + 1, j) ) ...
					 + dt * C_y * ( T_prev(i, j - 1) + T_prev(i, j + 1) );
	end
end