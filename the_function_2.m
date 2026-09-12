function [fval, dfdx] = the_function_2(x)
    a = 27.3; b = 2; c = 8.3; d = -3;
    H = exp((x-a)/b);
    dH = H/b;
    L = 1+H;
    dL = dH;
    fval = c*H./L+d;
    dfdx = c*(L.*dH-H.*dL)./(L.^2);
 end