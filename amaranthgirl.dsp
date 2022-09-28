import("stdfaust.lib");

N = 16; //number of steps
trig = ba.beat(hgroup("[0]main",hslider("[0]bpm",120,0,960,0.001)*4));

semis(t,x,y,z,a,b,c) = f(t) +g(t)*x +h(t)*y +i(t)*z <: +(at(t)*a), +(bt(t)*b), +(ct(t)*c)
with {
    f(n) = hgroup("[3]t val", par(j,N, nentry("[%2j] %2j",0,-24,24,0.5))) : ba.selectn(N,n);
    g(n) = hgroup("[4]x mod", par(j,N, nentry("[%2j] %2j",0,-24,24,0.5))) : ba.selectn(N,n);
    h(n) = hgroup("[5]y mod", par(j,N, nentry("[%2j] %2j",0,-24,24,0.5))) : ba.selectn(N,n);
    i(n) = hgroup("[6]z mod", par(j,N, nentry("[%2j] %2j",0,-24,24,0.5))) : ba.selectn(N,n);
    at(n) = hgroup("[7]a trans", par(j,N, nentry("[%2j] %2j",0,-24,24,0.5))) : ba.selectn(N,n);
    bt(n) = hgroup("[8]b trans", par(j,N, nentry("[%2j] %2j",0,-24,24,0.5))) : ba.selectn(N,n);
    ct(n) = hgroup("[9]c trans", par(j,N, nentry("[%2j] %2j",0,-24,24,0.5))) : ba.selectn(N,n);
};

frqs = semis(t,x,y,z,a,b,c) : par(i,3, %(maxrange) : +(minrange) : ba.semi2ratio : *(rootf*2^oct)) <:
        _,_,_,par(i,3,qu.quantize(rootf,qu.ionian)),par(i,3,qu.quantize(rootf,qu.eolian)) : f(key)
with {
    t = ba.counter(trig)%hgroup("[0]main", hslider("[3]active steps",N,1,N,1));
    x = hgroup("[1]dimension", hslider("[0]x mult",1,0,64,1));
    y = hgroup("[1]dimension", hslider("[1]y mult",1,0,64,1));
    z = hgroup("[1]dimension", hslider("[2]z mult",1,0,64,1));
    a = hgroup("[2]trans mult", hslider("[0]a",1,0,64,1));
    b = hgroup("[2]trans mult", hslider("[0]b",1,0,64,1));
    c = hgroup("[2]trans mult", hslider("[0]c",1,0,64,1));
    minrange = hgroup("[a]range", hslider("[0]min", 0, 0, 128, 0.5));
    maxrange = hgroup("[a]range", hslider("[1]max", 36, 1, 128, 0.5));
    midc = 261.626;
    rootf = midc * 2^(hgroup("[0]main",hslider("[2]root note", 0,0,11.5,0.5))/12);
    oct = hgroup("[a]range",hslider("[2]octave", 0,-8,8,1));
    f(n) = par(i,9,_) <: par(i,3,ba.selectn(9,n*3+i)); //output nth 3 signals of the 9 inputs
    key = hgroup("[0]main", hslider("[1]key [style:menu{'major':1;'minor':2;'none':0}]",2,0,2,1));
};

process = frqs : par(i,3,os.square*gain(i)) :> filtah(3) : aa.clip(-clp,clp)*pgain : filtah(9) <: verb
with {
    verb = hgroup("[b]out", dm.freeverb_demo);
    filtah(x) = fi.svf.lp(cf,q)
    with {
        cf = hgroup("[b]out",vslider("[%x]filter cf %x",20000,0,21000,0.001));
        q = hgroup("[b]out",vslider("[%x]filter q %x",1,0,100,0.001));
    };
    gain(x) = hgroup("[b]out",vslider("[%x]gain %x",0.1,0,2,0.001));
    clp = hgroup("[b]out",vslider("[7]clip",0.5,0,1,0.001));
    pgain = hgroup("[b]out",vslider("[8]post gain",0.01,0,2,0.001));
};
