%Function that computes the bounding box of an oval
%INPUTS:
%theta: rotation of the oval. theta is a number from 0 to 2*pi.
%x0: horizontal offset of the oval
%y0: vertical offset of the oval
%egg_params: a struct describing the hyperparameters of the oval
%OUTPUTS:
%x_range: the x limits of the bounding box in the form [x_min,x_max]
%y_range: the y limits of the bounding box in the form [y_min,y_max]
function [x_range,y_range] = compute_bounding_box(x0,y0,theta,egg_params)

    %you may need to make additional wrapper functions
    %(you need one for x coord of G and one for y coord)
    %wrapper function that calls egg_wrapper1
    %but only takes s as an input (other inputs are fixed)
    %(single input)
    %solver parameters
    dxtol = 10^-5;
    determinator = y0;
    y_approx=10^-15;
    iter=1;
    max_iter = 200;
    min_denom=10^-8;
    
    s_roots=[];
    x_roots=[];
    y_roots=[];

    s_guesses=linspace(0,.9,10)
 
    for i = 1:length(s_guesses)
    s_guess1=s_guesses(i);
    s_guess2=s_guesses(i)+.1;
    x_wrapper = @(s) x_egg_func(s,x0,y0,theta,egg_params);
    y_wrapper = @(s) y_egg_func(s,x0,y0,theta,egg_params);
    g_wrapper = @(s) g_egg_func(s,x0,y0,theta,egg_params);


    s_roots(i) = egg_secant_solver(x_wrapper, y_wrapper,g_wrapper, s_guess1,s_guess2,determinator, iter, max_iter,min_denom);
    x_roots(i) = x_egg_func(s_roots(i),x0,y0,theta,egg_params);
    y_roots(i)=y_egg_func(s_roots(i),x0,y0,theta,egg_params);

    end

    %Vertical boundaries 
    g_wrapper = @(s) vertical_g_egg_func(s,x0,y0,theta,egg_params);

    for i = 1:length(s_guesses)

    s_guess1=s_guesses(i);
    s_guess2=s_guesses(i)+.2;

    s_roots(length(s_roots)+1) = vertical_egg_secant_solver(x_wrapper, y_wrapper,g_wrapper, s_guess1,s_guess2,determinator, iter, max_iter,dxtol);
    x_roots(length(x_roots)+1) = x_egg_func(s_roots(length(x_roots)+1),x0,y0,theta,egg_params);
    y_roots(length(y_roots)+1)=y_egg_func(s_roots(length(y_roots)+1),x0,y0,theta,egg_params);

    end
    
    %you'll need to change this
    %you might even need multiple guesses
    %so that you can catch top/bottom/left/right points of egg
    %with multiple guesses, you will probably need a for loop!
    %[V_extremas] = x_egg_func(s_root,x_out,y0,theta,egg_params);


    %plug s_root back into egg_func to find boundary point
    %[V_extrema,~] = egg_func(...


    %once you have computed a bunch of extrema points

    %You'll probably need additional code to determine if V_extrema
    %corrsponds to the top coord, bottom coord, left coord, or right coord
    %the sort function will be useful here

    %extract the bounding box from the extrema
    x_range = [min(x_roots), max(x_roots)]; %you'll need to change this
    y_range = [min(y_roots),max(y_roots)]; %you'll need to change this
    
end

%you may need to make additional wrapper functions
%(you need one for x coord of G and one for y coord)

%wrapper function that calls egg_func
%and only returns one scalar (instead of V and G)
%(single output)
