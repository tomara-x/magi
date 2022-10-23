//trans rights

declare name "moodygirl";
declare author "amy universe";
declare version "0.02";
declare license "WTFPL";

import("stdfaust.lib");

N = 64; //number of modes
M = 16; //modes per group
mood = _ : pm.modalModel(N,par(i,N,frq(i%M,i/M:int)),
                           par(i,N,dur(i%M,i/M:int)),
                           par(i,N,amp(i%M,i/M:int)))/N : _
with {
    frq(x,y) = f*(m*x+(m*x==0))
    with {
        f = vslider("h:%2y/h:[0]f/[0]base freq [scale:log] [style:knob]",220,10,2e4,0.1);
        m = vslider("h:%2y/h:[0]f/[1]freq mult [style:knob]",1,0,2,0.001);
    };  // f,fm,f2m,f3m,...

    dur(x,y) = d/(dd*(x+1)+(x==1))
    with {
        d = vslider("h:%2y/h:[2]d/[0]base dur [style:knob]",1,0,10,0.001);
        dd = vslider("h:%2y/h:[2]d/[1]dur div [style:knob]",0.1,0.001,2,0.001);
    };  // i'm lazy
    
    amp(x,y) = a/(d*(x+1)+(x==0))
    with {
        a = vslider("h:%2y/h:[1]a/[0]base amp [style:knob]",0.1,0,1,0.001);
        d = vslider("h:%2y/h:[1]a/[1]amp div [style:knob]",0.1,0.001,2,0.001);
    };  // dirty. wanna get 1 on x0, .5 on x1, now it gives .5 on both
};

process = no.noise*0.1 : vgroup("moodygirl",mood) <: _,_;
// process = _ : vgroup("moodygirl",mood) <: _,_;
