function [T, Y, F, exitflag] = heun(f, y0, dt, t_begin, t_end)
%{
Solve ODE y'(t) = f(t, y(t)) using (explicit) Heun scheme.

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
	Computed values of y_k.
F : matrix of size (m, 2) of floats
	Computed values of f(t_k, y_k).
exitflag : int
	encodes the exit condition, meaning the reason `implicit_euler` 
	stopped its iteratons.
	 0 : success
	-1 : NaN or Inf function value was encountered
%}
if nargin < 5
	t_end = t_begin;
	t_begin = 0;
end

% swap domain endpoints if needed
if t_begin > t_end
	[t_begin, t_end] = deal(t_end, t_begin);
end

T = t_begin:dt:t_end;
n = numel(T);
Y = [y0];
F = [];
exitflag = 0;

for i = 1:(n - 1)
	f1 = f( T(i), Y(i) );
	f2 = f( T(i) + dt, Y(i) + dt * f1 );
	F = [F; [f1, f2]];

	y = Y(i) + dt/2 * (F(i, 1) + F(i, 2));
	if (isinf(y) | isnan(y))
		exitflag = -1;
		T = T(1:numel(Y));
		return;
	end
	
	Y = [Y; y];
end