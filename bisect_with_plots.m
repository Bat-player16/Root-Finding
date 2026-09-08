%% Part 2: Generalized bisection method 
%INPUTS:
% fun: the function we are computing the root of
% l_0: left guess
% r_0: right guess
% note that f(x_left) and f(x_right) should have different signs
% dxtol: termination threshold (stop when interval x_right-x_left < dxtol)
% ftol: termination threshold (stop when abs(f(x_guess))<ftol
% max_iter: maximum iteration limit
%OUTPUTS
% x: estimate for root of fun

test_func01 = @(x) (x.^3)/100 - (x.^2)/8 + 2*x + 6*sin(x/2+6) -.7 - exp(x/6);
l_0 = -1; 
r_0 = 20;  
dxtol = 1e-6;
ftol = 1e-3;
max_iter = 1000;

%Call bisection method 
bisect_root = bisect(test_func01,l_0,r_0,dxtol, ftol, max_iter);
fprintf('bisection method root: %.4f\n', bisect_root)

%plot of the function and root calculated by bisect method
plotroots(test_func01,bisect_root) 

%% Plot function 
function plotroots(f,root_1)
x_list = linspace (-50, 50, 1e3);
y_list = f(x_list);
figure(1)
hold on 
plot(x_list,0*x_list, 'k');
plot(x_list,y_list,'b', 'LineWidth',1.5)
plot(root_1,f(root_1),'ro', 'MarkerSize',8)
axis([-15,40,-50,80])
xlabel('x (-)');
ylabel('f(x) (-)');
title('Bisection Method')
legend('y = 0', 'f(x)', 'root', 'Location', 'best')
end 



%define bisection method
function root = bisect(f, l, r, dxtol,ftol, max_iter)
% check are l and r different signs
    if f(l) * f(r) > 0 
    error ('same sign guess'); 
    end 

    iter = 1;
    m = (l + r) / 2;

 
while iter <= max_iter && (r-l) > dxtol && abs(f(m))>ftol %check to make sure interval is not too small
   
   
    % the first rule checks if the left and middle are opposite signs and since
    % (-)*(+) or (+)*(-) < 0 this can check the first rule and then change the
    % right coordinate to the midpoint, otherwise it fulfills the second rule
    m = (l + r) / 2;
 
    if f(l) * f(m) < 0 
        r = m;
    else 
        l = m; 
    end 
    iter = iter + 1;
end 
root = (l+r)/2; 

end
 


    