//trans rights

declare name "trenchgirl";
declare author "amy universe";
declare version "0.01";
declare license "WTFPL";

import("stdfaust.lib");

N = 44100;
w = ba.time%N : *(record);
record = button("record") : int;
process = _ <: rwtable(N,0.001,w,_,((_+1)/2)*slice) <: _,_
with {
    slice = vslider("table slice [style:knob]",N-1,1,N-1,1);
};
