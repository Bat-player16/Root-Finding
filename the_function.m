function [fval] = the_function(x)
     %fval = (x.^3)/100 - (x.^2)/8 + 2*x + 6*sin(x/2+6) -.7 - exp(x/6);
     global input_list;
        input_list(:,end+1) = x;
        fval = (x-37.879).^2;
        dfdx = 2*(x-37.879);
 end