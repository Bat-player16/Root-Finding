function [p,k,error_current,error_next,x_regression,y_regression,fzero_root] = ...
    fzero_converge(fun,x0_list,filter_list)

% test_func01 = @(x) (x.^3)/100 - (x.^2)/8 + 2*x + 6*sin(x/2+6) -.7 - exp(x/6); % function that we are finding roots for
% fun = test_func01; % set function to variable to use when function is called
% x0 = 1 + 0.5*rand(1,150);
% dxtol = 1e-14;
% ftol = 1e-100;
% max_iter = 1000;
% true_root = 0.717441246283601;
    
fzero_root = fzero(fun,x0_list(1));
g_cf = [];
g1f = [];
record = input_recorder();
fzero_record = record.generate_recorder_fun(fun);
for n = 1:length(x0_list)
    x0 = x0_list(n);
    root_fz = fzero(fzero_record,x0);
    input_list = record.get_input_list();
    % error 
    ef = abs(input_list-fzero_root);
    if length(ef) >=2
        g_cf = [g_cf, ef(1:end-1)];
        g1f = [g1f, ef(2:end)];
    end
       record.clear_input_list();
end 
error_current = g_cf;
error_next = g1f;
x_regression = [];
y_regression = [];

for n = 1:length(g_cf)
    if g_cf(n) > filter_list(1) && ...
       g_cf(n) < filter_list(2) && ...
       g1f(n) > filter_list(3) && ...
       g1f(n) < filter_list(4)
            
            x_regression(end+1)= g_cf(n);
            y_regression(end+1)= g1f(n);
        end 
    end 

[p, k] = generate_error_fit(x_regression, y_regression);
fprintf('fzero p = %.6f, fzero k = %.6f\n',p,k);
fprintf('fzero root = %.12f\n',fzero_root);
fit_line_x_fz = 10.^(-8:.01:0);
fit_line_y_fz = k * fit_line_x_fz.^p;

figure
h1 = loglog(g_cf,g1f,'ro','MarkerFaceColor','r','MarkerSize',4);
hold on
h2 = loglog(x_regression,y_regression,'bo','MarkerFaceColor','b','MarkerSize',4);
h3 = loglog(fit_line_x_fz,fit_line_y_fz,'k-','LineWidth',2);
xlabel('Error at Current Iteration $\epsilon_n$ (-)','Interpreter','latex','FontSize',14)
ylabel('Error at Next Iteration $\epsilon_{n+1}$ (-)','Interpreter','latex','FontSize',14)
title('\bf Error Convergence of fzero Method with Fit','Interpreter','latex','FontSize',20)
legend([h1 h2 h3],{'Unfiltered Data','Filtered Data','Fit Line'},'Location','best','Interpreter','latex','FontSize',12)
set(gca, 'FontSize', 12)
set(gca, 'XMinorTick', 'off', 'YMinorTick', 'off')
axis([1e-17, 1e2, 1e-17, 1e2])
hold off

end