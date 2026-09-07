%template for testing your basic root finding implementations
function basic_solver_with_tests_template()
    xvals = linspace(-50,50,201);
    [yvals,~] = test_func01(xvals);

    hold on
    axis([-15,40,-50,80]);
    plot(xvals,yvals,'r','linewidth',2);
    plot(xvals,0*xvals,'k--','linewidth',1);
    xlabel('x'); ylabel('y'); title('Test Function 1');
figure;

    % %Newton's method example test
    % x0_guess = 2;
    % iterations=1;
    % max_iterations=200;
    % accuracy=10^-14;
    % minimum_slope=.00000001; %If the derivative is below this, stop
    % x_difference=.00000001; %If difference between old and new x value is below this, stop
    % plot(x0_guess,test_func01(x0_guess),'bo','markerfacecolor','b','markersize',5);
    % 
    % x_sol = newton_solver(@test_func01,x0_guess, iterations, max_iterations, accuracy,minimum_slope, x_difference)
    % plot(x_sol,test_func01(x_sol),'go','markerfacecolor','g','markersize',5);
   

    %Secant method example test
    % x0_guess = -5;
    % x1_guess = 2;
    % accuracy=10^-14; %How close we want our estimate to be to zero
    % max_iterations=200;
    % iterations=0;
    % smallest_denom=.0001;  %Smallest denominator allowed for secant method
    % x_difference=.00000001; %If difference between two guesses is below this, stop
    % 
    % plot(x0_guess,test_func01(x0_guess),'bo','markerfacecolor','b','markersize',5);
    % plot(x1_guess,test_func01(x1_guess),'ko','markerfacecolor','k','markersize',5);
    % 
    % x_sol = secant_solver(@test_func01,x0_guess,x1_guess,accuracy, iterations, max_iterations, smallest_denom, x_difference);
    % plot(x_sol,test_func01(x_sol),'go','markerfacecolor','g','markersize',5);

    
    %Bisection method example test
    % x_left = -5;
    % x_right = 2;
    % accuracy=10^-14; %How close we want our estimate to be to zero
    % max_iterations=200;
    % x_difference=.00000001; %If difference between two guesses is below this, stop
    % iterations=0;
    % plot(x_left,test_func01(x_left),'bo','markerfacecolor','b','markersize',5);
    % plot(x_right,test_func01(x_right),'ko','markerfacecolor','k','markersize',5);
    % 
    % x_sol = bisection_solver(@test_func01,x_left,x_right,accuracy, iterations, max_iterations, x_difference);
    % plot(x_sol,test_func01(x_sol),'go','markerfacecolor','g','markersize',5);
end


%Definition of the test function and its derivative (as a single function):
%This definition uses the function keyword
%when passing this function as an argument to a solver,
%you'll need to use the handle operator
%ex. solver(@test_func01,x_guess)
function [fval,dfdx] = test_func01(x)
    fval = (x.^3)/100 - (x.^2)/8 + 2*x + 6*sin(x/2+6) -.7 - exp(x/6);
    dfdx = 3*(x.^2)/100 - 2*x/8 + 2 +(6/2)*cos(x/2+6) - exp(x/6)/6;
end


function x = bisection_solver(fun,x_left,x_right, min_dy, iter, max_iter, x_diff)
if test_func01(x_left)*test_func01(x_right)>0
    fprintf('Error: No zero crossing from guesses')
end
x = (x_left+x_right)/2; 
root_list=[1,1]
    root_list(1)=x
while abs(test_func01(x))>min_dy && test_func01(x_left)*test_func01(x_right)<0 && iter<max_iter && abs(x_left-x_right)>x_diff
%Loops as long as the output isn't within desired accuracy
%Loops as long as the output has a zero crossing
%Loops as long as the iteration count hasn't reached the max
%Loops as long as the left and right guesses aren't too close already
x = (x_left+x_right)/2;
iter=iter+1
root_list(iter)=x
if test_func01(x)>0    
x_right=x;
x = (x_left+x_right)/2; 
elseif test_func01(x)<0
x_left=x;
x = (x_left+x_right)/2; 
else

end
end
x
end

%Note that fun(x) should output [f,dfdx], where dfdx is the derivative of f
function [x0,error_list] = newton_solver(fun,x0, iter, max_iter, min_dy,min_slope, x_diff)
    [y, deriv] = test_func01(x0);
    root_list=[1,1]
    root_list(1)=x0
    error_list=zeros(1,2);
 while iter<max_iter && abs(y)>min_dy && abs(x0-(x0-y/deriv))>x_diff
error_list(iter,1)=abs(x0-.717441246283635)
     x0=x0-y/deriv;
     error_list(iter,2)=abs(x0-.717441246283635)
[y,deriv] = test_func01(x0);
if deriv<min_slope
    fprintf('Error: Division by ~0')
    break;
else
x0;
iter=iter+1;
root_list(iter)=x0
end
 end
end

function x = secant_solver(fun,x0, x1, min_dy, iter, max_iter, min_denom,x_diff)
denominator=((test_func01(x1)-test_func01(x0))/(x1-x0));    
x = x1-test_func01(x1)/denominator;
root_list=[1,1]
    root_list(1)=[x]
    while abs(test_func01(x))>min_dy && iter<max_iter && abs(x1-x0)>x_diff
        iter=iter+1
        x0=x1;
        x1=x;
        denominator=((test_func01(x1)-test_func01(x0))/(x1-x0))  
        if denominator<min_denom
            fprintf('Error: Division by ~0')
        break;
        else
        x = x1-test_func01(x1)/denominator;
        root_list(iter)=[x]
    end
    end
    x
end

%Create an instance of the input_recorder
my_recorder = input_recorder();
%Use input_recorder to generate a version of the test function
%that records the input after every iteration
%Since test_fun is defined using function keyword
f_record = my_recorder.generate_recorder_fun(@test_func01);
%number of trials we would like to perform
num_iter = 1000;
%list for the initial guesses that we would like
%to use each trial. These guesses have all been chosen
%so that each trial will converge to the same root
%because the root is somewhere between -5 and 5.
x0_list = linspace(.6,.834,num_iter);
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
%reset input_list for the next test
my_recorder.clear_input_list();
%Call your root finder using the recording function:
    iterations=1;
    max_iterations=300;
    accuracy=10^-15;
    minimum_slope=.00000001; %If the derivative is below this, stop
    x_difference=10^-15; %If difference between old and new x value is below this, stop
[x_root,error_list] = newton_solver(f_record,x0, iterations, max_iterations, accuracy,minimum_slope, x_difference);
%See what input values were used when f_record was called:
error_list0=error_list(1);
error_list1=error_list(2);
input_list = my_recorder.get_input_list();
loglog(error_list0,error_list1,'ro','markerfacecolor','r','markersize',1);
hold on
%at this point, input_list will be populated with the values that
%the solver called at each iteration.
%In other words, it is now [x_1,x_2,...x_n-1,x_n]
%append the collected data to the compilation
% x_current_list = [x_current_list,input_list(1:end-1)];
% x_next_list = [x_next_list,input_list(2:end)];
% index_list = [index_list,1:length(input_list)-1];
% regression_line=regress(error_list1,error_list0)
% 
% fit_line_x = 10.^[-16:.01:1];
% fit_line_y=fit_line_x*regression_line;
% loglog(fit_line_x,fit_line_y,'k-','linewidth',2)
end