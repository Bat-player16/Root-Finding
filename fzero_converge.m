test_func01 = @(x) (x.^3)/100 - (x.^2)/8 + 2*x + 6*sin(x/2+6) -.7 - exp(x/6); % function that we are finding roots for
fun = test_func01; % set function to variable to use when function is called
x0 = 1 + 0.5*rand(1,150);
dxtol = 1e-14;
ftol = 1e-100;
max_iter = 1000;
true_root = 0.717441246283601;


    g_cf = [];
    g1f = [];
    record = input_recorder();
    fzero_record = record.generate_recorder_fun(fun);
    for n = 1:length(x0)
        root_fz = fzero(fzero_record, x0(n));
        input_list = record.get_input_list();
        % error 
        ef = abs(input_list-true_root);
        g_cf = [g_cf, ef(1:end-1)];
        g1f = [g1f, ef(2:end)];
        record.clear_input_list();
    end 


    % strict filter -- only the clean power-law-following points go into the fit
    ecf_fit = [];
    e1f_fit = [];
    for n = 1:length(g_cf)
        if g_cf(n) > 1e-11 && g_cf(n) < 1e-2 && g1f(n) > 1e-11 && g1f(n) < 1e-2
            ecf_fit(end+1) = g_cf(n);
            e1f_fit(end+1) = g1f(n);
        end 
    end 

    [f_p, f_k] = generate_error_fit(ecf_fit, e1f_fit);
    fprintf('fzero p = %.6f, fzero k = %.6f\n', f_p, f_k);

    fit_line_x_fz = 10.^(-6:.01:0);
    fit_line_y_fz = f_k * fit_line_x_fz.^f_p;

    figure;
    % unfiltered data (all raw iterates, pink)
    loglog(g_cf, g1f, 'ro', 'markerfacecolor','r',  'markersize',2)
    hold on
    % filtered data (the subset used for the fit, navy)
    loglog(ecf_fit, e1f_fit, 'go','markerfacecolor','g', 'markersize',3)
    % fit line (black)
    loglog(fit_line_x_fz, fit_line_y_fz, 'k-', 'linewidth', 1)
    xlabel(' \epsilon_{n} (−)')
    ylabel((' \epsilon_{n+1} (−)'))
    title('Fzero Method')
    legend('Unfiltered Data', 'Filtered Data', 'Fit Line', 'Location','best')

















    % ecf_plot = [];
    % e1f_plot = [];
    % for n = 1:length(g_cf)
    %     if g_cf(n) > 1e-15 && g_cf(n) < 1e-2 && g1f(n) > 1e-15 && g1f(n) < 1e-2
    %         ecf_plot(end+1) = g_cf(n);
    %         e1f_plot(end+1) = g1f(n);
    %     end
    % end
    % 
    % 
    % ecf_fit = [];
    % e1f_fit = [];
    % for n = 1:length(g_cf)
    %     if g_cf(n) > 1e-11 && g_cf(n) < 1e-2 && g1f(n) > 1e-11 && g1f(n) < 1e-2
    %         ecf_fit(end+1) = g_cf(n);
    %         e1f_fit(end+1) = g1f(n);
    %     end
    % end
    % 
    % [f_p, f_k] = generate_error_fit(ecf_fit, e1f_fit);   
    % 
    % fit_line_x_fz = 10.^(-7:.01:0);
    % fit_line_y_fz = f_k * fit_line_x_fz.^f_p;
    % 
    % figure;
    % loglog(ecf_plot, e1f_plot, 'bo', 'markerfacecolor','b', 'markersize',3)  
    % hold on
    % loglog(fit_line_x_fz, fit_line_y_fz, 'k-', 'linewidth',2)
    % xlabel(' \epsilon_{n} (−)')
    % ylabel((' \epsilon_{n+1} (−)'))
    % title('fzero Method with Filtered Data')
    % legend('Error', 'Fit Line', 'Location','best')


    % ecf = [];
    % e1f =[];
    % for n  = 1:length(g_cf)
    %     if g_cf(n)>1e-14 && g_cf(n)<1e-2 && g1f(n)>1e-14 && g1f(n)<1e-2
    %         ecf(end+1) = g_cf(n);
    %         e1f(end+1) = g1f(n);
    %     end 
    % 
    % end 
    % 
    % [f_p, f_k] = generate_error_fit(ecf, e1f);
    % 
 
   

