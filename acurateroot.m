test_func01 = @(x) (x.^3)/100 - (x.^2)/8 + 2*x + 6*sin(x/2+6) -.7 - exp(x/6);
f = test_func01;
x0 = [20, 40]; 
dxtol = 1e-14;
ftol = 1e-13;
max_iter = 1000;
method = 1;
l = -1; 
r  = 20;

[aroot, iter, glist] = bisect(f, l, r, dxtol, ftol, max_iter)
fprintf('%.15f\n', aroot);
