f = @(x) x^2;
x0 = 20;
fprime = @(x) 2 * x;
% usage:
% newton(f, x0, fprime)
% newton(f, x0, fprime, {'xopt', 1e-2})
% newton(f, x0, fprime, {'fopt', 1e-2})
% newton(f, x0, fprime, {'maxiter', 100})
% newton(f, x0, fprime, {'xopt', 1e-2, 'maxiter', 100})
[root, iter, exitflag] = newton(f, x0, df, {'maxiter', 200})