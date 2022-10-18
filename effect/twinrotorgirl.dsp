//trans rights

declare name "twinrotorgirl";
declare author "amy universe";
declare version "0.03";
declare license "WTFPL";

import("stdfaust.lib");

chop(x) =  gate*grntrg : ba.cycle(8) <: par(i,8,en.are(0,r) * x*wet) :> fi.svf.bp(cf,q), x*(1-wet) :> _
with {
    grntrg = ba.beat(vslider("h:[0]t/grains hz[scale:log]",440,0.0001,2e4,0.0001)*60);
    gate = os.lf_pulsetrain(frq,pw)+1 : /(2)
    with {
        frq = vslider("h:[0]t/gate frq [scale:log]",440,0.0001,2e4,0.0001);
        pw = vslider("h:[0]t/gate width",0.5,0,1,0.001);
    };
    r = vslider("h:[0]t/grain release",0.01,0,0.1,0.0001);

    cf = ba.counter(os.lf_pulsetrain(frq,0.5)) : *(size) : %(2e4) : +(1)
    with {
        frq = vslider("h:[1]f/jmp frq [scale:log]",440,0.0001,2e4,0.0001);
        size = vslider("h:[1]f/jmp size [scale:log]",440,0.0001,2e4,0.0001);
    };
    q = vslider("h:[1]f/q",1,0.01,24,0.001);
    wet = vslider("wet",1,0,1,0.01);
};

process = _ : hgroup("twinrotorgirl", hgroup("c1",chop) ) <: _,_;
