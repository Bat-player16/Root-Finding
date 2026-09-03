% Test
function [fval,dfdx] = test_func01(x)
    fval = (x.^3)/100 - (x.^2)/8 + 2*x + 6*sin(x/2+6) -.7 - exp(x/6);
    dfdx = 3*(x.^2)/100 - 2*x/8 + 2 +(6/2)*cos(x/2+6) - exp(x/6)/6;
end

[x, exit_flag] = newton_solvers(@test_func01, -3, 1e-6, 1e-6, 100,1e6);
% Root finding function via Newton's method

% INPUTS:
% fun: the function we are computing the root of
% Note that fun(x) should output [f,dfdx], where dfdx is the derivative of f
% (see test_func01 below for example)
% x0: initial guess for Newton's method
% dxtol: how little x can change before stopping. termination threshold (stop when interval abs(x_{i+1}-x_i) < dxtol)
% ftol: how close f(x) gets to 0 before stopping. termination threshold (stop when abs(f(x_{i}))<ftol
% max_iter: maximum iteration limit
% dxmax: how much of a change is too big to be useful before stopping. threshold for checking for a divide by zero error:
% terminate when abs(x_{i+1}-x_i) > dxmax, where dxmax is a very large number
% OUTPUTS
% x: estimate for root of fun
% exit_flag: an integer indicating whether or not the solver succeeded,
% 1 = succeeded, 0 = reached max iterations, -1 = the the change was too
% big
function [x, exit_flag] = newton_solvers(fun,x0,dxtol,ftol,max_iter,dxmax)

% Max at max iterations
    for i = 1:max_iter
% Find all variables needed for Newton's Method
        [f,dfdx] = fun(x0);
% Stops if x gets close to ftol a small number near 0
        if abs(f) <= ftol
            x = x0;
            exit_flag = 1;
            return
        end
% Keeps running Newton's function
        x_new = x0 - f/dfdx;

% Stops if difference in x values is larger than dxmax
        if abs(x_new - x0) >dxmax
            x = x0;
            exit_flag = -1;
            return
        end
            
% Stops if the change in x gets really close to 0
        if abs(x_new -x0) < dxtol
            x = x_new;
            exit_flag = 1;
            return
        end

% For next iteration
    x0 = x_new;
    end

% Reached maximum number of iterations
x = x0;
exit_flag = 0;
end
