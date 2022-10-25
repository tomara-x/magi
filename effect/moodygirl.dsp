//trans rights

declare name "moodygirl";
declare author "amy universe";
declare version "0.05";
declare license "WTFPL";

import("stdfaust.lib");

N = 400; //number of modes
M = 100; //modes per group
// you're so evil! do this with nested pars! (can i?)
mood = _ : pm.modalModel(N,par(i,N,frq(i%M,i/M:int)),
                           par(i,N,dur(i%M,i/M:int)),
                           par(i,N,amp(i%M,i/M:int)))/N : _
with {
    frq(x,y) = f*(m*x+(m*x==0))+s*x : min(ma.SR/2) //make em stick at the nyquist
    with {
        f = vslider("h:%2y/h:[0]f/[0]base freq [scale:log] [style:knob]",220,10,2e4,0.1);
        m = vslider("h:%2y/h:[0]f/[1]freq mult [style:knob]",1,0,2,0.001);
        s = vslider("h:%2y/h:[0]f/[1]freq shift [scale:log] [style:knob]",220,1,2e4,0.1);
    };  // f, fm+s, f2m+2s, f3m+3s, ... (for each mode in the group)

    dur(x,y) = d/(dd*x+(x==0))
    with {
        d = vslider("h:%2y/h:[2]d/[0]base dur [style:knob]",1,0,10,0.001);
        dd = vslider("h:%2y/h:[2]d/[1]dur div [style:knob]",1,0.001,2,0.001);
    };  // d, d/dd, d/2dd, d/3dd, ... (same)
    
    amp(x,y) = a/(d*x+(x==0))
    with {
        a = vslider("h:%2y/h:[1]a/[0]base amp [style:knob]",0.1,0,1,0.001);
        d = vslider("h:%2y/h:[1]a/[1]amp div [style:knob]",1,0.01,2,0.001);
    };  // a, a/d, a/2d, a/3d, ... (same)
};

process = no.noise*0.1 <: hgroup("moodygirl",vgroup("0",mood),vgroup("1",mood)) :> _ <: _,_;
// process = _ : vgroup("moodygirl",mood) <: _,_;
