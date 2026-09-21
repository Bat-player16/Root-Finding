
%[x0,y0,theta] = egg_trajectory01(10)
egg_params = struct('a',3,'b',2,'c',.15);
[x_range, y_range] = compute_bounding_box(5, 5, 0, egg_params)