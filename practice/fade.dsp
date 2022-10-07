import("stdfaust.lib");

//easy crossfading! cool!
v = hslider("v",0,0,1,0.001) : si.smoo;
process = it.interpolate_linear(v,os.osc(440),os.osc(1000)) *0.1 <: _,_;
