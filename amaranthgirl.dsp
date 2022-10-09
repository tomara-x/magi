//trans rights

declare author "amy universe";

import("stdfaust.lib");

N = 16; //number of steps


//                            t val  x offset y off    z off     voice offset
semis(t1,t2,t3,x,y,z,a,b,c) = f(t1) +g(t1)*x +h(t1)*y +i(t1)*z +(at(t1)*a),
                              f(t2) +g(t2)*x +h(t2)*y +i(t2)*z +(bt(t2)*b),
                              f(t3) +g(t3)*x +h(t3)*y +i(t3)*z +(ct(t3)*c) : _,_,_
with {
    f(n) = par(j,N, nentry("h:seq/v:[5]t val/[%2j] t %2j",0,-24,24,0.1)) : ba.selectn(N,n);
    g(n) = par(j,N, nentry("h:seq/v:[6]x mod/[%2j] x %2j",0,-24,24,0.1)) : ba.selectn(N,n);
    h(n) = par(j,N, nentry("h:seq/v:[7]y mod/[%2j] y %2j",0,-24,24,0.1)) : ba.selectn(N,n);
    i(n) = par(j,N, nentry("h:seq/v:[8]z mod/[%2j] z %2j",0,-24,24,0.1)) : ba.selectn(N,n);
    at(n) = par(j,N, nentry("h:seq/v:[9]a trans/[%2j] a %2j",0,-24,24,0.1)) : ba.selectn(N,n);
    bt(n) = par(j,N, nentry("h:seq/v:[a]b trans/[%2j] b %2j",0,-24,24,0.1)) : ba.selectn(N,n);
    ct(n) = par(j,N, nentry("h:seq/v:[b]c trans/[%2j] c %2j",0,-24,24,0.1)) : ba.selectn(N,n);
};


frqs = semis(t1,t2,t3,x,y,z,a,b,c) : par(i,3, %(maxrange) : +(minrange) : ba.semi2ratio : *(rootf*2^oct)) <:
        _,_,_,par(i,3,qu.quantize(rootf,qu.ionian)),par(i,3,qu.quantize(rootf,qu.eolian)) : f(key)
with {
    trig1 = ba.beat(nentry("h:seq/v:controls/h:[2]seq speed/[0]bpm a",120,0,600000,0.001)*4);
    trig2 = ba.beat(nentry("h:seq/v:controls/h:[2]seq speed/[1]bpm b",120,0,600000,0.001)*4);
    trig3 = ba.beat(nentry("h:seq/v:controls/h:[2]seq speed/[2]bpm c",120,0,600000,0.001)*4);
    t1 = ba.counter(trig1)%nentry("h:seq/v:controls/h:[1]length/[0]active steps a",N,1,N,1);
    t2 = ba.counter(trig2)%nentry("h:seq/v:controls/h:[1]length/[1]active steps b",N,1,N,1);
    t3 = ba.counter(trig3)%nentry("h:seq/v:controls/h:[1]length/[2]active steps c",N,1,N,1);
    x = hslider("h:seq/v:controls/v:[3]mult/[0]x",1,0,64,1);
    y = hslider("h:seq/v:controls/v:[3]mult/[1]y",1,0,64,1);
    z = hslider("h:seq/v:controls/v:[3]mult/[2]z",1,0,64,1);
    a = hslider("h:seq/v:controls/v:[4]trans mult/[0]a",1,0,64,1);
    b = hslider("h:seq/v:controls/v:[4]trans mult/[0]b",1,0,64,1);
    c = hslider("h:seq/v:controls/v:[4]trans mult/[0]c",1,0,64,1);
    minrange = hslider("h:seq/v:controls/v:[d]range/[0]min (psych!)", 0, 0, 128, 0.1);
    maxrange = hslider("h:seq/v:controls/v:[d]range/[1]max", 36, 1, 128, 0.1);
    midc = 261.626;
    rootf = midc * 2^(nentry("h:seq/v:controls/h:[0]key/[2]root note", 0,0,11.5,0.1)/12);
    oct = hslider("h:seq/v:controls/v:[d]range/[2]octave", 0,-8,8,1);
    f(n) = par(i,9,_) <: par(i,3,ba.selectn(9,n*3+i)); //output nth 3 signals of the 9 inputs
    key = hslider("h:seq/v:controls/h:[0]key/[1]quantization [style:menu{'none':0;'major':1;'minor':2}]",0,0,2,1);
};


process = frqs : par(i,3,os.square*gain(i)*env(i)) :> filtah(1) :
            aa.clip(-clp,clp)*pgain : filtah(2) <: hgroup("[0]out",dm.freeverb_demo)
with {
    r0 = vslider("h:[0]out/h:[1]env release/[0]a",0.1,0,8,0.00001);
    r1 = vslider("h:[0]out/h:[1]env release/[1]b",0.1,0,8,0.00001);
    r2 = vslider("h:[0]out/h:[1]env release/[2]c",0.1,0,8,0.00001);
    e0 = ba.beat(nentry("h:seq/v:controls/h:[3]env clock/bpm 0",120,0,600000,0.001)*4);
    e1 = ba.beat(nentry("h:seq/v:controls/h:[3]env clock/bpm 1",120,0,600000,0.001)*4);
    e2 = ba.beat(nentry("h:seq/v:controls/h:[3]env clock/bpm 2",120,0,600000,0.001)*4);
    //sorry! this way we go N,0,1,2,...,N-1
    e0trig = sum(i,N,e0 : ba.resetCtr(N,(N+i-1)%N+1) * checkbox("h:seq/v:[0]env trig a/[%2i] a %2i"));
    e1trig = sum(i,N,e1 : ba.resetCtr(N,(N+i-1)%N+1) * checkbox("h:seq/v:[1]env trig b/[%2i] b %2i"));
    e2trig = sum(i,N,e2 : ba.resetCtr(N,(N+i-1)%N+1) * checkbox("h:seq/v:[2]env trig c/[%2i] c %2i"));
    env(x) = en.are(0,r0,e0trig),en.are(0,r1,e1trig),en.are(0,r2,e2trig) : ba.selectn(3,x);

    filtah(x) = fi.svf.lp(cf,q)
    with {
        cf = vslider("h:[0]out/[%x]filter %x cf",20000,0,21000,0.001);
        q = vslider("h:[0]out/[%x]filter %x q",1,0.001,100,0.001);
    };
    g1 = vslider("h:[0]out/h:[0]gain/[0]a",0.1,0,2,0.001);
    g2 = vslider("h:[0]out/h:[0]gain/[0]b",0.1,0,2,0.001);
    g3 = vslider("h:[0]out/h:[0]gain/[0]c",0.1,0,2,0.001);
    gain(x) = g1,g2,g3 : ba.selectn(3,x);
    clp = vslider("h:[0]out/[1a]clip",0.5,0,1,0.001);
    pgain = vslider("h:[0]out/[1b]post gain",0.5,0,2,0.001);
};
