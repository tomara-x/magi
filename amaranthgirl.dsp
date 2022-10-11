//trans rights

//dedicated to the girl jamming with this <3
declare name "amaranthgirl";
declare author "amy universe";
declare version "10.01";
declare license "WTFPL";

import("stdfaust.lib");

N = 16; //number of steps

//                                  t val  x offset  y offset  z offset  abc offset
semis(ta,tb,tc,mx,my,mz,ma,mb,mc) = t(ta) +x(ta)*mx +y(ta)*my +z(ta)*mz +a(ta)*ma,
                                    t(tb) +x(tb)*mx +y(tb)*my +z(tb)*mz +b(tb)*mb,
                                    t(tc) +x(tc)*mx +y(tc)*my +z(tc)*mz +c(tc)*mc : _,_,_
with {
    t(n) = par(j,N, nentry("h:[0]seq/v:[5]t val/[%2j] t %2j",0,-24,24,0.1)) : ba.selectn(N,n);
    x(n) = par(j,N, nentry("h:[0]seq/v:[6]x mod/[%2j] x %2j",0,-24,24,0.1)) : ba.selectn(N,n);
    y(n) = par(j,N, nentry("h:[0]seq/v:[7]y mod/[%2j] y %2j",0,-24,24,0.1)) : ba.selectn(N,n);
    z(n) = par(j,N, nentry("h:[0]seq/v:[8]z mod/[%2j] z %2j",0,-24,24,0.1)) : ba.selectn(N,n);
    a(n) = par(j,N, nentry("h:[0]seq/v:[9]a trans/[%2j] a %2j",0,-24,24,0.1)) : ba.selectn(N,n);
    b(n) = par(j,N, nentry("h:[0]seq/v:[a]b trans/[%2j] b %2j",0,-24,24,0.1)) : ba.selectn(N,n);
    c(n) = par(j,N, nentry("h:[0]seq/v:[b]c trans/[%2j] c %2j",0,-24,24,0.1)) : ba.selectn(N,n);
};

frqs = semis(ta,tb,tc,mx,my,mz,ma,mb,mc) : par(i,3, %(maxrange) : +(minrange) : ba.semi2ratio : *(rootf*2^oct)) <:
        _,_,_,par(i,3,qu.quantize(rootf,qu.ionian)),par(i,3,qu.quantize(rootf,qu.eolian)) : f(key) : _,_,_
with {
    trig1 = ba.beat(nentry("h:[0]seq/v:controls/h:[2]seq speed/[0]bpm a",120,0,600000,0.001)*4);
    trig2 = ba.beat(nentry("h:[0]seq/v:controls/h:[2]seq speed/[1]bpm b",120,0,600000,0.001)*4);
    trig3 = ba.beat(nentry("h:[0]seq/v:controls/h:[2]seq speed/[2]bpm c",120,0,600000,0.001)*4);
    ta = ba.counter(trig1)%nentry("h:[0]seq/v:controls/h:[1]length/[0]active steps a",N,1,N,1);
    tb = ba.counter(trig2)%nentry("h:[0]seq/v:controls/h:[1]length/[1]active steps b",N,1,N,1);
    tc = ba.counter(trig3)%nentry("h:[0]seq/v:controls/h:[1]length/[2]active steps c",N,1,N,1);
    mx = hslider("h:[0]seq/v:controls/v:[3]mult/[0]x",1,0,64,1);
    my = hslider("h:[0]seq/v:controls/v:[3]mult/[1]y",1,0,64,1);
    mz = hslider("h:[0]seq/v:controls/v:[3]mult/[2]z",1,0,64,1);
    ma = hslider("h:[0]seq/v:controls/v:[4]trans mult/[0]a",1,0,64,1);
    mb = hslider("h:[0]seq/v:controls/v:[4]trans mult/[0]b",1,0,64,1);
    mc = hslider("h:[0]seq/v:controls/v:[4]trans mult/[0]c",1,0,64,1);
    minrange = hslider("h:[0]seq/v:controls/v:[d]range/[0]min (psych!)", 0, 0, 128, 0.1);
    maxrange = hslider("h:[0]seq/v:controls/v:[d]range/[1]max", 36, 1, 128, 0.1);
    midc = 220*2^(3/12);
    rootf = midc * 2^(nentry("h:[0]seq/v:controls/h:[0]key/[2]root note", 0,0,11.5,0.1)/12);
    oct = hslider("h:[0]seq/v:controls/v:[d]range/[2]octave", 0,-8,8,1);
    f(n) = par(i,9,_) <: par(i,3,ba.selectn(9,n*3+i)); //output nth 3 signals of the 9 inputs
    key = hslider("h:[0]seq/v:controls/h:[0]key/[1]quantization [style:menu{'none':0;'major':1;'minor':2}]",0,0,2,1);
};

process = frqs : os.square*again*en.are(0,arel,atrig),
                 os.square*bgain*en.are(0,brel,btrig),
                 os.square*cgain*en.are(0,crel,ctrig) :>
    fi.svf.lp(cf1,q1) : aa.clip(-clp,clp)*pgain : fi.svf.lp(cf2,q2) <:
    tgroup("[1]sound",hgroup("effects", hgroup("nail",nail,nail) : dm.freeverb_demo))
with {
    arel = vslider("t:[1]sound/h:[0]out/h:[1]env release/[0]a",0.1,0,8,0.00001);
    brel = vslider("t:[1]sound/h:[0]out/h:[1]env release/[1]b",0.1,0,8,0.00001);
    crel = vslider("t:[1]sound/h:[0]out/h:[1]env release/[2]c",0.1,0,8,0.00001);
    aclk = ba.beat(nentry("h:[0]seq/v:controls/h:[3]env clock/bpm a",120,0,600000,0.001)*4);
    bclk = ba.beat(nentry("h:[0]seq/v:controls/h:[3]env clock/bpm b",120,0,600000,0.001)*4);
    cclk = ba.beat(nentry("h:[0]seq/v:controls/h:[3]env clock/bpm c",120,0,600000,0.001)*4);
    //sorry! this way we go N,1,2,...,N-1
    atrig = sum(i,N,aclk : ba.resetCtr(N,(N+i-1)%N+1) * checkbox("h:[0]seq/v:[0]env trig a/[%2i] a %2i"));
    btrig = sum(i,N,bclk : ba.resetCtr(N,(N+i-1)%N+1) * checkbox("h:[0]seq/v:[1]env trig b/[%2i] b %2i"));
    ctrig = sum(i,N,cclk : ba.resetCtr(N,(N+i-1)%N+1) * checkbox("h:[0]seq/v:[2]env trig c/[%2i] c %2i"));
    cf1 = vslider("t:[1]sound/h:[0]out/[2]filter 1 cf",20000,0,21000,0.001);
    cf2 = vslider("t:[1]sound/h:[0]out/[6]filter 2 cf",20000,0,21000,0.001);
    q1 = vslider("t:[1]sound/h:[0]out/[3]filter 1 q",1,0.001,100,0.001);
    q2 = vslider("t:[1]sound/h:[0]out/[7]filter 2 q",1,0.001,100,0.001);
    again = vslider("t:[1]sound/h:[0]out/h:[0]gain/[0]a",0.1,0,2,0.001);
    bgain = vslider("t:[1]sound/h:[0]out/h:[0]gain/[0]b",0.1,0,2,0.001);
    cgain = vslider("t:[1]sound/h:[0]out/h:[0]gain/[0]c",0.1,0,2,0.001);
    clp = vslider("t:[1]sound/h:[0]out/[4]clip",0.5,0,1,0.001);
    pgain = vslider("t:[1]sound/h:[0]out/[5]post gain",0.5,0,2,0.001);
};

nail = _ : *(g0) : aa.tanh1 : *(g1) : aa.sine2 : *(g2) : _
with {
        g0 = vslider("[0]tanh",1,0.01,100,0.01);
        g1 = vslider("[1]sine",1,0.01,100,0.01);
        g2 = vslider("[2]post",0.5,0,1,0.01);
};
