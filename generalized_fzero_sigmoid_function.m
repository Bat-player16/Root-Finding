function generalized_fzero_sigmoid_function()

clc; close all; clear;

% sigmoid function paramters
a = 27.3; b = 2; c = 8.3; d = -3;
fun = @(x) c*exp((x-a)/b)./(1 + exp((x-a)/b)) + d;

% Newton solver parameters
dxtol = 1e-12;
ftol = 1e-12;
max_iter = 100;
dxmax = 1e6;

%find root using fzero
target_root = fzero(fun,a);

% inital guesses
x0_list = linspace (a-20, a+20, 1000);
% store successes
success_list = false(size(x0_list));

% test each guest
for n = 1:length(x0_list)
    %current initial guess
    x0 = x0_list(n);
    % Run newton's method
    [~,exit_flag,~] = fzero(fun,x0);
    % Record if succeed
    if abs(exit_flag) > 0
        success_list(n) = true;
    else
        success_list(n) = false;
    end
end 

% values for plotting
y_list = fun(x0_list);

figure;
hold on;
% plot successes
plot(x0_list(success_list),y_list(success_list),'bo','MarkerSize',1, ...
    'MarkerFaceColor','b','DisplayName','successful Convergence');
% plot failed initials guesses
plot(x0_list(~success_list),y_list(~success_list),'ro','MarkerSize',1, ...
    'MarkerFaceColor','b','DisplayName','failed Convergence');
%plot root
plot(target_root,0,'ko','MarkerSize',10, ...
    'MarkerFaceColor','g','DisplayName','root')
yline(0,'k--','LineWidth',1.5,'Displayname','y=0');
xlabel ('Function Input, x','FontSize',14);
ylabel ('Function Output, f(x)','FontSize',14);
title ("fzero's Method: Convergence of Inital Guesses for Sigmoid Function",'FontSize', 11)
legend('Location','best','FontSize',10);
hold off
end