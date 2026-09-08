test_func01 = @(x) (x.^3)/100 - (x.^2)/8 + 2*x + 6*sin(x/2+6) -.7 - exp(x/6);
fun = test_func01;
x0 = [20, 40]; 
dxtol = 1e-14;
ftol = 1e-100;
max_iter = 1000;
method = 1;
% l_list = 20 + 10*rand(1,150);
% r_list = 30 + 10*rand(1,150);
l_list = 0.1*rand(1,150);
r_list = 1 + 0.5*rand(1,150);
true_root = 0.717441246283601;


if method == 1 
   l = x0(1);
   r = x0(2);
  [root, iter, tries] = bisect (fun, l, r, dxtol, ftol, max_iter);
  fprintf('bisection root: %.6f  iters:%d\n', root, iter);

  e = []; % current error
  e1 = [];  % error n+1
  index_list = [];
  for t = 1:length(l_list)
      l = l_list(t);
      r = r_list(t); 
      if fun(l)*fun(r) > 0, continue, end

      [root_t, iter_t, tries_t] = bisect  (fun, l, r, dxtol, ftol, max_iter);
          if numel(tries_t) < 2, continue, end
          et = abs(tries_t - true_root);
          e = [e, et(1:end-1)];
          e1 = [e1, et(2:end)];
          index_list = [index_list, 1:(numel(et)-1)];

  end 


end 



%example for how to filter the error data
%currently have error_list0, error_list1, index_list
%data points to be used in the regression
x_regression = []; % e_n
y_regression = []; % e_{n+1}
filter_list = [1e-15, 1e-2, 1e-14, 1e-2, 2];
%iterate through the collected data
for n=1:length(index_list)
    %if the error is not too big or too small
    %and it was enough iterations into the trial...
    if e(n)>filter_list(1) && e(n)<filter_list(2) && ...
            e1(n)>filter_list(3) && e1(n)<filter_list(4) && ...
            index_list(n)>filter_list(5)
        %then add it to the set of points for regression
        x_regression(end+1) = e(n);
        y_regression(end+1) = e1(n);
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
%plot on a loglog plot. 



if method == 1
    loglog(e, e1, 'ro', 'markerfacecolor','r', 'markersize',2) 
    hold on
    loglog(fit_line_x,fit_line_y,'k-','linewidth',2)
    xlabel (' \epsilon_{n} (−)')
    ylabel ((' \epsilon_{n+1} (−)'))
    title('Bisection Method with Filtered Data')
    legend('Error', 'Fit Line', 'Location','best')
end