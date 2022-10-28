//trans rights

declare name "moodygirl";
declare author "amy universe";
declare version "0.14";
declare license "WTFPL";

import("stdfaust.lib");

N = 32; //modes per group //faust compiler: "alarm clock" with 128
mood(g) = _ : pm.modalModel(N,par(i,N,frq(i,g)),
                              par(i,N,dur(i,g)),
                              par(i,N,amp(i,g) * (i < m(g))))/N : _
with {
    m(y) = vslider("v:%2y/[-1]modes [style:knob] [tooltip:number of active modes in group]",N,0,N,1);

    frq(x,y) = f*(m*x+(m*x==0))+s*x : min(ma.SR/2) //make em stick at the nyquist
    with {
        f = vslider("v:%2y/[0]base freq [style:knob] [tooltip:frequency of first mode in group]",220,1,1.5e4,0.1);
        m = vslider("v:%2y/[1]freq mult [style:knob] [tooltip:multiplier for each mode's freq]",1,0,2,0.001);
        s = vslider("v:%2y/[2]freq shift [style:knob] [tooltip:spacing between modes in hz (added to mult)]",0,0,5e3,0.1);
    };  // f, fm+s, f2m+2s, f3m+3s, ... (for each mode in the group)

    dur(x,y) = d * ((dd!=2) * (1/(dd*x+(x==0))) + (1-(dd!=2)))
    with {
        d = vslider("v:%2y/[3]base dur [style:knob] [tooltip:duration of resonance for modes (seconds)]",1,0,10,0.001);
        dd = vslider("v:%2y/[5]dur div [style:knob] [tooltip:divider for each mode's duration (2 to disable)]",1,0.001,2,0.001);
    };  // d, d/dd, d/2dd, d/3dd, ... (same) (all modes durations = d if dd == 2)
    
    amp(x,y) = a * ((d!=2) * (1/(d*x+(x==0))) + (1-(d!=2)))
    with {
        a = vslider("v:%2y/[6]base amp [style:knob] [tooltip:amplitude of modes]",0.1,0,4,0.001);
        d = vslider("v:%2y/[7]amp div [style:knob] [tooltip:divider for each mode's amp (2 to disable)]",1,0.01,2,0.001);
    };  // a, a/d, a/2d, a/3d, ... (same) (all modes amps = a if d == 2)
};

process = hgroup("moodygirl 0.14", par(j,2, _ <: par(i,8,mood(i)) :> _/8 : _));
