t = linspace(0,20,40);

y_ground = 0;
x_wall = 20;



egg_params = struct();
egg_params.a = 3;
egg_params.b = 2;
egg_params.c = .15;


dxtol = 1e-4; % interval tolerance 
ftol = 1e-6; % root tolerance 
max_iter = 1000; % max number of iterations

gap_g_prev = ground_collision_gap(t(1),@egg_trajectory01,y_ground,egg_params);
gap_w_prev = wall_collision_gap(t(1), @egg_trajectory01,x_wall, egg_params);

disp("Starting ground search")
for i = 2:length(t)
    t_c = t(i);
    gap_g = ground_collision_gap(t_c,@egg_trajectory01,y_ground,egg_params);
    if gap_g * gap_g_prev < 0
        hit_g = [t(i-1),t(i)];
        break 

    end
     gap_g_prev = gap_g;
end 

disp("Ground search finished")
disp(hit_g)

disp("Starting wall search")

for i = 2:length(t)
    t_c = t(i);
    gap_w = wall_collision_gap(t_c,@egg_trajectory01,x_wall, egg_params);
    if gap_w*gap_w_prev < 0
    hit_w = [t(i-1),t(i)];
    break 

    end 
    gap_w_prev = gap_w;
end 

disp("Wall search finished")
disp(hit_w)


ground_fun = @(t) ground_collision_gap(t, @egg_trajectory01,y_ground,egg_params);
wall_fun = @(t) wall_collision_gap(t, @egg_trajectory01, x_wall, egg_params);

disp("Starting ground bisection")
hit_g_time = bisect(ground_fun,hit_g(1),hit_g(2),dxtol,ftol,max_iter);

disp("Ground bisection finished")
disp(hit_g_time)
disp("Starting wall bisection")
hit_w_time = bisect(wall_fun,hit_w(1),hit_w(2),dxtol,ftol,max_iter);
disp("Wall bisection finished")
disp(hit_w_time)



% for i = 2:length(t)
%     t_n = t(i);
%     gap_g = ground_collision_gap(t_n,egg_trajectory01,y_ground,egg_params);
%     gap_w = wall_collision_gap(t_n,egg_trajectory01,x_wall, egg_params);
%     if gap_g * gap_g_prev < 0
%         hit_g = [t(i-1),t(i)];
%         break 
%     end 
%     if gap_w*gap_w_prev < 0
%     hit_w = [t(i-1),t(i)];
%     break 
%     end 
% 
%        gap_g_prev = gap_g;
%        gap_w_prev = gap_w;
% 
% 
% end