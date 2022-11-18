//trans rights

declare name "twinrotorgirl";
declare author "amy universe";
declare version "0.09";
declare license "WTFPL";

import("stdfaust.lib");

bi2uni = _ : +(1) : /(2) : _;

N = 16; //max overlap

noise(i) = no.multinoise(N*3) : ba.selector(i,N*3);

cnt = vslider("v:[3]other/[1]overlap [style:knob]",N,1,N,1);
trigs = par(i,N, ba.beat(frq(i)*60) * (i<cnt) )
with {
    frq(x) = f + fr * (noise(x) : ba.downSample(nr) : fi.svf.lp(nf,1))
    with {
        f = vslider("v:[0]freq/[0]frq [style:knob]",10,0.1,1000,0.001);
        fr = vslider("v:[0]freq/[1]frq rnd [style:knob]",0,0,100,0.01);
        nr = vslider("v:[0]freq/[2]noise rate [style:knob]",10,0.1,100,0.01);
        nf = vslider("v:[0]freq/[3]noise filter [style:knob]",10,0.1,100,0.01);
    };
};

gates = par(i,N,ba.peakholder(t(i)) : en.asr(ba.samp2sec(t(i))*env, 1, ba.samp2sec(t(i))*env))
with {
    t(x) = ba.sec2samp(l + lr * (noise(x+N) : ba.downSample(nr) : ba.sAndH(trigs : ba.selector(x,N)) :
            fi.svf.lp(nf,1)) : max(0))
    with {
        l = vslider("v:[1]gate/[0]length [style:knob]",0.001,0.001,4,0.001);
        lr = vslider("v:[1]gate/[2]len rnd [style:knob]",0,0,2,0.01);
        nr = vslider("v:[1]gate/[3]noise rate [style:knob]",10,0.1,100,0.01);
        nf = vslider("v:[1]gate/[4]noise filter [style:knob]",10,0.1,100,0.01);
    };
    env = vslider("v:[3]other/[2]env [style:knob]",0.25,0,0.5,0.001);
};

f(x) = trigs : gates : par(i,N,*(x@del(i)) : sp.panner(pan(i)))
with {
    del(x) = ba.sec2samp(d(x) + dr * (noise(x+2*N) : ba.downSample(nr) :
             ba.sAndH(trigs : ba.selector(x,N)) : fi.svf.lp(nf,1) : min(1) : max(0)))
    with {
        d(x) = vslider("v:[2]delay/[0]shift [style:knob]",0.1,0,1,0.001) * x;
        dr = vslider("v:[2]delay/[1]del rnd [style:knob]",0,0,1,0.001);
        //we're sampling at freq of trigs now.. need closer look
        nr = vslider("v:[2]delay/[2]noise rate [style:knob]",10,0.1,100,0.01);
        nf = vslider("v:[2]delay/[3]noise filter [style:knob]",10,0.1,100,0.01);
    };
    pan(x) = s * noise(x) : ba.downSample(s*50+1) : fi.svf.lp(s*50+1,1) : ba.sAndH(trigs : ba.selector(x,N)) : bi2uni
    with {
        s = vslider("v:[3]other/[0]pan [style:knob]",0,0,1,0.001);
    };
};

gain = ba.db2linear(vslider("v:[3]other/[3]gain [style:knob]",-6,-69,3,1));
process = hgroup("twinrotorgirl",(f :> _*gain,_*gain),(f :> _*gain,_*gain) :> _,_);
//grayhole
