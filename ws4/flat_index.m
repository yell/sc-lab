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
%}
if nargin < 5
	column_major = true;
end

if column_major
	flattened_index = (i - 1) * n + j;
else
	flattened_index = (j - 1) * m + i;
end