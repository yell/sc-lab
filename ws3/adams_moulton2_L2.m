function [T, Y, exitflag] = adams_moulton2_L2(y0, dt, t_begin, t_end)
%{
Solve ODE 
y' = 7 * (1 - y/10) * y
using linearised version (v2) of second order Adams-Moulton scheme

Parameters
----------
y0 : float
	initial value y(t_begin=0)
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
exitflag : int
	encodes the exit condition, meaning the reason `implicit_euler` 
	stopped its iteratons.
	 0 : success
	-1 : NaN or Inf function value was encountered
%}
if nargin < 4
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
exitflag = 0;

for i = 1:(n - 1)
	w = 1 - 3.5 * dt + 0.35 * dt * Y(i);
	if abs(w) < 1e-8
		w = 1e-8; % prevent zero division
	end
	
	y = Y(i) * (1 + 3.5 * dt - 0.35 * dt * Y(i)) / w;
	if (isinf(y) | isnan(y))
		exitflag = -1;
		T = T(1:numel(Y));
		return;
	end

	Y = [Y; y];
end