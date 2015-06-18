classdef Net
    
    properties
        m;
        wc;
        wwd;
        enabled;
    end
    
    methods
        function obj = Net(m, wc, wwd) 
            obj.m = m;
            obj.wc = wc;
            obj.wwd = wwd;
            obj.enabled = false;
        end
    end
    
end