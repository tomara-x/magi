//trans rights

declare name "twinrotorgirl";
declare author "amy universe";
declare version "0.07";
declare license "WTFPL";

import("stdfaust.lib");

bi2uni = _ : +(1) : /(2) : _;

N = 16; //max overlap

noise(i) = no.multinoise(N*3) : ba.selector(i,N*3);

//quiet bug
//knob ranges
cnt = vslider("v:[3]other/overlap [style:knob]",8,1,N,1);
trigs = par(i,N, ba.beat(frq(i)*60) * (i<cnt) )
with {
    frq(x) = f + fr * (noise(x) : ba.downSample(nr) : fi.svf.lp(nf,1) : bi2uni)
    with {
        f = vslider("v:[0]freq/[0]frq [style:knob]",10,0.1,100,0.001);
        fr = vslider("v:[0]freq/[1]frq rnd [style:knob]",0,0,100,0.01);
        nr = vslider("v:[0]freq/[2]noise rate [style:knob]",100,0.1,500,0.01);
        nf = vslider("v:[0]freq/[3]noise filter [style:knob]",100,0.1,500,0.01);
    };
};

// t(x) = ba.sec2samp((x+1)*abs(tf-ti)/N + lr * (noise(x+2*N) : ba.downSample(nr) : fi.svf.lp(nf,1) : bi2uni))
gates = par(i,N,ba.peakholder(t(i))) //ratio env
with {
    t(x) = ba.sec2samp(l + lr * (noise(x+N) : ba.downSample(nr) : fi.svf.lp(nf,1)))
    with {
        // ti = vslider("h:gate/[0]time i [style:knob]",0.001,0.001,0.1,0.001);
        // tf = vslider("h:gate/[1]time f [style:knob]",0.01,0.001,0.1,0.001);
        l = vslider("v:[1]gate/[0]length [style:knob]",0.001,0.001,0.1,0.001);
        lr = vslider("v:[1]gate/[2]len rnd [style:knob]",0,0,10,0.01);
        nr = vslider("v:[1]gate/[3]noise rate [style:knob]",100,0.1,500,0.01);
        nf = vslider("v:[1]gate/[4]noise filter [style:knob]",100,0.1,500,0.01);
    };
};

f(x) = trigs : gates : par(i,N,*(x@del(i)))
with {
    del(x) = ba.sec2samp(d(x) + dr * (noise(x+2*N) : ba.downSample(nr) : fi.svf.lp(nf,1) :
             ba.sAndH(trigs : ba.selector(x,N)) : min(1) : max(0)))
    with {
        d(x) = vslider("v:[2]delay/[0]shift [style:knob]",0.1,0,1,0.001) * x;
        dr = vslider("v:[2]delay/[1]del rnd [style:knob]",0,0,1,0.001);
        //we're sampling at freq of trigs now.. need closer look
        nr = vslider("v:[2]delay/[2]noise rate [style:knob]",100,0.1,500,0.01);
        nf = vslider("v:[2]delay/[3]noise filter [style:knob]",100,0.1,500,0.01);
    };
};
//stereo scattering

gain = ba.db2linear(vslider("v:[3]other/gain [style:knob]",-6,-69,3,1));
process = hgroup("twinrotorgirl",sp.stereoize(f :> _ *gain));
//grayhole
