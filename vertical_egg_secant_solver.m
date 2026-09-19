function s = vertical_egg_secant_solver(x_wrapper,y_wrapper,g_wrapper,s0,s1,determinator, iter, max_iter, min_denom);
denominator=((y_wrapper(s1)-y_wrapper(s0))/(x_wrapper(s1)-x_wrapper(s0)));
s = x_wrapper(s1)-y_wrapper(s1)/denominator;
root_list=[1,1];
    root_list(1)=s;
    while abs(g_wrapper(s))>.001 %%&& iter<max_iter% && abs(x_wrapper(s0)-x_wrapper(s1))>x_diff 
        iter=iter+1;
        s0=s1;
        s1=s;
        denominator=((y_wrapper(s1)-y_wrapper(s0))/(x_wrapper(s1)-x_wrapper(s0)));    
        s = x_wrapper(s1)-y_wrapper(s1)/denominator;
        root_list(iter)=s;
    end
end