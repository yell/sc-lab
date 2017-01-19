clc
clear


% spatial resolutions
N_xs = 2 .^ (2:5) - 1; % 3, 7, ..., 31

% solving methods
step_methods = { @explicit_euler_step };
step_methods_strs = {'Explicit Euler', 'Implicit Euler'};

% temporal step sizes
dts_collection = {
	2 .^ (-6:-1:-12), % 1/64, ..., 1/4096
	[2 ^ (-6)]
};

% whether to plot solutions
plot_solutions = true;
save_solutions = true;

% at which points in time to plot
plot_times = (1:4)/8;
plot_dts = diff([0, plot_times]);


% main loop
for i = 1:numel(step_methods)
	dts = dts_collection{i};

	% here all solutions are stored
	T_collection = cell(numel(N_xs), numel(dts));
	title_strs = cell(numel(N_xs), numel(dts));

	% initialize all matrices
	for j = 1:numel(N_xs)
		N_x = N_xs(j);
		N_y = N_x;
		for k = 1:numel(dts)
			T_collection{j, k} = make_initial([N_x N_y]);
			title_strs{j, k} = strcat('N_x=', num2str(N_xs(j)), ', dt=2^{-', num2str(k + 5), '}');
		end
	end

	for l = 1:numel(plot_dts)
		% for all grid sizes and time steps
		% compute to arrive to corresponding `plot_times`
		for j = 1:numel(N_xs)
			for k = 1:numel(dts)
				for o = 1:numel(1:int16(plot_dts(l)/dts(k)))
					T_prev = T_collection{j, k};
					T_collection{j, k} = step_methods{i}(T_prev, dts(k));	
				end
			end
		end

		
		if plot_solutions
			% plot together
			title_str = strcat(step_methods_strs{i}, ...
				               ', 8t=', num2str(plot_times(l) * 8));
			multiple_surface_plot(T_collection, title_str, title_strs);

			% ... and separately
			if save_solutions
				for j = 1:numel(N_xs)
					for k = 1:numel(dts)
						title_str = strcat(step_methods_strs{i}, ...
							               ', N_x=', num2str(N_xs(j)), ...
							               ', dt=2^{-', num2str(k + 5), '}', ...
							               ', 8t=', num2str(plot_times(l) * 8));
						surface_plot(T_collection{j, k}, title_str);
					end
				end
			end
		end
	end
end


% print stability tabular for Explicit Euler (i = 1)
fprintf('\n Explicit Euler stability\n');
fprintf('\n N_x = N_y \\ dt ');
for k = 1:numel(dts_collection{1})
	fprintf('| 1/%4d ', int16(1/dts_collection{1}(k)));
end
fprintf('\n');
fprintf(repmat('-', 1, 79));
for j = 1:numel(N_xs)
	fprintf('\n       %2d       ', N_xs(j));
	for k = 1:numel(dts_collection{1})
		if 2 * dts_collection{1}(k) * (1 + N_xs(j)) ^ 2 < 1
			fprintf('|    +   ');
		else
			fprintf('|    -   ');
		end
	end
end
fprintf('\n')