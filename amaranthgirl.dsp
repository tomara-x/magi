import("stdfaust.lib");

N = 32; //number of steps
trig1 = ba.beat(hgroup("[1]speed",hslider("[0]bpm 0",120,0,960,0.001)*4));
trig2 = ba.beat(hgroup("[1]speed",hslider("[1]bpm 1",120,0,960,0.001)*4));
trig3 = ba.beat(hgroup("[1]speed",hslider("[2]bpm 2",120,0,960,0.001)*4));

//sorry! i'll clean it later, i promise!
semis(t1,t2,t3,x,y,z,a,b,c) = f(t1)+g(t1)*x+h(t1)*y+i(t1)*z, f(t2)+g(t2)*x+h(t2)*y+i(t2)*z, f(t3)+g(t3)*x+h(t3)*y+i(t3)*z :
        +(at(t1)*a), +(bt(t2)*b), +(ct(t3)*c)
with {
    f(n) = hgroup("[5]t val", par(j,N, nentry("[%2j] %2j",0,-24,24,0.5))) : ba.selectn(N,n);
    g(n) = hgroup("[6]x mod", par(j,N, nentry("[%2j] %2j",0,-24,24,0.5))) : ba.selectn(N,n);
    h(n) = hgroup("[7]y mod", par(j,N, nentry("[%2j] %2j",0,-24,24,0.5))) : ba.selectn(N,n);
    i(n) = hgroup("[8]z mod", par(j,N, nentry("[%2j] %2j",0,-24,24,0.5))) : ba.selectn(N,n);
    at(n) = hgroup("[9]a trans", par(j,N, nentry("[%2j] %2j",0,-24,24,0.5))) : ba.selectn(N,n);
    bt(n) = hgroup("[a]b trans", par(j,N, nentry("[%2j] %2j",0,-24,24,0.5))) : ba.selectn(N,n);
    ct(n) = hgroup("[b]c trans", par(j,N, nentry("[%2j] %2j",0,-24,24,0.5))) : ba.selectn(N,n);
};

frqs = semis(t1,t2,t3,x,y,z,a,b,c) : par(i,3, %(maxrange) : +(minrange) : ba.semi2ratio : *(rootf*2^oct)) <:
        _,_,_,par(i,3,qu.quantize(rootf,qu.ionian)),par(i,3,qu.quantize(rootf,qu.eolian)) : f(key)
with {
    t1 = ba.counter(trig1)%hgroup("[2]length", hslider("[0]active steps 1",N,1,N,1));
    t2 = ba.counter(trig2)%hgroup("[2]length", hslider("[1]active steps 2",N,1,N,1));
    t3 = ba.counter(trig3)%hgroup("[2]length", hslider("[2]active steps 3",N,1,N,1));
    x = hgroup("[3]mult", hslider("[0]x",1,0,64,1));
    y = hgroup("[3]mult", hslider("[1]y",1,0,64,1));
    z = hgroup("[3]mult", hslider("[2]z",1,0,64,1));
    a = hgroup("[4]trans mult", hslider("[0]a",1,0,64,1));
    b = hgroup("[4]trans mult", hslider("[0]b",1,0,64,1));
    c = hgroup("[4]trans mult", hslider("[0]c",1,0,64,1));
    minrange = hgroup("[d]range", hslider("[0]min", 0, 0, 128, 0.5));
    maxrange = hgroup("[d]range", hslider("[1]max", 36, 1, 128, 0.5));
    midc = 261.626;
    rootf = midc * 2^(hgroup("[0]key",hslider("[2]root note", 0,0,11.5,0.5))/12);
    oct = hgroup("[d]range",hslider("[2]octave", 0,-8,8,1));
    f(n) = par(i,9,_) <: par(i,3,ba.selectn(9,n*3+i)); //output nth 3 signals of the 9 inputs
    key = hgroup("[0]key", hslider("[1]quantization [style:menu{'major':1;'minor':2;'none':0}]",2,0,2,1));
};

r1 = vgroup("[0]osc",vgroup("[1]env release",hslider("[0]0",0,0,2,0.0001)));
r2 = vgroup("[0]osc",vgroup("[1]env release",hslider("[1]1",0,0,2,0.0001)));
r3 = vgroup("[0]osc",vgroup("[1]env release",hslider("[2]2",0,0,2,0.0001)));
env(x) = 1,en.ar(0,r1,trig1),en.ar(0,r2,trig2),en.ar(0,r3,trig3) : select
with {
    select = ba.selectn(4,vgroup("[0]osc",vgroup("[0]gain",vslider("v %x env [style:radio{'no':0;'0':1;'1':2;'2':3}]",0,0,3,1))));
};

process = hgroup("0", vgroup("1",frqs) : vgroup("2",par(i,3,os.square*gain(i)*env(i)) :> filtah(1) :
            aa.clip(-clp,clp)*pgain : filtah(2) <: hgroup("[0]out",dm.freeverb_demo)))
with {
    filtah(x) = fi.svf.lp(cf,q)
    with {
        cf = hgroup("[0]out",vslider("[%x]filter %x cf",20000,0,21000,0.001));
        q = hgroup("[0]out",vslider("[%x]filter %x q",1,0,100,0.001));
    };
    gain(x) = vgroup("[0]osc",vgroup("[0]gain",hslider("[%x]v %x",0.1,0,2,0.001)));
    clp = hgroup("[0]out",vslider("[1a]clip",0.5,0,1,0.001));
    pgain = hgroup("[0]out",vslider("[1b]post gain",0.01,0,2,0.001));
};
