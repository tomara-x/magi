//trans rights

declare name "nailgirl";
declare author "amy universe";
declare version "1.01";
declare license "WTFPL";

import("stdfaust.lib");

dist = _ <: (*(wet) : seq(i,3,*(g(i)) : f(s(i))) *gf), *(1-wet) :> _
with {
    f(x) = _ <: aa.acosh2,aa.arccos2,aa.arcsin2,aa.arctan2,aa.asinh2,
                aa.clip(-1,1),aa.cosine2,aa.cubic1,aa.hardclip2,aa.hyperbolic2,
                aa.parabolic2,aa.sinarctan2,aa.sine2,aa.tanh1 : ba.selectn(14,x);
    s(x) = vslider("h:%x/%x function [style:knob]",5,0,13,1);
    g(x) = vslider("h:%x/%x amount [style:knob]",1,1,100,0.01);
    gf = vslider("post gain [style:knob]",0.5,0,1,0.01);
    wet = vslider("wet [style:knob]",0,0,1,0.01);
};

process = _,_ : hgroup("nailgirl",dist,dist) : _,_;
