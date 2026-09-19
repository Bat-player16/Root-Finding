function x_out = x_egg_func(s,x0,y0,theta,egg_params)
[V, G] = egg_func(s,x0,y0,theta,egg_params);
x_out = V(1);
end