# AC loopshaper

A simple matlab script that speeds up the process of loop-shaping with the use of a ui

![loopshaper](https://raw.github.com/clynamen/ac_loopshaper/master/media/preview.png)

## Guide:

given a plant transfer function (tf from now on) G

```
G = -50 / (s*(s+10)) 
```

call the script with

```
loop_shaper(G)
```

A window with parameters and a window with the nichols plane will appear.

The first plot (black) is the plot of:

```
% np = number of poles at zero
% Kc = dc-gain of the controller
% G = plant tf
Kc / s^np * G
```

That is, the product of the **steady-state controller** and the **plant** tf.


Every time a parameter is edited, all the plots will be updated.

It is possible to set the dc-gain of the controller (Kc) and the number of poles at zero.
Tick the 'enable' checkbox in order to add a new Lead or Lag network. For every enable 
network, a nichols plot of the following tf will be added:

```
% np = number of poles at zero
% Kc = dc-gain of the controller
% Net = Enabled network
% G = plant tf

Kc / s^np * Net * G
```

Finally, the plot of the final complementary sensitivity transfer tf is added (blue). This tf 
includes all the enabled Lead and Lag networks. 
