function g_out = vertical_g_egg_func(s,x0,y0,theta,egg_params)
[V, G] = egg_func(s,x0,y0,theta,egg_params);
g_out = G(2);
end