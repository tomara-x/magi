//trans rights

declare name "moodygirl";
declare author "amy universe";
declare version "0.07";
declare license "WTFPL";

import("stdfaust.lib");

N = 128; //number of modes  ;faust compiler throws an "alarm clock" with 1024
M = 16; //modes per group
// you're so evil! do this with nested pars! (can i?)
mood = _ : pm.modalModel(N,par(i,N,frq(i%M,i/M:int)),
                           par(i,N,dur(i%M,i/M:int)),
                           par(i,N,amp(i%M,i/M:int)))/N : _
with {
    frq(x,y) = f*(m*x+(m*x==0))+s*x : min(ma.SR/2) //make em stick at the nyquist
    with {
        f = vslider("v:%2y/v:[0]f/[0]base freq [scale:log] [style:knob]",220,10,2e4,0.1);
        m = vslider("v:%2y/v:[0]f/[1]freq mult [style:knob]",1,0,2,0.001);
        s = vslider("v:%2y/v:[0]f/[1]freq shift [scale:log] [style:knob]",220,1,2e4,0.1);
    };  // f, fm+s, f2m+2s, f3m+3s, ... (for each mode in the group)

    dur(x,y) = d/(dd*x+(x==0))
    with {
        d = vslider("v:%2y/v:[2]d/[0]base dur [style:knob]",1,0,10,0.001);
        dd = vslider("v:%2y/v:[2]d/[1]dur div [style:knob]",1,0.001,2,0.001);
    };  // d, d/dd, d/2dd, d/3dd, ... (same)
    
    amp(x,y) = a/(d*x+(x==0))
    with {
        a = vslider("v:%2y/v:[1]a/[0]base amp [style:knob]",0.1,0,2,0.001);
        d = vslider("v:%2y/v:[1]a/[1]amp div [style:knob]",1,0.01,2,0.001);
    };  // a, a/d, a/2d, a/3d, ... (same)
};

process = _,_ : hgroup("moodygirl",mood,mood) : _,_;
// process = no.noise*0.1 <: hgroup("moodygirl",vgroup("0",mood),vgroup("1",mood)) :> _ <: _,_;
