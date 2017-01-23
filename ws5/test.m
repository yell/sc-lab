N = 2500;

T = make_initial(N);
tic;
for i = 1:100
	T = explicit_euler_step(T, 1/64);
end
toc;

T = make_initial(N);
tic;
for i = 1:100
	T = explicit_euler_step_vec(T, 1/64);
end
toc;