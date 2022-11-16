//trans rights

declare name "twinrotorgirl";
declare author "amy universe";
declare version "0.06";
declare license "WTFPL";

import("stdfaust.lib");

bi2uni = _ : +(1) : /(2) : _;

N = 16; //max overlap

noise(i) = no.multinoise(N*3) : ba.selector(i,N*3);

//quiet bug
//knob ranges
trigs = par(i,N, ba.beat(frq(i)*60) * (i<cnt) )
with {
    frq(x) = f + fr * (noise(x) : ba.downSample(nr) : fi.svf.lp(nf,1) : bi2uni)
    with {
        f = vslider("h:freq/[0]frq [style:knob]",10,1,100,0.001);
        fr = vslider("h:freq/[1]frq rnd [style:knob]",0,0,10,0.01);
        nr = vslider("h:freq/[2]noise rate [style:knob]",100,0.1,500,0.01);
        nf = vslider("h:freq/[3]noise filter [style:knob]",100,0.1,500,0.01);
    };
    cnt = vslider("overlap [style:knob]",8,1,N,1);
};

// t(x) = ba.sec2samp((x+1)*abs(tf-ti)/N + lr * (noise(x+2*N) : ba.downSample(nr) : fi.svf.lp(nf,1) : bi2uni))
gates = par(i,N,ba.peakholder(t(i))) //ratio env
with {
    t(x) = ba.sec2samp(l + lr * (noise(x+N) : ba.downSample(nr) : fi.svf.lp(nf,1) : bi2uni))
    with {
        // ti = vslider("h:gate/[0]time i [style:knob]",0.001,0.001,0.1,0.001);
        // tf = vslider("h:gate/[1]time f [style:knob]",0.01,0.001,0.1,0.001);
        l = vslider("h:gate/[0]length [style:knob]",0.001,0.001,1,0.001);
        lr = vslider("h:gate/[2]len rnd [style:knob]",0,0,10,0.01);
        nr = vslider("h:gate/[3]noise rate [style:knob]",100,0.1,500,0.01);
        nf = vslider("h:gate/[4]noise filter [style:knob]",100,0.1,500,0.01);
    };
};

//s&h noise?
f(x) = trigs : gates : par(i,N,*(x@del(i)))
with {
    del(x) = ba.sec2samp(d(x) + dr * (noise(x+2*N) : ba.downSample(nr) : fi.svf.lp(nf,1) : min(1) : max(0)))
    with {
            d(x) = vslider("h:delay/[0]shift [style:knob]",0.1,0,1,0.001) * x;
            dr = vslider("h:delay/[1]del rnd [style:knob]",0,0,1,0.001);
            nr = vslider("h:delay/[2]noise rate [style:knob]",100,0.1,500,0.01);
            nf = vslider("h:delay/[3]noise filter [style:knob]",100,0.1,500,0.01);
    };
};
//stereo scattering

process = sp.stereoize(f :> _);
//attenuation
//grayhole
