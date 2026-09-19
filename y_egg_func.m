function y_out = y_egg_func(s,x0,y0,theta,egg_params)
[V, G] = egg_func(s,x0,y0,theta,egg_params);
y_out = V(2);
end