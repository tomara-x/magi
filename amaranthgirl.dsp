//trans rights

declare author "amy universe";
declare license "wtfpl";
import("stdfaust.lib");

N = 16; //number of steps

//sequence triggers
trig1 = ba.beat(hgroup("[0]main",hgroup("[1]speed",nentry("[0]bpm 0",120,0,960,0.001)*4)));
trig2 = ba.beat(hgroup("[0]main",hgroup("[1]speed",nentry("[1]bpm 1",120,0,960,0.001)*4)));
trig3 = ba.beat(hgroup("[0]main",hgroup("[1]speed",nentry("[2]bpm 2",120,0,960,0.001)*4)));


//                            t val  x offset y off    z off     voice offset
semis(t1,t2,t3,x,y,z,a,b,c) = f(t1) +g(t1)*x +h(t1)*y +i(t1)*z +(at(t1)*a),
                              f(t2) +g(t2)*x +h(t2)*y +i(t2)*z +(bt(t2)*b),
                              f(t3) +g(t3)*x +h(t3)*y +i(t3)*z +(ct(t3)*c)
with {
    f(n) = hgroup("[5]t val", par(j,N, nentry("[%2j] t %2j",0,-24,24,0.5))) : ba.selectn(N,n);
    g(n) = hgroup("[6]x mod", par(j,N, nentry("[%2j] x %2j",0,-24,24,0.5))) : ba.selectn(N,n);
    h(n) = hgroup("[7]y mod", par(j,N, nentry("[%2j] y %2j",0,-24,24,0.5))) : ba.selectn(N,n);
    i(n) = hgroup("[8]z mod", par(j,N, nentry("[%2j] z %2j",0,-24,24,0.5))) : ba.selectn(N,n);
    at(n) = hgroup("[9]a trans", par(j,N, nentry("[%2j] a %2j",0,-24,24,0.5))) : ba.selectn(N,n);
    bt(n) = hgroup("[a]b trans", par(j,N, nentry("[%2j] b %2j",0,-24,24,0.5))) : ba.selectn(N,n);
    ct(n) = hgroup("[b]c trans", par(j,N, nentry("[%2j] c %2j",0,-24,24,0.5))) : ba.selectn(N,n);
};


frqs = semis(t1,t2,t3,x,y,z,a,b,c) : par(i,3, %(maxrange) : +(minrange) : ba.semi2ratio : *(rootf*2^oct)) <:
        _,_,_,par(i,3,qu.quantize(rootf,qu.ionian)),par(i,3,qu.quantize(rootf,qu.eolian)) : f(key)
with {
    t1 = ba.counter(trig1)%hgroup("[0]main",hgroup("[2]length", nentry("[0]active steps 1",N,1,N,1)));
    t2 = ba.counter(trig2)%hgroup("[0]main",hgroup("[2]length", nentry("[1]active steps 2",N,1,N,1)));
    t3 = ba.counter(trig3)%hgroup("[0]main",hgroup("[2]length", nentry("[2]active steps 3",N,1,N,1)));
    x = hgroup("[3]mult", hslider("[0]x",1,0,64,1));
    y = hgroup("[3]mult", hslider("[1]y",1,0,64,1));
    z = hgroup("[3]mult", hslider("[2]z",1,0,64,1));
    a = hgroup("[4]trans mult", hslider("[0]a",1,0,64,1));
    b = hgroup("[4]trans mult", hslider("[0]b",1,0,64,1));
    c = hgroup("[4]trans mult", hslider("[0]c",1,0,64,1));
    minrange = hgroup("[d]range", hslider("[0]min", 0, 0, 128, 0.5));
    maxrange = hgroup("[d]range", hslider("[1]max", 36, 1, 128, 0.5));
    midc = 261.626;
    rootf = midc * 2^(hgroup("[0]main",hgroup("[0]key",nentry("[2]root note", 0,0,11.5,0.5)))/12);
    oct = hgroup("[d]range",hslider("[2]octave", 0,-8,8,1));
    f(n) = par(i,9,_) <: par(i,3,ba.selectn(9,n*3+i)); //output nth 3 signals of the 9 inputs
    key = hgroup("[0]main",hgroup("[0]key", hslider("[1]quantization [style:menu{'major':1;'minor':2;'none':0}]",2,0,2,1)));
};


//envelope biz (needs cleaning)
r0 = hgroup("env",hgroup("[1]env release",vslider("[0]r0",0,0,8,0.0001)));
r1 = hgroup("env",hgroup("[1]env release",vslider("[1]r1",0,0,8,0.0001)));
r2 = hgroup("env",hgroup("[1]env release",vslider("[2]r2",0,0,8,0.0001)));
e0 = ba.beat(nentry("env bpm 0",120,0,960,0.001)*4);
e1 = ba.beat(nentry("env bpm 1",120,0,960,0.001)*4);
e2 = ba.beat(nentry("env bpm 2",120,0,960,0.001)*4);
e0trig = hgroup("env",sum(i,N,e0 : ba.resetCtr(N,i+1) * vgroup("active steps 0",checkbox("[%2i] 0 %2i"))));
e1trig = hgroup("env",sum(i,N,e1 : ba.resetCtr(N,i+1) * vgroup("active steps 1",checkbox("[%2i] 1 %2i"))));
e2trig = hgroup("env",sum(i,N,e2 : ba.resetCtr(N,i+1) * vgroup("active steps 2",checkbox("[%2i] 2 %2i"))));
env(x) = en.are(0,r0,e0trig),en.are(0,r1,e1trig),en.are(0,r2,e2trig) : ba.selectn(3,x);



process = hgroup("amaranthgirl",vgroup("seq",frqs) : vgroup("sound",par(i,3,os.square*gain(i)*env(i)) :> filtah(1) :
            aa.clip(-clp,clp)*pgain : filtah(2) <: hgroup("[0]out",dm.freeverb_demo)))
with {
    filtah(x) = fi.svf.lp(cf,q)
    with {
        cf = hgroup("[0]out",vslider("[%x]filter %x cf",20000,0,21000,0.001));
        q = hgroup("[0]out",vslider("[%x]filter %x q",1,0,100,0.001));
    };
    gain(x) = hgroup("[0]out",hgroup("[0]osc",hgroup("[0]gain",vslider("[%x]v %x",0.1,0,2,0.001))));
    clp = hgroup("[0]out",vslider("[1a]clip",0.5,0,1,0.001));
    pgain = hgroup("[0]out",vslider("[1b]post gain",0.01,0,2,0.001));
};
