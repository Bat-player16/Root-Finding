%starter code for convergence experiments
function SECANT_guess_scatter()

%Initial guess near the root we are analyzing convergence behavior
%(you will need to change this depending on the test function and root)

x0_ref = 0;
% find ref root
target_root = fzero(@the_function_2,x0_ref);
abs_error_next=[];
abs_error_current=[];
%Create an instance of the input_recorder
my_recorder = input_recorder();

%Use input_recorder to generate a version of the test function
%that records the input after every iteration
%Since test_fun is defined using function keyword
f_record = my_recorder.generate_recorder_fun(@the_function_2);

% %number of trials we would like to perform
num_iter = 200;
per_iter=200;

%solver parameters
dxtol = 1e-15;
ftol = 1e-15;
iter=1;
max_iter = 200;
min_denom=10^-8;

%list for the initial guesses that we would like
%to use each trial. These guesses have all been chosen
%so that each trial will converge to the same root
x0_list = linspace(x0_ref-200,x0_ref+200,num_iter);
x1_list = linspace(x0_ref-200,x0_ref+200,num_iter);
%list of estimate at current iteration (x_{n})
%compiled across all trials
x_current_list = [];
%list of estimate at next iteration (x_{n+1})
%compiled across all trials
x_next_list = [];
%keeps track of which iteration (n) in a trial
%each data point was collected from
index_list = [];
successes=[];
guess_history_0=[];
guess_history_1=[];
total_n=0;
%loop through each trial
for i = 1:per_iter
    x0=x0_list(i)
    for n = 1:num_iter
        x1=x1_list(n);
    total_n=total_n+1;
        %reset input_list for the next test
        my_recorder.clear_input_list();
        %Call your root finder using the recording function
        %you will need to change this, depending on the solver
        [x_roots,success] = SCATTER_secant_solver_error(f_record,x0,x1,ftol,iter,max_iter,min_denom,dxtol);
        successes(total_n)=success;
    abs_error_current=[abs_error_current,abs(x_roots(1:end-1)-target_root)];
    abs_error_next=[abs_error_next,abs(x_roots(2:end)-target_root)];
        %See what input values were used when f_record was called:
        guess_history_0(total_n)=x0;
        guess_history_1(total_n)=x1;
    end
end
 good_results_0=successes.*guess_history_0;
 good_results_1=successes.*guess_history_1;
 figure;
 hold on
 plot(guess_history_0,guess_history_1, 'r.')
 plot(good_results_0, good_results_1, 'b.')
 legend('Failed Guesses', 'Successful Guesses','Location','best' )
 title('Secant Method Sigmoid Function Guess Convergence ')
xlabel('x0 guesses'); ylabel('x1 guesses');
end