clc
clear


% some control variables
plot_solutions = true;
save_solutions = true;
explicit_euler = true;
implicit_euler = true;

% spatial resolutions
N_xs = 2 .^ (2:5) - 1; % 3, 7, ..., 31

% at which points in time to plot
plot_times = (1:4)/8;
plot_dts = diff([0, plot_times]);

fprintf('WARNING: do NOT close figures very quickly, \n         they need to be saved (at least that with subplots)!\n\n');


% 
%
% Explicit Euler

if explicit_euler

	step_method = @explicit_euler_step;
	step_method_str = 'Explicit Euler';
	fprintf('Computing and plotting %s ...\n\n', step_method_str);

	dts = 2 .^ (-6:-1:-12); % 1/64, ..., 1/4096

	% here all solutions are stored 
	% (and corresponding titles for subplots)
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

	% main loop
	for l = 1:numel(plot_dts)
		% for all grid sizes and time steps
		% compute to arrive to corresponding `plot_times`
		for j = 1:numel(N_xs)
			for k = 1:numel(dts)
				for o = 1:numel(1:int16(plot_dts(l)/dts(k)))
					T_prev = T_collection{j, k};
					T_collection{j, k} = step_method(T_prev, dts(k));	
				end
				% save separate plots as soon as available
				if plot_solutions && save_solutions
					title_str = strcat(step_method_str, ...
						               ', N_x=', num2str(N_xs(j)), ...
						               ', dt=2^{-', num2str(k + 5), '}', ...
						               ', 8t=', num2str(plot_times(l) * 8));
					surface_plot(T_collection{j, k}, title_str);
				end
			end
		end

		% display and save windows with subplots
		if plot_solutions
			title_str = strcat(step_method_str, ...
				               ', 8t=', num2str(plot_times(l) * 8));
			multiple_surface_plot(T_collection, title_str, title_strs);
		end
	end

	% print stability tabular
	fprintf(' Explicit Euler stability\n');
	fprintf('\n N_x = N_y \\ dt ');
	for k = 1:numel(dts)
		fprintf('| 1/%4d ', int16(1/dts(k)));
	end
	fprintf('\n');
	fprintf(repmat('-', 1, 79));
	for j = 1:numel(N_xs)
		fprintf('\n       %2d       ', N_xs(j));
		for k = 1:numel(dts)
			if 2 * dts(k) * (1 + N_xs(j)) ^ 2 < 1
				fprintf('|    +   ');
			else
				fprintf('|    -   ');
			end
		end
	end
	fprintf('\n\n')

end % explicit_euler



%
%
% Implicit Euler

if implicit_euler

	step_method = @implicit_euler_step;
	step_method_str = 'Implicit Euler';
	fprintf('\nComputing and plotting %s ...\n\n', step_method_str);

	dt = 1/64;

	% here all solutions are stored 
	% (and corresponding titles for subplots)
	T_collection = cell(numel(N_xs), numel(plot_times));
	title_strs = cell(numel(N_xs), numel(plot_times));

	% initialize all matrices
	for j = 1:numel(N_xs)
		N_x = N_xs(j);
		N_y = N_x;
		T_collection{j, 1} = make_initial([N_x N_y]);
		for l = 1:numel(plot_times)
			title_strs{j, l} = strcat('N_x=', num2str(N_xs(j)), ...
				                      ', 8t=', num2str(plot_times(l) * 8));
		end
	end

	% main loop
	for l = 1:numel(plot_dts)
		% for all grid sizes compute
		% to arrive to corresponding `plot_times`
		for j = 1:numel(N_xs)
			for o = 1:numel(1:int16(plot_dts(l)/dt))
				T_prev = T_collection{j, l};
				T_collection{j, l} = step_method(T_prev, dt);	
			end
			% copy all solutions to the next
			% for further computations
			if l < numel(plot_dts)
				T_collection{j, l + 1} = T_collection{j, l};
			end
			% save separate plots as soon as available
			if plot_solutions && save_solutions
				title_str = strcat(step_method_str, ...
					               ', N_x=', num2str(N_xs(j)), ...
					               ', dt=2^{-6}, 8t=', num2str(plot_times(l) * 8));
				surface_plot(T_collection{j, l}, title_str);
			end
		end
	end

	% display and save windows with subplots
	if plot_solutions
		title_str = strcat(step_method_str, ', dt=2^{-6}');
		multiple_surface_plot(T_collection, title_str, title_strs);
	end

end % implicit_euler