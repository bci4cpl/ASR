function lead = leadplot(inp_raw, inp_asr, t,  scale, color_raw, color_asr, alpha, raw_scale, asr_scale)
    chan_sip_vec = linspace(1,scale,size(inp_raw,1));
    lines = ones(size(inp_raw));
    
    c =  [0.5 0.5 0.5];
    plt_lines = lines - chan_sip_vec';
    plot(t', plt_lines','color', c );
    
    hold on;
    
%     plt_u = inp_asr - mean(inp_asr,2);
    plt_u = (inp_asr.*asr_scale) - chan_sip_vec';
    plot (t', plt_u','color',color_raw)
    
    hold on;
    
%     plot_a = inp_raw - mean(inp_raw,2);
    plot_a = (inp_raw.*raw_scale) - chan_sip_vec';    
    for i=1:size(plot_a,1)
        plot_ = plot_a(i,:);
        r = plot (t', plot_','color',color_asr);
        r.Color(4)=alpha;
    end
    hold off;
    
    lead = [plt_u, plot_a];
    
    