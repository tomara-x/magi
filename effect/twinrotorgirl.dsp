//trans rights

declare name "twinrotorgirl";
declare author "amy universe";
declare version "0.01";
declare license "WTFPL";

import("stdfaust.lib");

chop =  _ <: (*(wet) : fi.svf.bp(cf,q)*gate), *(1-wet) :> _
with {
    gate = os.lf_pulsetrain(frq,pw)+1 : /(2)
    with {
        frq = vslider("h:gate/gate frq [scale:log]",440,0.0001,2e4,0.0001);
        pw = vslider("h:gate/gate width",0.5,0,1,0.001);
    };
    cf = ba.counter(os.lf_pulsetrain(frq,0.5)) : *(size) : %(2e4) : +(1)
    with {
        frq = vslider("h:spec/jmp frq [scale:log]",440,0.0001,2e4,0.0001);
        size = vslider("h:spec/jmp size [scale:log]",440,0.0001,2e4,0.0001);
    };
    q = vslider("h:spec/q",0.5,0.01,24,0.001);
    wet = vslider("wet",1,0,1,0.01);
};

process = _ : hgroup("twinrotorgirl", hgroup("c1",chop) : hgroup("c2",chop) : hgroup("c3",chop) ) <: _,_;
