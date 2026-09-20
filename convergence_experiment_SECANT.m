%starter code for convergence experiments
function [p,k,error_current,error_next,x_regression,y_regression]=...
    convergence_experiment_SECANT(fun,x0_ref,num_iter, ftol,max_iter,min_denom,dxtol,filter_list)
    

%Initial guess near the root we are analyzing convergence behavior
%(you will need to change this depending on the test function and root)

x0_ref = 0.5;
iter = 0;
% find ref root
target_root = fzero(fun,x0_ref);
abs_error_next=[];
abs_error_current=[];
%Create an instance of the input_recorder
%my_recorder = input_recorder();

%Use input_recorder to generate a version of the test function
%that records the input after every iteration
%Since test_fun is defined using function keyword
%f_record = my_recorder.generate_recorder_fun(@the_function01);

%number of trials we would like to perform
% num_iter = 1000;

%solver parameters
% dxtol = 1e-15;
% ftol = 1e-15;
% iter=1;
% max_iter = 200;
% min_denom=10^-8;

%list for the initial guesses that we would like
%to use each trial. These guesses have all been chosen
%so that each trial will converge to the same root
x0_list = linspace(x0_ref-2,x0_ref+2,num_iter);
x1_list = linspace(x0_ref+2,x0_ref-2,num_iter);
%list of estimate at current iteration (x_{n})
%compiled across all trials
x_current_list = [];
%list of estimate at next iteration (x_{n+1})
%compiled across all trials
x_next_list = [];
%keeps track of which iteration (n) in a trial
%each data point was collected from
index_list = [];

%loop through each trial
for n = 1:num_iter

    %pull out the left and right guess for the trial
    x0 = x0_list(n);
    x1 = x1_list(n);

    %reset input_list for the next test
    % my_recorder.clear_input_list();

    %Call your root finder using the recording function
    %you will need to change this, depending on the solver
    [x_roots] = secant_solver_error(fun,x0,x1,ftol,iter,max_iter,min_denom,dxtol);
    
    % need at least 2 iterations
    if numel(x_roots)<2
        continue
    end
    
    %calc errors
    abs_error_current=[abs_error_current,abs(x_roots(1:end-1)-target_root)];
    abs_error_next=[abs_error_next,abs(x_roots(2:end)-target_root)];
    %See what input values were used when f_record was called:

    %at this point, input_list will be populated with the values that
    %the solver called at each iteration.
    %In other words, it is now [x_1,x_2,...x_n-1,x_n]
end 

%At this point, x_current_list corresponds to many many
%measurements of x_{n} across many trials
%and x_next_list corresponds to many many measurements of
%the corresponding value of x_{n+1} across many trials
%this is the data the you want to clean and analyze
%compute the absolute value of the error for current/next iteration
%generate a loglog plot
% Clean the data step 5
%example for how to filter the error data
%currently have error_list0, error_list1, index_list

%data points to be used in the regression
x_regression = []; % e_n`
y_regression = []; % e_{n+1}
filter_list = [1e-15, 1e-2, 1e-14, 1e-2, 2];

%iterate through the collected data
for n=1:length(abs_error_next)
    %if the error is not too big or too small
    %and it was enough iterations into the trial...
    if abs_error_current(n)>filter_list(1) && ...
       abs_error_current(n)<filter_list(2) && ...
       abs_error_next(n)>filter_list(3) && ...
       abs_error_next(n)<filter_list(4) %&& ...
       %index_list(n)>filter_list(5)

        %then add it to the set of points for regression
        x_regression(end+1) = abs_error_current(n);
        y_regression(end+1) = abs_error_next(n);
    end % closes step 5 loop
end 

% step 6 generate a loglog plot
[p,k] = generate_error_fit_secant(x_regression, y_regression);
p;
k;
fprintf('p = %f\n', p);
fprintf('k = %f\n', k);
fprintf('secant root = %.12f\n',x_roots(end));

%example for how to plot fit line
%generate x data on a logarithmic range
fit_line_x = 10.^(-14:0.01:4);

%compute the corresponding y values
fit_line_y = k*fit_line_x.^p;

figure
h1 = loglog(abs_error_current,abs_error_next,'ro','MarkerFaceColor','r','MarkerSize',4);
hold on
h2 = loglog(x_regression,y_regression,'bo','MarkerFaceColor','b','MarkerSize',4);
h3 = loglog(fit_line_x,fit_line_y,'k-','LineWidth',2);
xlabel('Error at Current Iteration $\epsilon_n$ (-)','Interpreter','latex','FontSize',14)
ylabel('Error at Next Iteration $\epsilon_{n+1}$ (-)','Interpreter','latex','FontSize',14)
title('\bf Error Convergence of Secant Method with Fit','Interpreter','latex','FontSize',20)
legend([h1 h2 h3],{'Unfiltered Data','Filtered Data','Fit Line'},'Location','best','Interpreter','latex','FontSize',12)
set(gca, 'FontSize', 12)
set(gca, 'XMinorTick', 'off', 'YMinorTick', 'off')
axis([1e-13, 1e-1, 1e-17, 1e-2])
hold off

%assigned output variables
error_current = abs_error_current;
error_next = abs_error_next;
end

% % step 7
% x = 0.5;
% 
% [dfdx,d2fdx2] = approximate_derivative(@(x) ...
% (x.^3)/100 - (x.^2)/8 + 2*x + ...
% 6*sin(x/2+6) -.7 - exp(x/6), x);
% 
% fprintf('First derivative = %f\n',dfdx);
% fprintf('Second derivative = %f\n',d2fdx2);

%Definition of the test function and its derivative (as a single function):
%This definition uses the function keyword
%when passing this function as an argument to a solver,
%you'll need to use the handle operator
%ex. solver(@test_func01,x_guess)



