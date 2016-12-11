function [T, Y] = adams_moulton2_L2(y0, dt, t_begin, t_end)
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
	Computed values of y_k. Length is n, where
	n = |t_begin:dt:t_end| = floor( (t_end - t_begin)/dt + 1 ).
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
Y = zeros(n, 1);

Y(1) = y0;

for i = 1:(n - 1)
	w = 1 - 3.5 * dt + 0.35 * dt * Y(i);
	if abs(w) < 1e-8
		w = 1e-8; % prevent zero division
	end
	Y(i + 1) = Y(i) * (1 + 3.5 * dt - 0.35 * dt * Y(i)) / w;
end