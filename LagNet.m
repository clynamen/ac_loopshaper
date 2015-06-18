classdef LagNet < Net
    methods
        function obj = LagNet(m, wc, wwd)
            obj@Net(m, wc, wwd)
        end
        function fun = make_tf(obj)
            s = tf('s');
            wd = obj.wc / obj.wwd;
            fun = (1+s/(wd*obj.m))/(1+s/wd);
        end
    end
end