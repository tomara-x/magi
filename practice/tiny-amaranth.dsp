//trans rights

declare name "tiny amaranth";
declare author "amy universe";
declare version "0.00";
declare license "WTFPL";

import("stdfaust.lib");

N = 16; //number of steps

semi(ta,mx,my,mz) = t(ta) +x(ta)*mx +y(ta)*my +z(ta)*mz
with {
    t(n) = par(j,N, nentry("h:[0]seq/v:[5]t val/[%2j] t %2j",0,-24,24,0.1)) : ba.selectn(N,n);
    x(n) = par(j,N, nentry("h:[0]seq/v:[6]x mod/[%2j] x %2j",0,-24,24,0.1)) : ba.selectn(N,n);
    y(n) = par(j,N, nentry("h:[0]seq/v:[7]y mod/[%2j] y %2j",0,-24,24,0.1)) : ba.selectn(N,n);
    z(n) = par(j,N, nentry("h:[0]seq/v:[8]z mod/[%2j] z %2j",0,-24,24,0.1)) : ba.selectn(N,n);
};

process = semi(ta,mx,my,mz) : %(maxrange) : +(minrange) : ba.semi2ratio : *(rootf*2^oct) <:
        _,qu.quantize(rootf,qu.ionian),qu.quantize(rootf,qu.eolian) : ba.selectn(3,key) : _
with {
    trig = ba.beat(hslider("h:[0]seq/v:controls/[2]bpm",120,0,600000,0.001)*4);
    ta = ba.counter(trig)%hslider("h:[0]seq/v:controls/[1]active steps",N,1,N,1);
    mx = hslider("h:[0]seq/v:controls/v:[3]mult/[0]x",1,0,64,1);
    my = hslider("h:[0]seq/v:controls/v:[3]mult/[1]y",1,0,64,1);
    mz = hslider("h:[0]seq/v:controls/v:[3]mult/[2]z",1,0,64,1);
    minrange = hslider("h:[0]seq/v:controls/v:[d]range/[0]min (psych!)", 0, 0, 128, 0.1);
    maxrange = hslider("h:[0]seq/v:controls/v:[d]range/[1]max", 36, 1, 128, 0.1);
    midc = 220*2^(3/12);
    rootf = midc * 2^(nentry("h:[0]seq/v:controls/h:[0]key/[2]root note", 0,0,11.5,0.1)/12);
    oct = hslider("h:[0]seq/v:controls/v:[d]range/[2]octave", 0,-8,8,1);
    key = hslider("h:[0]seq/v:controls/h:[0]key/[1]quantization [style:menu{'none':0;'major':1;'minor':2}]",0,0,2,1);
};
