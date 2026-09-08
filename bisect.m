function [root, iter, g_list] = bisect(f, l, r, dxtol, ftol, max_iter)
if f(l) * f(r) > 0 
    error('same sign guess'); 
end 

iter = 0;
g_list = [];
m = (l + r) / 2;
while iter <= max_iter && (r-l) > dxtol && abs(f(m)) > ftol
    m = (l + r) / 2;
    g_list(end+1) = m;
    if f(l) * f(m) < 0 
        r = m;
    else 
        l = m; 
    end 
    iter = iter + 1;
end 
root = (l+r)/2; 
end
