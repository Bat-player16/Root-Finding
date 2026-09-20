%starter code for convergence experiments
function [p,k,newton_root] = generalized_newton_convergence_experiment( ...
    test_fun,x0_ref,dxtol,ftol,max_iter,dxmax,x0_list,filter_list)

% find ref root
target_root = fzero(test_fun,x0_ref);

num_iter = length(x0_list);

%number of trials we would like to perform
% num_iter = 1000;
% 
% %solver parameters
% dxtol = 1e-12;
% ftol = 1e-12;
% max_iter = 200;
% dxmax = 1e10;

%list for the initial guesses that we would like
%to use each trial. These guesses have all been chosen
%so that each trial will converge to the same root
% x0_list = linspace(x0_ref-2,x0_ref+2,num_iter);

%list of estimate at current iteration (x_{n})
%compiled across all trials
x_current_list = [];
%list of estimate at next iteration (x_{n+1})
%compiled across all trials
x_next_list = [];
%keeps track of which iteration (n) in a trial
%each data point was collected from
index_list = [];
newton_root = [];

%loop through each trial
for n = 1:num_iter

    %pull out the left and right guess for the trial
    x0 = x0_list(n);

    % run gernealized newton solver
    [x,exit_flag,x_list] = generalized_newton_solver_error(test_fun,x0,dxtol,ftol,max_iter,dxmax);
    
    % only if successful
    if exit_flag == 1&&length(x_list)>=2
        
        if isempty(newton_root)
           newton_root = x;
        end
        %at this point, input_list will be populated with the values that
        %the solver called at each iteration.
        %In other words, it is now [x_1,x_2,...x_n-1,x_n]
        %append the collected data to the compilation
        x_current_list = [x_current_list,x_list(1:end-1)];
        x_next_list = [x_next_list,x_list(2:end)];
        index_list = [index_list,1:length(x_list)-1];
    end
end 

%At this point, x_current_list corresponds to many many
%measurements of x_{n} across many trials
%and x_next_list corresponds to many many measurements of
%the corresponding value of x_{n+1} across many trials
%this is the data the you want to clean and analyze
%compute the absolute value of the error for current/next iteration
abs_error_current = abs(x_current_list-target_root);
abs_error_next = abs(x_next_list-target_root);
%generate a loglog plot

% Clean the data step 5
%example for how to filter the error data
%currently have error_list0, error_list1, index_list

%data points to be used in the regression
x_regression = []; % e_n
y_regression = []; % e_{n+1}
%filter_list = [1e-15, 1e-2, 1e-14, 1e-2, 2];

%iterate through the collected data
for n=1:length(index_list)
    %if the error is not too big or too small
    %and it was enough iterations into the trial...
    if abs_error_current(n)>filter_list(1) && ...
       abs_error_current(n)<filter_list(2) && ...
       abs_error_next(n)>filter_list(3) && ...
       abs_error_next(n)<filter_list(4) && ...
       index_list(n)>filter_list(5)

        %then add it to the set of points for regression
        x_regression(end+1) = abs_error_current(n);
        y_regression(end+1) = abs_error_next(n);
    end % closes step 5 loop
end 

% step 6 generate a loglog plot
[p,k] = generalized_newton_generate_error_fit(x_regression,y_regression);

fprintf('p = %f\n', p);
fprintf('k = %f\n', k);

%example for how to plot fit line
%generate x data on a logarithmic range
fit_line_x = 10.^(-14:0.01:4);

%compute the corresponding y values
fit_line_y = k*fit_line_x.^p;

figure
%unfiltered data
h1 = loglog(abs_error_current, abs_error_next,'ro','MarkerFaceColor', 'r','MarkerSize', 4);
hold on
%filtered data
h2 = loglog(x_regression, y_regression,'bo','MarkerFaceColor', 'b', 'MarkerSize', 4);
% Fit line
h3 = loglog(fit_line_x, fit_line_y,'k-','LineWidth', 2);
xlabel('Error at Current Iteration $\epsilon_n$ (-)','Interpreter', 'latex','FontSize', 14)
ylabel('Error at Next Iteration $\epsilon_{n+1}$ (-)','Interpreter', 'latex','FontSize', 14)
title('\bf Error Convergence of Newton''s Method with Fit','Interpreter', 'latex','FontSize', 20)
legend([h1 h2 h3], {'Unfiltered Data', 'Filtered Data', 'Fit Line'},'Location', 'best','Interpreter', 'latex','FontSize', 12)
set(gca, 'FontSize', 12)
set(gca, 'XMinorTick', 'off', 'YMinorTick', 'off')
axis([1e-14, 1e4, 1e-18, 1e4])
hold off

% % step 7 find the first and second derivatives
% x = 0.5;
% [dfdx,d2fdx2] = newton_approximate_derivative(@(x)(x.^3)/100 - (x.^2)/8 + 2*x + 6*sin(x/2+6) -.7 - exp(x/6), x);
% fprintf('First derivative = %f\n',dfdx);
% fprintf('Second derivative = %f\n',d2fdx2);

% Definition of the test function and its derivative (as a single function):
% This definition uses the function keyword
% when passing this function as an argument to a solver,
% you'll need to use the handle operator
% ex. solver(@test_func01,x_guess)
end 

% function [fval,dfdx] = test_func01(x)
%     fval = (x.^3)/100 - (x.^2)/8 + 2*x + 6*sin(x/2+6) -.7 - exp(x/6);
%     dfdx = 3*(x.^2)/100 - 2*x/8 + 2 +(6/2)*cos(x/2+6) - exp(x/6)/6;





