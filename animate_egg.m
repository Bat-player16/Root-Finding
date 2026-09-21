fname = 'flying_egg.avi';
writerObj = VideoWriter(fname);
open(writerObj);

fig1 = figure(1);

y_ground = 0;
x_wall = 50;

ground_time = 3.4777;
wall_time = 5.5805;  %1.2900 (for wall at 20)


egg_params = struct();
egg_params.a = 3;
egg_params.b = 2;
egg_params.c = .15;

t_stop = min(wall_time,ground_time);
t_anim = linspace(0, t_stop, 200);

if ground_time < wall_time
    t_contact = ground_time;
else
    t_contact =  wall_time;
end
[x0,y0,theta] = egg_trajectory01(t_contact);

 [x_range, y_range] = compute_bounding_box(x0, y0, theta, egg_params);

 s_scan = linspace(0,1,50);

 dyds_fun = @(s) egg_dyds_wrapper(s,x0,y0,theta, egg_params);
s_roots = [];
val_prev = dyds_fun(s_scan(1));
for i = 2:length(s_scan)
    val_curr = dyds_fun(s_scan(i));
    if val_prev * val_curr < 0
        s_root = bisect(dyds_fun, s_scan(i-1), s_scan(i), 1e-6, 1e-6, 200);
        s_roots(end+1) = s_root;
    end
    val_prev = val_curr;
end
pts_y = zeros(size(s_roots));
pts_x = zeros(size(s_roots));
for i = 1:length(s_roots)
    [V, ~] = egg_func(s_roots(i), x0, y0, theta, egg_params);
    pts_x(i) = V(1);
    pts_y(i) = V(2);
end
[~, idx_min] = min(pts_y);
contact_x = pts_x(idx_min);
contact_y = pts_y(idx_min);

xlabel ('Time (-)') 
ylabel ('Height (-)')

s = linspace(0,1,50);
hold on;

axis ([-5,55,-5,35])
egg_plot = plot(0,0,'k'); 
plot([-5,50],[y_ground,y_ground], 'g', LineWidth= 2)   % ground line
plot([x_wall,x_wall],[0,50], 'm',LineWidth= 2) 

for i = 1:length(t_anim)
    i_n = t_anim(i);
    [x0,y0,theta] = egg_trajectory01(i_n);
    [V,G] = egg_func(s,x0,y0,theta,egg_params);
    set(egg_plot, 'xdata', V(1,:), 'ydata',V(2,:) ); 
    
    drawnow;

    current_frame = getframe(fig1);      % capture which figure?
    writeVideo(writerObj, current_frame);               % write to which writer, which frame?
    
end
plot(contact_x,contact_y,'ro',MarkerSize=4,MarkerFaceColor="red")


drawnow;

n_freeze = 50;
for k = 1:n_freeze
    drawnow;
    current_frame = getframe(fig1);
    writeVideo(writerObj, current_frame);
end 

close(writerObj)