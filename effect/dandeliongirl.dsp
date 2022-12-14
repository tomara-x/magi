//trans rights

declare name "dandeliongirl";
declare author "amy universe";
declare version "0.05";
declare license "WTFPL";

import("stdfaust.lib");

pcharm =  _ <: (*(wet) <: (sum(i,N,_ : ef.transpose(w*((i+1)*sw+(1-sw)),x,s*i))/N)), *(1-wet) :> _
with {
    N = 16;
    w = ba.sec2samp(vslider("[0]window length (s) [style:knob]",0.1,0.001,4,0.001));
    x = ba.sec2samp(vslider("[1]crossfade dur (s) [style:knob]",0.1,0.001,1,0.001));
    s = vslider("[2]shift (semitones) [style:knob]",1,-24,24,0.001);
    sw = checkbox("[-1]space win");
    wet = vslider("wet [style:knob]",1,0,1,0.01);
};

process = _,_ : hgroup("dandeliongirl",vgroup("l",pcharm),vgroup("r",pcharm)) : _,_;
