function egg_finale()
%set the oval hyper-parameters
egg_params = struct();
egg_params.a = 3; egg_params.b = 2; egg_params.c = .15;
%specify the position and orientation of the egg
x0 = 5; y0 = 5; theta = pi/6;
%set up the axis
hold on; axis equal; axis square
axis([0,10,0,10])
%plot the origin of the egg frame
plot(x0,y0,'ro','markerfacecolor','r');
%compute the perimeter of the egg
[V_list, G_list] = egg_func(linspace(0,1,100),x0,y0,theta,egg_params);
%plot the perimeter of the egg
plot(V_list(1,:),V_list(2,:),'k');
%compute a single point along the egg (s=.8)
%as well as the tangent vector at that point
[V_single, G_single] = egg_func(.8,x0,y0,theta,egg_params);
%plot this single point on the egg
plot(V_single(1),V_single(2),'ro','markerfacecolor','r');
%plot this tangent vector on the egg
vector_scaling = .1;
tan_vec_x = [V_single(1),V_single(1)+vector_scaling*G_single(1)];
tan_vec_y = [V_single(2),V_single(2)+vector_scaling*G_single(2)];
plot(tan_vec_x,tan_vec_y,'g')
[x_range,y_range] = compute_bounding_box(x0,y0,theta,egg_params)
x_min=min(x_range);
y_min=min(y_range);
width=abs(x_range(2)-x_range(1));
height=abs(y_range(2)-y_range(1));
rectangle('Position',[x_min,y_min,width,height],'EdgeColor','b','LineWidth',.5)

end