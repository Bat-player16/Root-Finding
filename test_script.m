clc;
clear;
close all;

% Maximum number of guesses
%max_iter = 1000; % better for secant
max_iter = 1000; % better for newton & bisection

% Define function 
test_func01 = @(x) (x.^3)/100 - (x.^2)/8 + 2*x + 6*sin(x/2+6) - .7 - exp(x/6);
% Generate initial guess
x_guess0 = [-2, 5];
% Generate left and right guesses
guess_list1 = linspace(-5, -2, max_iter);
guess_list2 = linspace(2, 5, max_iter);

% for sigmoid
% a = 27.3; b = 2; c = 8.3; d = -3;
% test_func01 = @(x) c*exp((x-a)/b)./(1 + exp((x-a)/b)) + d; 
% x_guess0 = [25, 30];
% guess_list1 = linspace(20,25,max_iter);
% guess_list2 = linspace(25,30,max_iter);

% Select solver
% 1 = Bisection
% 2 = Newton
% 3 = Secant
% 4 = fzero
solver_flag = 4;

% Filtering parameters
filter_list = [1e-15, 1e-2, 1e-14, 1e-2, 2];

% Run convergence analysis
convergence_function(solver_flag, test_func01, x_guess0, ...
    guess_list1, guess_list2, filter_list);