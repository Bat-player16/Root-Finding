function generalized_newton_main(fun,x0,dxtol,ftol,max_iter,dxmax,x0_ref)

clc; close;

% define the function to solve ex:
%fun = @(x) (x-37.879).^2;
%fun = @(x) (x.^3)/100 - (x.^2)/8 + 2*x + 6*sin(x/2+6) -.7 - exp(x/6);

% Parameters
% initial guess
% x0 = 20;
% tolerance
% dxtol = 1e-12;
% ftol = 1e-12;
% max iterations
% max_iter = 100;
% max allowed newtons steps
% dxmax = 1e6;

% run genrealized newton solver
[x,exit_flag,x_list] = generalized_newton_solver_error (fun,x0, dxtol, ftol,max_iter, dxmax);

% results
fprintf('\n'); fprintf('GENERALIZED NEWTON METHOD RESULTS\n'); 
fprintf('---------------------------------\n'); 
fprintf('Root = %.15f\n',x); 
fprintf('Function value = %.15e\n',fun(x)); 
fprintf('Exit flag = %d\n',exit_flag); 
fprintf('Number of iterations = %d\n',length(x_list)-1);

% run convergence xp
%x0_ref = 0;
%x0_ref = 37.879;
figure;
generalized_newton_convergence_experiment(fun,x0_ref)

end

%f  = @(x) x.^3/100 - x.^2/8 + 2*x + 6*sin(x/2+6) - .7 - exp(x/6);

%df = @(x) 3*x.^2/100 - x/4 + 2 + 3*cos(x/2+6) - (1/6)*exp(x/6);

%ddf = @(x) 3*x/50 - 1/4 - (3/2)*sin(x/2+6) - (1/36)*exp(x/6);
