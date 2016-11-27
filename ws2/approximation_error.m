function E = approximation_error(y_ref, y_approx, dt, t_begin, t_end)
%{
Compute approximation error between `y_ref` and `y_approx`, 
using the following formula:

	E = sqrt( `dt`/(`t_end` - `t_begin`) * SSE  ),

where SSE - sum squared error between `y_ref` and `y_approx`

Parameters
----------
y_ref, y_approx : vector of floats
	Reference (e.g. exact) solution and an approximation of it
dt : float
	step size
t_begin, t_end : float
	Domain endpoints. If only 1 time argument t is passed (positional argument is t_begin),
	the domain is understood as [0; t].

Returns
-------
E : float
	A computed error
%}
if nargin < 5
	t_end = t_begin;
	t_begin = 0;
end

% swap domain endpoints if needed
if t_begin > t_end
	[t_begin, t_end] = deal(t_end, t_begin)
end

z = y_ref - y_approx;
E = sqrt( dt/(t_end - t_begin) * sum(z .* z) );