% compute distance between the the egg and the wall
function gap = wall_collision_gap (t, traj, x_wall, egg_params)
    [x0,y0,theta] = traj(t);
    [x_range, ~] = compute_bounding_box(x0, y0, theta, egg_params);
    gap = x_range(2) - x_wall;

end 