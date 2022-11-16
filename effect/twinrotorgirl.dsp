//trans rights

declare name "twinrotorgirl";
declare author "amy universe";
declare version "0.05";
declare license "WTFPL";

import("stdfaust.lib");

bi2uni = _ : +(1) : /(2) : _;

N = 32; //max overlap

noise(i) = no.multinoise(N*2) : ba.selector(i,N*2);

trigs = par(i,N, ba.beat(frq(i)*60) * (i<cnt) ) //cycle instead of par beats?
with {
    frq(x) = f + fr * (noise(x) : ba.downSample(nr) : fi.svf.lp(nf,1) : bi2uni)
    with {
        f = vslider("h:freq/frq [style:knob]",10,0.01,100,0.001);
        fr = vslider("h:freq/frq rnd [style:knob]",0,0,10,0.01);
        nr = vslider("h:freq/noise rate [style:knob]",100,0.1,500,0.01);
        nf = vslider("h:freq/noise filter [style:knob]",100,0.1,500,0.01);
    };
    cnt = vslider("overlap [style:knob]",8,0,N,1);
};

gates = par(i,N,ba.peakholder(t(i)))
with {
    ti = vslider("h:gate/time i [style:knob]",0.001,0.001,0.1,0.001);
    tf = vslider("h:gate/time f [style:knob]",0.01,0.001,0.1,0.001);
    t(x) = ba.sec2samp((x+1)*abs(tf-ti)/N);
};

f(x) = trigs : gates : par(i,N,*(x@del(i))) :> _
with {
    del(x) = ba.sec2samp(d(x) + dr * (noise(x+N) : ba.downSample(nr) : fi.svf.lp(nf,1) : min(0) : max(1)))
    with {
            d(x) = vslider("h:delay/shift [style:knob]",0.1,0,1,0.001) * x;
            dr = vslider("h:delay/del rnd [style:knob]",0,0,1,0.001);
            nr = vslider("h:delay/noise rate [style:knob]",100,0.1,500,0.01);
            nf = vslider("h:delay/noise filter [style:knob]",100,0.1,500,0.01);
    };
};

process = sp.stereoize(f);
