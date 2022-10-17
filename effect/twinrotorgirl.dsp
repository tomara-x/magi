//trans rights

declare name "twinrotorgirl";
declare author "amy universe";
declare version "0.02";
declare license "WTFPL";

import("stdfaust.lib");

chop =  _ <: (*(wet) : *(gate) : fi.svf.bp(cf,q)), *(1-wet) :> _
with {
    gate = os.lf_pulsetrain(frq,pw)+1 : /(2)
    with {
        frq = vslider("h:[0]time/gate frq [scale:log]",440,0.0001,2e4,0.0001);
        pw = vslider("h:[0]time/gate width",0.5,0,1,0.001);
    };
    cf = ba.counter(os.lf_pulsetrain(frq,0.5)) : *(size) : %(2e4) : +(1)
    with {
        frq = vslider("h:[1]freq/jmp frq [scale:log]",440,0.0001,2e4,0.0001);
        size = vslider("h:[1]freq/jmp size [scale:log]",440,0.0001,2e4,0.0001);
    };
    q = vslider("h:[1]freq/q",0.5,0.01,24,0.001);
    wet = vslider("wet",1,0,1,0.01);
};

process = _ : hgroup("twinrotorgirl", hgroup("c1",chop) ) <: _,_;
