function [T, Y, F] = explicit_euler(f, y0, dt, t_begin, t_end)
%{
Solve ODE y'(t) = f(t, y(t)) using explicit Euler scheme.

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
F : vector of floats
	Computed values of f(t_k, y_k). Length is (n - 1), 
	since the last evaluation is not necessary
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
F = zeros(n - 1, 1);

Y(1) = y0;
F(1) = f(t_begin, y0);

for i = 1:(n - 1)
	F(i) = f(T(i), Y(i));
	Y(i + 1) = Y(i) + dt * F(i);
end