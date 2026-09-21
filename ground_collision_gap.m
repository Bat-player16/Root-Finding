% compute distance between the the egg and the ground
function gap = ground_collision_gap (t, traj, y_ground, egg_params)
    [x0,y0,theta] = traj(t);
    [~, y_range] = compute_bounding_box(x0, y0, theta, egg_params);
    gap = y_range(1) - y_ground;

end 
