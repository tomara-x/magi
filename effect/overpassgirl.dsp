//trans rights

declare name "overpassgirl";
declare author "amy universe";
declare version "0.00";
declare license "WTFPL";

import("stdfaust.lib");

op(amp,frq,fb) = (_+_ : *(ma.PI) : os.oscp(frq)*amp) ~ *(fb);

dc = vslider("dc [style:knob]", 1,0,5000,0.1);
mod = 0 : seq(i,4,op(a(i),f(i),fb(i))) : *(vslider("mod gain [style:knob]", 1,0,10000,0.1))
with {
    a(x) = vslider("h:%x/[0]amp [style:knob]",0.1,0,1,0.001);
    f(x) = vslider("h:%x/[1]frq [style:knob]",220,1,15000,1);
    fb(x) = vslider("h:%x/[2]fb [style:knob]",0,0,1,0.001);
};

q = vslider("q [style:knob]", 1,0,100,0.1);
process = hgroup("",no.noise*0.1 : fi.svf.bp(dc+mod,q) : aa.clip(-1,1)) <: _,_;
