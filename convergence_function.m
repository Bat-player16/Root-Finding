function convergence_function(solver_flag, fun, x_guess0,guess_list1, guess_list2, filter_list)

% Example template for analysis function
% INPUTS:
% solver_flag: an integer from 1-4 indicating which solver to use
% 1->Bisection, 2-> Newton, 3-> Secant, 4-> fzero
% fun: the mathematical function that we are using the
% solver to compute the root of
% x_guess0: the initial guess used to compute x_root
% guess_list1: a list of initial guesses for each trial
% guess_list2: a second list of initial guesses for each trial
% if guess_list2 is not needed, then set to zero in input
% filter_list: a list of constants used to filter the collected data

% Parameters
dxtol = 1e-12;
ftol = 1e-12;
max_iter = 100;
dxmax = 1e6;
x0 = 20;
x0_ref = x_guess0(1);

true_root = fzero(fun, x_guess0(1));

min_denom = 1e-8;

    % Bisection Method
    if solver_flag == 1

        [p,k,eb,e1b,x_regression,y_regression,bisection_root] = ...
            bisect_converge(fun,dxtol,ftol,max_iter,guess_list1,guess_list2,true_root,filter_list);
        fprintf('Bisection root: %.12f\n',bisection_root);
    
    % Newton's Method
    elseif solver_flag == 2
        x0_list = guess_list1;
        [p,k,newton_root] = generalized_newton_convergence_experiment( ...
            fun,x0_ref,dxtol,ftol,max_iter,dxmax,x0_list,filter_list);
        fprintf('Newton root: %12f\n', newton_root)

    % Secant's Method
    elseif solver_flag == 3
        num_iter = length(guess_list1);
        [p,k,error_current,error_next,x_regression,y_regression] = ...
            convergence_experiment_SECANT( ...
            fun,x0_ref,num_iter,ftol,max_iter,min_denom,dxtol,filter_list);

    %fzero method
    elseif solver_flag == 4

        x0_list = guess_list1;

        [p,k,error_current,error_next,x_regression,y_regression,fzero_root] = ...
            f_zero_normal_function(fun,x0_list,filter_list);
  
else
    error('Invalid Solver_flag number');

end
end