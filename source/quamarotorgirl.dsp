//trans rights

declare name "quamarotorgirl";
declare author "amy universe";
declare version "0.04";
declare license "WTFPL";

import("stdfaust.lib");

//amaranth connected to quadrotorgirl
//but frequency a controls the grain frequency, b controls gate 1, and c controls gate 2

N = 16; //number of steps

bi2uni = _ : +(1) : /(2) : _;


//                            t val  x offset  y offset  z offset  abc offset
semis(ta,mx,my,mz,ma,mb,mc) = t(ta) +x(ta)*mx +y(ta)*my +z(ta)*mz +a(ta)*ma,
                              t(ta) +x(ta)*mx +y(ta)*my +z(ta)*mz +b(ta)*mb,
                              t(ta) +x(ta)*mx +y(ta)*my +z(ta)*mz +c(ta)*mc : _,_,_
with {
    t(n) = par(j,N, nentry("h:[0]seq/v:[5]t val/[%2j] t %2j",0,-24,24,0.1)) : ba.selectn(N,n);
    x(n) = par(j,N, nentry("h:[0]seq/v:[6]x mod/[%2j] x %2j",0,-24,24,0.1)) : ba.selectn(N,n);
    y(n) = par(j,N, nentry("h:[0]seq/v:[7]y mod/[%2j] y %2j",0,-24,24,0.1)) : ba.selectn(N,n);
    z(n) = par(j,N, nentry("h:[0]seq/v:[8]z mod/[%2j] z %2j",0,-24,24,0.1)) : ba.selectn(N,n);
    a(n) = par(j,N, nentry("h:[0]seq/v:[9]a trans/[%2j] a %2j",0,-24,24,0.1)) : ba.selectn(N,n);
    b(n) = par(j,N, nentry("h:[0]seq/v:[a]b trans/[%2j] b %2j",0,-24,24,0.1)) : ba.selectn(N,n);
    c(n) = par(j,N, nentry("h:[0]seq/v:[b]c trans/[%2j] c %2j",0,-24,24,0.1)) : ba.selectn(N,n);
};

amaranth = semis(ta,mx,my,mz,ma,mb,mc) : par(i,3, %(maxrange) : +(minrange) : ba.semi2ratio : *(rootf*2^oct)) <:
        _,_,_,par(i,3,qu.quantize(rootf,qu.ionian)),par(i,3,qu.quantize(rootf,qu.eolian)) : f(key) : os.osc*env,_,_
with {
    g1 = os.lf_pulsetrain(nentry("h:[0]seq/v:controls/h:[1]length n speed/[0]bpm",120,0,600000,0.001)*4/60,0.5);
    ta = ba.counter(g1)%nentry("h:[0]seq/v:controls/h:[1]length n speed/[0]active steps",N,1,N,1);
    mx = hslider("h:[0]seq/v:controls/v:[3]mult/[0]x",1,0,64,1);
    my = hslider("h:[0]seq/v:controls/v:[3]mult/[1]y",1,0,64,1);
    mz = hslider("h:[0]seq/v:controls/v:[3]mult/[2]z",1,0,64,1);
    ma = hslider("h:[0]seq/v:controls/v:[4]trans mult/[0]a",1,0,64,1);
    mb = hslider("h:[0]seq/v:controls/v:[4]trans mult/[0]b",1,0,64,1);
    mc = hslider("h:[0]seq/v:controls/v:[4]trans mult/[0]c",1,0,64,1);
    minrange = hslider("h:[0]seq/v:controls/v:[d]range/[0]offset", 0, 0, 128, 0.1);
    maxrange = hslider("h:[0]seq/v:controls/v:[d]range/[1]max", 36, 1, 128, 0.1);
    midc = 220*2^(3/12);
    rootf = midc * 2^(nentry("h:[0]seq/v:controls/h:[0]key/[2]root note", 0,0,11.5,0.1)/12);
    oct = hslider("h:[0]seq/v:controls/v:[d]range/[2]octave", 0,-8,8,1);
    f(n) = par(i,9,_) <: par(i,3,ba.selectn(9,n*3+i)); //output nth 3 signals of the 9 inputs
    key = hslider("h:[0]seq/v:controls/h:[0]key/[1]quantization [style:menu{'none':0;'major':1;'minor':2}]",0,0,2,1);
    env = g1 : en.adsre(a,d,s,r)
    with {
        a = vslider("h:[0]seq/v:controls/h:[2]env/[0]attack [style:knob]",0,0,4,0.0001);
        d = vslider("h:[0]seq/v:controls/h:[2]env/[1]decay [style:knob]",0,0,4,0.0001);
        s = vslider("h:[0]seq/v:controls/h:[2]env/[2]sustain [style:knob]",0,0,1,0.0001);
        r = vslider("h:[0]seq/v:controls/h:[2]env/[3]release [style:knob]",0.01,0,4,0.0001);
    };
};



rain(x,in,f2,f3) = g1 * g2 : en.adsre(a,d,s,r) * in
with {
    rnd = no.noise : ba.sAndH(ba.beat(rate*60)) : fi.lowpass(1,cf)
    with {
        rate = vslider("h:%2x/h:[2]grain noise (rnd)/rate [style:knob]",2e4,1,2e4,1);
        cf = vslider("h:%2x/h:[2]grain noise (rnd)/filter [style:knob]",2e4,1,2e4,1);
    };

    g1 = os.lf_pulsetrain(f2*2^oct + fr,width+wr) : bi2uni
    with {
        oct = vslider("h:%2x/h:[0]g1/[0]frq oct [style:knob]",0,-8,8,1);
        width = vslider("h:%2x/h:[0]g1/[2]pw [style:knob]",0,0,1,0.001);
        fr = vslider("h:%2x/h:[0]g1/[1]frq rnd [style:knob]",0,0,1,0.001) * rnd * 1000; //scale
        wr = vslider("h:%2x/h:[0]g1/[3]pw rnd [style:knob]",0,0,1,0.001) * abs(rnd);
    };

    g2 = os.lf_pulsetrain(f3*2^oct + fr,width+wr) : bi2uni
    with {
        oct = vslider("h:%2x/h:[1]g2/[0]frq oct [style:knob]",0,-8,8,1);
        width = vslider("h:%2x/h:[1]g2/[2]pw [style:knob]",0,0,1,0.001);
        fr = vslider("h:%2x/h:[1]g2/[1]frq rnd [style:knob]",0,0,1,0.001) * rnd * 1000;
        wr = vslider("h:%2x/h:[1]g2/[3]pw rnd [style:knob]",0,0,1,0.001) * abs(rnd);
    };

    a = vslider("h:%2x/h:[3]grain env/[0]attack [style:knob]",0,0,0.01,0.0001);
    d = vslider("h:%2x/h:[3]grain env/[1]decay [style:knob]",0,0,0.01,0.0001);
    s = vslider("h:%2x/h:[3]grain env/[2]sustain [style:knob]",0,0,1,0.0001);
    r = vslider("h:%2x/h:[3]grain env/[3]release [style:knob]",0.01,0,1,0.0001);
};


process = tgroup("quamarotorgirl", vgroup("amaranth",amaranth) <: 
            vgroup("quadrotor",par(i,3,par(i,4,rain(i)/4) ))) :> _ <: _,_;
