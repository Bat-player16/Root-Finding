function sigmoid_bisect()

   function [f_val,dfdx] = test_function03(x)
    a = 27.3; b = 2; c = 8.3; d = -3;
    H = exp((x-a)/b);
    dH = H/b;
    L = 1+H;
    dL = dH;
    f_val = c*H./L+d;
    dfdx = c*(L.*dH-H.*dL)./(L.^2);
   end

    n = 100;
    x0 = linspace(-200,200,n);
    x1 = linspace(-200,200,n);
    [X0, X1] = meshgrid(x0, x1);

    dxtol = 1e-14; % interval tolerance 
    ftol = 1e-100; % root tolerance 
    max_iter = 1000; % max number of iterations
    true_root = 26.161810936220348; % very exact root to use to compute error

    success0 = [];
    fail0 = [];
    success1 = [];
    fail1 = [];
    
    for j = 1: size(X0,1)
        for i = 1:size(X1,1)
        l = min(X0(i,j), X1(i,j));
        r = max(X0(i,j), X1(i,j));
       
        try 
         atmpt = bisect(@test_function03, l, r, dxtol, ftol, max_iter);
                if abs(true_root - atmpt) < .05
                    success0(end+1) = X0(i,j);
                    success1(end+1) = X1(i,j);
                else
                    fail0(end+1) = X0(i,j);
                    fail1(end+1) = X1(i,j);
                end
            catch
                % same-sign guess (no bracket) or any other bisect error
                fail0(end+1) = X0(i,j);
                fail1(end+1) = X1(i,j);
         end
            
        end 

    end 

    figure
    hold on
    plot(success0, success1, 'bo', 'markerfacecolor', 'blue', 'MarkerSize', 3)
    plot(fail0, fail1, 'ro', 'markerfacecolor', 'red', 'MarkerSize', 3)
    plot(true_root, true_root, 'ko', 'MarkerFaceColor','black', 'MarkerSize'    ,5)
    xlabel('Left Guesses');
    ylabel('Right Guesses');
    title('Bisection Success vs Failure on Sigmoid Function');
    legend('Success', 'Failure','Root');
    axis square
    grid on

end 