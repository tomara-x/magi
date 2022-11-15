//trans rights

declare name "rubberbandgirl";
declare author "amy universe";
declare version "0.01";
declare license "WTFPL";

import("stdfaust.lib");

N = 8;

bands = par(i,N,fi.svf.bp(f(i),q(i)))
with {
    f(x) = vslider("h:bands/v:%x/[1]f [style:knob]",x*2500+1,1,2e4,1);
    q(x) = vslider("h:bands/v:%x/[0]q [style:knob]",1,0.1,32,0.01);
};

gate = par(i,N,ef.gate_mono(threshold,att,hld,rel)) //split the gates?
with {
    threshold = vslider("h:gate/threshold [style:knob]",0,-69,1,1);
    att = vslider("h:gate/attack [style:knob]",0,0,0.1,0.0001);
    hld = vslider("h:gate/hold [style:knob]",0,0,0.1,0.0001);
    rel = vslider("h:gate/release [style:knob]",0,0,0.1,0.0001);
};

rubberband = _ <: bands : gate :> _;

process = sp.stereoize(rubberband);
