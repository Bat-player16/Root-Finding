%template for testing your basic root finding implementations
function basic_solver_with_tests_template_newton()
    xvals = linspace(-50,50,201);
    [yvals,~] = test_func01(xvals);

    hold on
    axis([-15,40,-50,80]);
    plot(xvals,yvals,'r','linewidth',2);
    plot(xvals,0*xvals,'k--','linewidth',1);
    xlabel('x'); ylabel('y'); title('Test Function 1');

    % Newton's method example test
    x0_guess = 2;
    plot(x0_guess,test_func01(x0_guess),'bo','markerfacecolor','b','markersize',5);

    x_sol = newton_solver(@test_func01,x0_guess);
    plot(x_sol,test_func01(x_sol),'go','markerfacecolor','g','markersize',5);
    
end

% Definition of the test function and its derivative (as a single function):
% This definition uses the function keyword
% when passing this function as an argument to a solver,
% you'll need to use the handle operator
% ex. solver(@test_func01,x_guess)
function [fval,dfdx] = test_func01(x)
    fval = (x.^3)/100 - (x.^2)/8 + 2*x + 6*sin(x/2+6) -.7 - exp(x/6);
    dfdx = 3*(x.^2)/100 - 2*x/8 + 2 +(6/2)*cos(x/2+6) - exp(x/6)/6;
end

% Note that fun(x) should output [f,dfdx], where dfdx is the derivative of f
function x = newton_solver(fun,x0)
% Max at 100 iterations
    for i = 1:100
% Find all variables needed for Newton's Method
        [f,dfdx] = fun(x0);
% Stops if it gets to 0.001
        if abs(f) <= 1e-3
            break
        end
% Keeps running Newton's function
        x0 = x0 - f/dfdx;
    end   
    x = x0;
end



