function [i, j] = unflat_index(k, m, n, column_major)
%{
Convert index in flattened array to index in matrix.

Parameters
----------
k : positive int
	Input index.
m, n : positive int
	Dimensions of matrix.
column_major : bool, optional
	Whether the matrix is flattened column-wisely 
	(otherwise row-wisely). Default is true.

Examples
--------
+---+---+---+
| 1 | 2 | 3 |
+---+---+---+
| 4 | 5 | 6 |
+---+---+---+

>> [i, j] = unflat_index(5, 2, 3, true)
i = 2
j = 2

+---+---+---+
| 1 | 3 | 5 |
+---+---+---+
| 2 | 4 | 6 |
+---+---+---+

>> [i, j] = unflat_index(4, 2, 3, false)
i = 2
j = 2
%}
if nargin < 4
	column_major = true;
end

if column_major
	i = floor((k - 1) / n) + 1;
	j = mod(k - 1, n) + 1;
else
	i = mod(k - 1, m) + 1;
	j = floor((k - 1) / m) + 1;
end