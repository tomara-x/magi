//heartbeat
import("stdfaust.lib");
trig = ba.pulsen(ba.sec2samp(0.01), ba.sec2samp(1));
sig = sy.kick(10, 0.05, 0.05, .3, 10, trig+(trig:@(ba.sec2samp(0.3))));
process = sig <: _,_;
