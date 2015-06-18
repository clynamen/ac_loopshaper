classdef LeadNet < Net
    methods
        function obj = LeadNet(m, wc, wwd)
            obj@Net(m, wc, wwd)
        end
        function fun = make_tf(obj)
            s = tf('s');
            wd = obj.wc / obj.wwd;
            fun = (1+s/wd)/(1+s/(wd*obj.m));
        end
    end
end