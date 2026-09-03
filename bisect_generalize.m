%% Definition of the test function and its derivative
test_func01 = @(x) (x.^3)/100 - (x.^2)/8 + 2*x + 6*sin(x/2+6) -.7 - exp(x/6);
test_derivative01 = @(x) 3*(x.^2)/100 - 2*x/8 + 2 +(6/2)*cos(x/2+6) - exp(x/6)/6;

l_0 = -1; % initial guess for bisect and secant 
r_0 = 70; % initial guess for bisect and secant 
x_0 = 40; % initial guess for Newtons method 
tol = 1e-6;



%Bisection Method 
bisect_root = bisect(test_func01,l_0,r_0,tol);
fprintf('bisection method root: %.4f\n', bisect_root)


%plot of the function and zeros 
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
title('Test Function 1')
end 


%% Part 1 Basic Implementation
% Use bisection method to make small piece of code we can later generalize

function root = bisect(f, l, r, tol)
% check are l and r different signs 
    if (f(l) * f(r) ) > 0 
%    error ('same sign guess'); 
    end 
while (r-l)/2 > tol %check to make sure interval is not too small
    m = (l+r)/2;
    if f(m) == 0 % find midpoint
        root = m;
        return; 
    end 
    % the first rule checks if the left and middle are opposite signs and since
    % (-)*(+) or (+)*(-) < 0 this can check the first rule and then change the
    % right coordinate to the midpoint, otherwise it fulfills the second rule
    if f(l)*f(m) < 0 
        r = m;
    else 
        l = m; 
    end 
end 
root = (l+r)/2; 
end 


