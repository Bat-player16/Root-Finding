%template for testing your basic root finding implementations
% function basic_solver_with_tests_template()
%     xvals = linspace(-50,50,201);
%     [yvals,~] = the_function(xvals);
% 
%     hold on
%     axis([-15,40,-50,80]);
%     plot(xvals,yvals,'r','linewidth',2);
%     plot(xvals,0*xvals,'k--','linewidth',1);
%     xlabel('x'); ylabel('y'); title('Test Function 1');
% figure;

    % %Newton's method example test
    % x0_guess = 2;
    % iterations=1;
    % max_iterations=200;
    % accuracy=10^-14;
    % minimum_slope=.00000001; %If the derivative is below this, stop
    % x_difference=.00000001; %If difference between old and new x value is below this, stop
    % plot(x0_guess,the_function(x0_guess),'bo','markerfacecolor','b','markersize',5);
    % 
    % x_sol = newton_solver(@the_function,x0_guess, iterations, max_iterations, accuracy,minimum_slope, x_difference)
    % plot(x_sol,the_function(x_sol),'go','markerfacecolor','g','markersize',5);
   

    %Secant method example test
    % x0_guess = -5;
    % x1_guess = 2;
    % accuracy=10^-14; %How close we want our estimate to be to zero
    % max_iterations=200;
    % iterations=0;
    % smallest_denom=.0001;  %Smallest denominator allowed for secant method
    % x_difference=.00000001; %If difference between two guesses is below this, stop
    % 
    % plot(x0_guess,the_function(x0_guess),'bo','markerfacecolor','b','markersize',5);
    % plot(x1_guess,the_function(x1_guess),'ko','markerfacecolor','k','markersize',5);
    % 
    % x_sol = secant_solver(@the_function,x0_guess,x1_guess,accuracy, iterations, max_iterations, smallest_denom, x_difference);
    % plot(x_sol,the_function(x_sol),'go','markerfacecolor','g','markersize',5);

    
    %Bisection method example test
    % x_left = -5;
    % x_right = 2;
    % accuracy=10^-14; %How close we want our estimate to be to zero
    % max_iterations=200;
    % x_difference=.00000001; %If difference between two guesses is below this, stop
    % iterations=0;
    % plot(x_left,the_function(x_left),'bo','markerfacecolor','b','markersize',5);
    % plot(x_right,the_function(x_right),'ko','markerfacecolor','k','markersize',5);
    % 
    % x_sol = bisection_solver(@the_function,x_left,x_right,accuracy, iterations, max_iterations, x_difference);
  % plot(x_sol,the_function(x_sol),'go','markerfacecolor','g','markersize',5);
% end


%Definition of the test function and its derivative (as a single function):
%This definition uses the function keyword
%when passing this function as an argument to a solver,
%you'll need to use the handle operator
%ex. solver(@the_function,x_guess)

% function x = bisection_solver(fun,x_left,x_right, min_dy, iter, max_iter, x_diff)
% if the_function(x_left)*the_function(x_right)>0
%     fprintf('Error: No zero crossing from guesses')
% end
% x = (x_left+x_right)/2; 
% root_list=[1,1]
%     root_list(1)=x
% while abs(the_function(x))>min_dy && the_function(x_left)*the_function(x_right)<0 && iter<max_iter && abs(x_left-x_right)>x_diff
% %Loops as long as the output isn't within desired accuracy
% %Loops as long as the output has a zero crossing
% %Loops as long as the iteration count hasn't reached the max
% %Loops as long as the left and right guesses aren't too close already
% x = (x_left+x_right)/2;
% iter=iter+1
% root_list(iter)=x
% if the_function(x)>0    
% x_right=x;
% x = (x_left+x_right)/2; 
% elseif the_function(x)<0
% x_left=x;
% x = (x_left+x_right)/2; 
% else
% 
% end
% end
% x
% end
% 
% %Note that fun(x) should output [f,dfdx], where dfdx is the derivative of f
% function [x0,error_list] = newton_solver(fun,x0, iter, max_iter, min_dy,min_slope, x_diff)
%     [y, deriv] = the_function(x0);
%     root_list=[1,1]
%     root_list(1)=x0
%     error_list=zeros(1,2);
%  while iter<max_iter && abs(y)>min_dy && abs(x0-(x0-y/deriv))>x_diff
% error_list(iter,1)=abs(x0-.717441246283635)
%      x0=x0-y/deriv;
%      error_list(iter,2)=abs(x0-.717441246283635)
% [y,deriv] = the_function(x0);
% if deriv<min_slope
%     fprintf('Error: Division by ~0')
%     break;
% else
% x0;
% iter=iter+1;
% root_list(iter)=x0
% end
%  end
% end

function [root_list, success] = SCATTER_secant_solver_error(fun,x0, x1, min_dy, iter, max_iter, min_denom,x_diff)
root_list=[0,0];
denominator=((the_function_2(x1)-the_function_2(x0))/(x1-x0));    
x = x1-the_function_2(x1)/denominator;
success=1;
if x0==x1
success=0;
end
    root_list(1)=[x];
    while abs(the_function_2(x))>min_dy && abs(x1-x0)>x_diff && success~=0
        iter=iter+1;
        x0=x1;
        x1=x;
        denominator=((the_function_2(x1)-the_function_2(x0))/(x1-x0));  
        if denominator<min_denom
            %fprintf('Error: Division by ~0')
            success=0;
        break;
        if iter>max_iter
            %fprintf('Error: Unable to converge')
            success=0;
        break;
        else
        x = x1-the_function_2(x1)/denominator;
        root_list(iter)=[x];
        success=1;
        end
    end
    end
end