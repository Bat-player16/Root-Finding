function dyds_val = egg_dyds_wrapper(s, x0, y0, theta, egg_params)
    [~, G] = egg_func(s, x0, y0, theta, egg_params);
    dyds_val = G(2);
end