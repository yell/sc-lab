function A_padded = zero_pad(A)
%{
Pad matrix with zeros horizontally and vertically for both sided.

Parameters
----------
A : (m, n) matrix
	matrix to pad

Returns
-------
A_padded : (m + 2, n + 2) matrix
	padded matrix.

Examples
--------
A = rand(3)

    0.9575    0.9706    0.8003
    0.9649    0.9572    0.1419
    0.1576    0.4854    0.4218

>> zero_pad(A)

ans =

         0         0         0         0         0
         0    0.9575    0.9706    0.8003         0
         0    0.9649    0.9572    0.1419         0
         0    0.1576    0.4854    0.4218         0
         0         0         0         0         0
%}
[m n] = size(A);
A_padded = [zeros(m + 2, 1) [zeros(1, n); A; zeros(1, n)] zeros(m + 2, 1)];