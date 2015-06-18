function loop_shaper(G) 
    close all
    ctr_f = figure;

    global LS
    LS = struct;
    LS.plt_f = figure;
    LS.G = G;
    LS.Kc = 1;
    LS.pzero = 0;
    
    LS.Kc_label = uicontrol('Parent', ctr_f,'Style','edit', 'Position',[50, 10, 100, 30],...
                'String','1', 'Callback', @(obj, a) edit_Kc(obj)); 
    
    uicontrol('Parent', ctr_f,'Style','text', 'Position',[450, 140, 150, 30],...
                'String','Kc * md / mi ='); 
    LS.control_est_label = uicontrol('Parent', ctr_f,'Style','text', 'Position',[600, 140, 40, 30],...
                'String',''); 
    uicontrol('Parent', ctr_f,'Style','text', 'Position',[450, 240, 150, 60],...
                'String','number of poles at zero ='); 
    uicontrol('Parent', ctr_f,'Style','edit', 'Position',[600, 260, 40, 30],...
                'String','0', 'Callback', @(obj, a) edit_pzero_cb(obj));         
       
    
    uicontrol('Parent', ctr_f,'Style','text','Position',[10, 10, 40, 30],...
                'String','Kc:');
    slider_Kc = uicontrol('Parent', ctr_f, 'Style', 'slider',  ...
        'Position', [ 180, 10, 450, 30 ], ...
        'value', 4, ...
        'min', 1, 'max', 7);
    set(slider_Kc, 'Callback', @(es, ed) slider_Kc_cb(es, ed))
    LS.slider_Kc = slider_Kc;
    
    LS.Kc_checkbox =  uicontrol('Style','checkbox', ... 
         'Parent', ctr_f, ...
         'String', 'Negative Kc', ... 
         'Value', 0, ...
         'Callback', @(obj, a) checkbox_Kc_cb(obj, a), ...
         'Position', [10, 50, 150, 20] );
     
    uicontrol('Parent', ctr_f,'Style','text', ...
                'Position',[30, 650, 800, 30],...
                'String', 'Controller Design - Loop Shaping');  
       
    LS.loading_label = uicontrol('Parent', ctr_f,'Style','text', ...
                'Position',[10, 550, 200, 30],...
                'String','', 'Callback', @(obj, a) edit_Kc(obj));  
     
    add_lead_net_ctrl(ctr_f, 'Lead1', 510, 'r')
    add_lead_net_ctrl(ctr_f, 'Lead2', 430, 'g')
    add_lead_net_ctrl(ctr_f, 'Lead3', 350, 'c')
    
    add_lag_net_ctrl(ctr_f, 'Lag1', 260, 'r')
    add_lag_net_ctrl(ctr_f, 'Lag2', 180, 'g')
    add_lag_net_ctrl(ctr_f, 'Lag3', 100, 'c')
    
    update()
end

function add_net_ctrl(fig, name, h_begin, color) 
    uicontrol('Parent', fig,'Style','text','Position', ...
                [50, h_begin+30, 50, 20],...
                'String', name);
    uicontrol('Style','checkbox', ... 
         'Parent', fig, ...
         'String', 'Enabled', ... 
         'Value', 0, ...
         'Callback', @(obj, a) enable_net(obj, name), ...
         'Position', [100, h_begin+30, 100, 20] ); 
    uicontrol('Style','text', ... 
         'Parent', fig, ...
         'String', '', ... 
         'BackgroundColor', color, ...
         'Callback', @(obj, a) enable_net(obj, name), ...
         'Position', [10, h_begin+35, 30, 10] );       
            
    uicontrol('Parent', fig,'Style','text','Position',[10, h_begin-5, 50, 30],...
                'String','m:');
    uicontrol('Parent', fig,'Style','edit', 'Position',[60, h_begin, 50, 30],...
                'String','1', 'Callback', @(obj, a) edit_m_cb(obj, name)); 
    
    uicontrol('Parent', fig,'Style','text','Position',[150, h_begin-5, 50, 30],...
                'String','wc:');
    uicontrol('Parent', fig,'Style','edit', 'Position',[200, h_begin, 50, 30],...
                'String','1', 'Callback', @(obj, a) edit_wc_cb(obj, name)); 
            
    uicontrol('Parent', fig,'Style','text','Position',[300, h_begin-5, 50, 30],...
                'String','w*t:');
    uicontrol('Parent', fig,'Style','edit', 'Position',[350, h_begin, 50, 30],...
                'String','1', 'Callback', @(obj, a) edit_wwd_cb(obj, name)); 
end

function add_lead_net_ctrl(fig, name, h_begin, color)
    global LS;
    LS.(name) = LeadNet(1, 1, 1);

    add_net_ctrl(fig, name, h_begin, color)       
end

function add_lag_net_ctrl(fig, name, h_begin, color) 
    global LS;
    LS.(name) = LagNet(1, 1, 1);

    add_net_ctrl(fig, name, h_begin, color)   
end

function enable_net(obj, netname) 
    global LS;
    LS.(netname).enabled = checked(obj);
    update()
end

function edit_m_cb(obj, netname) 
    global LS;
    LS.(netname).m = str2double(get(obj,'String'));
    update();
end

function edit_wwd_cb(obj, netname) 
    global LS;
    LS.(netname).wwd = str2double(get(obj,'String'));
    update();
end

function edit_wc_cb(obj, netname) 
    global LS;
    LS.(netname).wc = str2double(get(obj,'String'));
    update();
end

function edit_pzero_cb(obj)
  global LS;
  LS.pzero = str2double(get(obj,'String'));
  update()
end

function v = checked(obj)
    if (get(obj,'Value') == get(obj,'Max'))
        v = true;
    else
        v = false;
    end
end

function edit_Kc(obj) 
    global LS;
    LS.Kc = str2double(get(obj,'String'));
    update();
end

function slider_Kc_cb(es, ~)
    global LS
    LS.Kc = sign(LS.Kc) * 10^(es.Value-4);
    update()
end

function checkbox_Kc_cb(obj, ~) 
    global LS
    if (get(obj,'Value') == get(obj,'Max'))
        LS.Kc = abs(LS.Kc) * -1;
    else
        LS.Kc = abs(LS.Kc);
    end
    update()
end


function update_ui() 
    global LS
    set(LS.Kc_label,'String', num2str(LS.Kc));
    set(LS.slider_Kc, 'Value',  log10(abs(LS.Kc))+4 );
    set(LS.Kc_checkbox, 'Value', min(1, max(0, 1-sign(LS.Kc))));
    
end

function update()
    update_ui()
    global LS
    set(LS.loading_label , 'String', 'Loading...');
    drawnow

    s = tf('s');
    T = LS.Kc * LS.G / s^LS.pzero;
    figure(LS.plt_f)
    
    hold off
    nichols(T, 'k-')
    grid 
    legend ('show')
    hold on
    
    lead_lags = [];
    
    tmd=0;
    if(LS.Lead1.enabled) 
        Lead1Effect = T*LS.Lead1.make_tf();
        nichols(Lead1Effect, 'r--')
        lead_lags = [lead_lags LS.Lead1.make_tf()];
        tmd = tmd + LS.Lead1.m;
    end
    if(LS.Lead2.enabled) 
        Lead2Effect = T*LS.Lead2.make_tf();
        nichols(Lead2Effect, 'g--')
        lead_lags = [lead_lags LS.Lead2.make_tf()];
        tmd = tmd + LS.Lead2.m;
    end
    if(LS.Lead3.enabled) 
        Lead3Effect = T*LS.Lead3.make_tf();
        nichols(Lead3Effect, 'c--')
        lead_lags = [lead_lags LS.Lead3.make_tf()];
        tmd = tmd + LS.Lead3.m;
    end
    tmd = max(1, tmd);
    
    tmi = 0;
    if(LS.Lag1.enabled) 
        Lag1Effect = T*LS.Lag1.make_tf();
        nichols(Lag1Effect, 'r-.')
        lead_lags = [lead_lags LS.Lag1.make_tf()];
        tmi = tmi + LS.Lag1.m;
    end
    if(LS.Lag2.enabled) 
        Lag2Effect = T*LS.Lag2.make_tf();
        nichols(Lag2Effect, 'g-.')
        lead_lags = [lead_lags LS.Lag2.make_tf()];
        tmi = tmi + LS.Lag2.m;
    end
    if(LS.Lag3.enabled) 
        Lag3Effect = T*LS.Lag3.make_tf();
        nichols(Lag3Effect, 'c-.')
        lead_lags = [lead_lags LS.Lag3.make_tf()];
        tmi = tmi + LS.Lag3.m;
    end
    tmi = max(1, tmi);
    
    control_est = abs(LS.Kc) * tmd / tmi;
    
    set(LS.control_est_label , 'String', num2str(control_est));
    

    
    final_T = T;

    for net = lead_lags
        final_T = final_T * net;
    end
    
    show_final = ~ isempty(lead_lags);
    if(show_final) 
        nichols(final_T, 'b')
    end
    set(LS.loading_label , 'String', '');
end