function lead = leadplot(inp_raw, inp_asr, scale, color_raw, color_asr, alpha, raw_scale, asr_scale)
    chan_sip_vec = linspace(1,scale,size(inp_raw,1));
%     lines = ones(size(inp_raw,1), size(inp_raw,2));
    
%     plt_lines = lines - chan_sip_vec;
%     plot(plt_lines,'color', 'gray');
%     
%     hold on;
    
    plt_u = inp_asr - mean(inp_asr,2);
%     plt_u = zscore(inp_asr,1,2);
    plt_u = (plt_u.*asr_scale) - chan_sip_vec';
    plot (plt_u','color',color_raw)
    
    hold on;
    
    plot_a = inp_raw - mean(inp_raw,2);
%     plot_a = zscore(inp_raw,1,2);
    plot_a = (plot_a.*raw_scale) - chan_sip_vec';    
    for i=1:size(plot_a,1)
        plot_ = plot_a(i,:);
        r = plot (plot_','color',color_asr);
        r.Color(4)=alpha;
    end
    hold off;
    
    lead = [plt_u, plot_a];
    
    