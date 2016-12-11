function [T, Y, F, exitflag] = implicit_euler(f, y0, fprime, dt, t_begin, t_end)
%{
Solve ODE y'(t) = f(t, y(t)) using implicit Euler scheme.

Parameters
----------
f : 2-ary function
	Rhs of a differential equation.
	Should take floats or vector of floats as both arguments.
y0 : float
	initial value y(t_begin=0)
fprime : 2-ary function
	Derivative of rhs w.r.t. the second argument.
dt : float
	Step size.
t_begin, t_end : float
	Domain endpoints. If only 1 time argument t is passed (positional argument is t_begin),
	the domain is understood as [0; t].

Returns
-------
T : vector of floats
	Time points for which approximation to the solution is evaluated.
Y : vector of floats
	Computed values of y_k.
F : vector of floats
	Computed values of f(t_k, y_k).
exitflag : int
	encodes the exit condition, meaning the reason `implicit_euler` 
	stopped its iteratons.
	 0 : success
	-1 : unable to solve the respective equation at some step
%}
if nargin < 6
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

for i = 1:(n - 1)
	F = [F; f( T(i), Y(i) )];

	G = @(y) y - dt * f( T(i), y ) - Y(i);
	Gprime = @(y) 1 - dt * fprime( T(i), y );
	[y, exitflag] = newton(G, Y(i), Gprime);
	if exitflag < 0
		exitflag = -1;
		return;
	end

	Y = [Y; y];
end