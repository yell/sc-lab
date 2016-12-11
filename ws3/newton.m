function [root, iter, exitflag] = newton(f, x0, fprime, params)
%{
Find root f(x) = 0 of a scalar function using Newton's method:

                   f(x_n)
x_{n + 1} = x_n - -------
                  f'(x_n)

Parameters
----------
f : function
	the objective function
x0 : float
	initial guess
fprime : function
	a derivative of the objective function
xtol : float, optional
	Absolute error in `root` between iterations that is acceptable 
	for convergence. Default is 1e-4.
ftol : float, optional
	Stop when the absolute value of the `f` is less than `ftol`.
	Default is 1e-4.
maxiter : int, optional
	Maximum number of iterations to perform. Default if 200.

Returns
-------
root : float
	the solution
iter : int
	number of iterations performed
exitflag : int
	encodes the exit condition, meaning the reason `newton_scalar` 
	stopped its iteratons.
	 0 : success
	-1 : maximum number of iterations reached
	-2 : NaN or Inf function value was encountered
%}

% set default values
xtol = 1e-4;
ftol = 1e-4;
maxiter = 200;

% process optional parameters
if nargin == 4
	for i = 1:2:numel(params)
		switch params{i}
		case 'xtol'
			xtol = params{i + 1};
		case 'ftol'
			ftol = params{i + 1};
		case 'maxiter'
			maxiter = params{i + 1};
		otherwise
			error(['newton: unrecognized parameter: ', params{i}])
		end
	end
end

% the algorithm
iter = 0;
root = x0;
x0 = inf;
f1 = f(root);
f0 = inf;

while( abs(root - x0) > xtol | abs(f1 - f0) > ftol )
	iter = iter + 1;
	if iter > maxiter
		exitflag = -1;
		return;
	end

	x0 = root;
	f0 = f1;

	fprime0 = fprime(x0);
	if abs(fprime0) < 1e-8
		fprime0 = 1e-8; % prevent zero division
	end

	root = x0 - f0/fprime0;
	f1 = f(root);
	if (isinf(f1) | isnan(f1))
		exitflag = -2;
		return;
	end
end

exitflag = 0;