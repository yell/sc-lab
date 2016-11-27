function [T, Y, F] = rk4(f, y0, dt, t_begin, t_end)
%{
Solve ODE y'(t) = f(t, y(t)) using (explicit) 4-th order Runge-Kutta scheme.

Parameters
----------
f : 2-ary function
	Rhs of a differential equation.
	Should take floats or vector of floats as both arguments.
y0 : float
	initial value y(t_begin=0)
dt : float
	step size
t_begin, t_end : float
	Domain endpoints. If only 1 time argument t is passed (positional argument is t_begin),
	the domain is understood as [0; t].

Returns
-------
T : vector of floats
	Time points for which approximation to the solution is evaluated
Y : vector of floats
	Computed values of y_k. Length is n, where
	n = |t_begin:dt:t_end| = floor( (t_end - t_begin)/dt + 1 ).
F : matrix of size (n - 1, 4) of floats
	Computed values of f(t_k, y_k). One of dimensions is (n - 1), 
	since the evaluation at last time point is not necessary.
%}
if nargin < 5
	t_end = t_begin;
	t_begin = 0;
end

% swap domain endpoints if needed
if t_begin > t_end
	[t_begin, t_end] = deal(t_end, t_begin)
end

T = t_begin:dt:t_end;
n = numel(T);
Y = zeros(n, 1);
F = zeros(n - 1, 4);

Y(1) = y0;
dt2 = dt/2;

for i = 1:(n - 1)
	F(i, 1) = f( T(i), Y(i) );
	F(i, 2) = f( T(i) + dt2, Y(i) + dt2 * F(i, 1) );
	F(i, 3) = f( T(i) + dt2, Y(i) + dt2 * F(i, 2) );
	F(i, 4) = f( T(i) + dt, Y(i) + dt * F(i, 3) );
	Y(i + 1) = Y(i) + dt/6 * (F(i, 1) + 2*F(i, 2) + 2*F(i, 3) + F(i, 4));
end