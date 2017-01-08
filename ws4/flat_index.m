function flattened_index = flat_index(i, j, m, n, column_major)
%{
Convert index in matrix to index in flattened array.

Parameters
----------
i, j : positive int
	Input index.
m, n : positive int
	Dimensions of matrix.
column_major : bool, optional
	Whether the matrix is flattened column-wisely 
	(otherwise row-wisely).

Examples
--------
+---+---+---+
| 1 | 2 | 3 |
+---+---+---+
| 4 | 5 | 6 |
+---+---+---+

>> flat_index(2, 2, 2, 3, true)

ans =

     5

+---+---+---+
| 1 | 3 | 5 |
+---+---+---+
| 2 | 4 | 6 |
+---+---+---+

>> flat_index(2, 2, 2, 3, false)

ans =

     4
%}
if nargin < 5
	column_major = true;
end

if column_major
	flattened_index = (i - 1) * n + j;
else
	flattened_index = (j - 1) * m + i;
end