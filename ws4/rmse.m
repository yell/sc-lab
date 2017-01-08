function E = rmse(u, v)
%{
Compute Root of Mean-Squared Error between `u` and `v`
using the following formula:

	E = sqrt( 1/N * sum_{i = 1}^{N}(`u`_i - `v`_i)^2 ),

where |u| = |v| = N.

Parameters
----------
u, v : (N,) arrays
	Two arrays to compute error between.

Returns
-------
E : float
	A computed RMSE

Example
-------
>> rmse([1 2 3], [0 0 0])

ans =

    2.1602
%}
z = u - v;
E = sqrt( sum(z .* z)/numel(u) );