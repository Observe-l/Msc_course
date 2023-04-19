syms z kp ki
% syms z
a = 0.9897;
b = 0.05263;
d = 0;
% kp = 0.001;
% ki = -0.005;
kp_min = 10;
kp_max = 100;
num_points_kp = 100;

ki_min = 10;
ki_max = 100;
num_points_ki = 100;

% T = 1;
gamma = 0.1;

equal_z = b*z^(-d-1)*(kp + ki*0.01*z/(z-1)) + 1 - a*z^(-1) == 0;

solution_z = solve(equal_z,z);


% Define the search range for kp and ki
kp_range = linspace(kp_min, kp_max, num_points_kp);
ki_range = linspace(ki_min, ki_max, num_points_ki);

% Initialize variables to store the results
kp_negative_real = [];
ki_negative_real = [];

% Iterate over different values of kp and ki
for kp_val = kp_range
    for ki_val = ki_range
        % Substitute the values of kp and ki into the solution
        z_val = subs(solution_z, [kp, ki], [kp_val, ki_val]);
        
        % Check if the real part of z is negative for any solution
        if any(real(z_val) < 0)
            % Store the kp and ki values
            kp_negative_real = [kp_negative_real, kp_val];
            ki_negative_real = [ki_negative_real, ki_val];
        end
    end
end

% Display the kp and ki values for which the real part of z is negative
disp(kp_negative_real)
disp(ki_negative_real)
