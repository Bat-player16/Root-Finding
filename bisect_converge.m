test_func01 = @(x) (x.^3)/100 - (x.^2)/8 + 2*x + 6*sin(x/2+6) -.7 - exp(x/6); % define function that is being evaluated 
fun = test_func01; % set function to variable so that multiple functions can be used 
dxtol = 1e-14; % interval tolerance 
ftol = 1e-100; % root tolerance 
max_iter = 1000; % max number of iterations
l_list = linspace(-5,-2,max_iter);
r_list = linspace(2,5,max_iter); % right guesses
true_root = 0.717441246283601; % very exact root to use to compute error
l=-2;
r=5;


  [root, iter, tries] = bisect (fun, l, r, dxtol, ftol, max_iter); % call function 
  fprintf('bisection root: %.6f  iters:%d\n', root, iter); % print the found root and number of attempts 

  eb = []; % current error
  e1b = [];  % error n+1
  step_count = []; % where did the error pair come from
  % loop through whole set of guesses
  for t = 1:length(l_list) 
      l = l_list(t);
      r = r_list(t); 
      if fun(l)*fun(r) > 0, continue, end

      [root_t, iter_t, tries_t] = bisect  (fun, l, r, dxtol, ftol, max_iter);
          if numel(tries_t) < 2, continue, end
          et = abs(tries_t - true_root);
          eb = [eb, et(1:end-1)];
          e1b = [e1b, et(2:end)];
          step_count = [step_count, 1:(numel(et)-1)];

  end 





%example for how to filter the error data
%currently have error_list0, error_list1, index_list
%data points to be used in the regression
x_regression = []; % e_n
y_regression = []; % e_{n+1}
filter_list = [1e-15, 1e-2, 1e-14, 1e-2, 2];
%iterate through the collected data
for n = 1:length(step_count)
    %if the error is not too big or too small
    %and it was enough iterations into the trial...
    if eb(n)>filter_list(1) && eb(n)<filter_list(2) && ...
            e1b(n)>filter_list(3) && e1b(n)<filter_list(4) && ...
            step_count(n)>filter_list(5)
        %then add it to the set of points for regression
        x_regression(end+1) = eb(n);
        y_regression(end+1) = e1b(n);
    end
end

[p,k] = generate_error_fit(x_regression,y_regression);

%example for how to compute the fit line
%data points to be used in the regression
%x_regression -> e_n
%y_regression -> e_{n+1}
%p and k are the output coefficients
function [p,k] = generate_error_fit(x_regression,y_regression)
%generate Y, X1, and X2
%note that I use the transpose operator (')
%to convert the result from a row vector to a column
%If you are copy-pasting, the ' character may not work correctly
Y = log(y_regression)';
X1 = log(x_regression)';
X2 = ones(length(X1),1);
%run the regression
coeff_vec = regress(Y,[X1,X2]);
%pull out the coefficients from the fit
p = coeff_vec(1);
k = exp(coeff_vec(2));
fprintf('p = %.6f, k = %.6f\n', p, k);
end
%example for how to plot fit line
%generate x data on a logarithmic range
fit_line_x = 10.^(-15:.01:1);
%compute the corresponding y values
fit_line_y = k*fit_line_x.^p;




figure;
% unfiltered data (all raw iterates, pink)
loglog(eb, e1b, 'ro','MarkerFaceColor','r', 'markersize',2)
hold on
% filtered data (the subset used for the fit, navy)
loglog(x_regression, y_regression, 'go','markerfacecolor','g' ,'markersize',2)
% fit line (black)
loglog(fit_line_x, fit_line_y, 'k-', 'linewidth', 2)
xlabel (' \epsilon_{n} (−)')
ylabel ((' \epsilon_{n+1} (−)'))
title('Bisection Method')
legend('Unfiltered Data', 'Filtered Data', 'Fit Line', 'Location','best')
















% figure;
% %plot on a loglog plot. 
% if method == 1
%     loglog(e, e1, 'ro', 'markerfacecolor','r', 'markersize',2) 
%     hold on
%     loglog(fit_line_x,fit_line_y,'k-','linewidth',2)
%     xlabel (' \epsilon_{n} (−)')
%     ylabel ((' \epsilon_{n+1} (−)'))
%     title('Bisection Method with Filtered Data')
%     legend('Error', 'Fit Line', 'Location','best')
% end
%%% extra 
% if method == 1 
%     l = x0(1);
%     r = x0(2);
%     [root, iter, tries] = bisect (fun, l, r, dxtol, ftol, max_iter);
%     fprintf('bisection root: %.6f  iters:%d\n', root, iter);
% 
%     ecb = []; % current error
%     e1b = [];  % error n+1
%     index_list = [];
%     for t = 1:length(l_list)
%         l = l_list(t);
%         r = r_list(t); 
%         if fun(l)*fun(r) > 0, continue, end
% 
%         [root_t, iter_t, tries_t] = bisect  (fun, l, r, dxtol, ftol, max_iter);
%         if numel(tries_t) < 2, continue, end
%         et = abs(tries_t - true_root);
%         ecb = [ecb, et(1:end-1)];
%         e1b = [e1b, et(2:end)];
%         index_list = [index_list, 1:(numel(et)-1)];
% 
%     end 
% 
% 
% end 
% 
% 
% 
% %example for how to filter the error data
% %currently have error_list0, error_list1, index_list
% %data points to be used in the regression
% x_regression = []; % e_n
% y_regression = []; % e_{n+1}
% filter_list = [1e-15, 1e-2, 1e-14, 1e-2, 2];
% %iterate through the collected data
% for n=1:length(index_list)
%     %if the error is not too big or too small
%     %and it was enough iterations into the trial...
%     if ecb(n)>filter_list(1) && ecb(n)<filter_list(2) && ...
%             e1b(n)>filter_list(3) && e1b(n)<filter_list(4) && ...
%             index_list(n)>filter_list(5)
%         %then add it to the set of points for regression
%         x_regression(end+1) = ecb(n);
%         y_regression(end+1) = e1b(n);
%     end
% end
