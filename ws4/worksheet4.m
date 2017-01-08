clc
clear


% rhs and its derivative
f = @(x, y) (-2 * pi^2 * sin(pi * x) * sin(pi * y));

[A, b] = make_system([3, 2], {'rhs', f, 'sparse', false});
A
b