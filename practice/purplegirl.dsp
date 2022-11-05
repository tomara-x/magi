// this is a very unfaithful replication of one aspeect of msr [https://aria.dog/modules]
// thank you aria <3

import("stdfaust.lib");

N = 16; //number of steps
mode = qu.lydian;

index(t,x,y,z) = f(t) +g(t)*x +h(t)*y +i(t)*z
with {
    f(n) = hgroup("[3]t val", par(j,N, nentry("[%2j] %2j",0,-14,14,1))) : ba.selectn(N,n);
    g(n) = hgroup("[4]x mod", par(j,N, nentry("[%2j] %2j",1,-14,14,1))) : ba.selectn(N,n);
    h(n) = hgroup("[5]y mod", par(j,N, nentry("[%2j] %2j",1,-14,14,1))) : ba.selectn(N,n);
    i(n) = hgroup("[6]z mod", par(j,N, nentry("[%2j] %2j",1,-14,14,1))) : ba.selectn(N,n);
};

trig = ba.beat(hgroup("[0]main",hslider("[0]bpm",120,1,960,1)*4));

rat = ba.semi2ratio((index(t,x,y,z)%maxrange)+minrange)
with {
    t = ba.counter(trig)%hgroup("[0]main",hslider("[2]active steps",N,1,N,1));
    x = hgroup("[1]dimension", hslider("[0]x mult",1,0,64,1));
    y = hgroup("[1]dimension", hslider("[1]y mult",1,0,64,1));
    z = hgroup("[1]dimension", hslider("[2]z mult",1,0,64,1));

    minrange = hgroup("[7]range", hslider("[0]min", 0, 0, 128, 1));
    maxrange = hgroup("[7]range", hslider("[1]max", 36, 1, 128, 1));
};

midc = 261.626;
oct = hgroup("[7]range",hslider("[2]octave", 0,-8,8,1));
root = hgroup("[0]main",hslider("[1]root note", 0,0,11,1));
frq = midc*2^(root/12)*rat : qu.quantize(midc,mode) * 2^oct;

//commiting crimes since 2012
mel = frq : os.square*(env*ose+(1-ose)) <: 
fi.resonlp(cf1*cfmult1*(env*cf1e+(1-cf1e))+cf1, q1*((env+0.01)*q1e+(1-q1e)),gain1),
fi.resonlp(cf2*cfmult2*(env*cf2e+(1-cf2e))+cf1, q2*((env+0.01)*q2e+(1-q2e)),gain2)
:> aa.clip(-clip,clip) * pgain
with {
    etrig = sum(i,N,trig : ba.resetCtr(N,i+1) * hgroup("[2]env",nentry("[%2i] %2i",1,0,1,1)));
    rel = hgroup("[8]misc", vslider("[0] release",0.1,0,2,0.001)); 
    env = en.ar(0,rel,etrig);

    cf1 = hgroup("[8]misc", hgroup("[1]filter1", vslider("[0] cf",261.626,1,261.626,1)));
    cfmult1 = hgroup("[8]misc", hgroup("[1]filter1", vslider("[1] cf mult",1,1,64,1)));
    q1 = hgroup("[8]misc", hgroup("[1]filter1", vslider("[2] Q",1,1,100,1)));
    gain1 = hgroup("[8]misc", hgroup("[1]filter1", vslider("[3] gain",0.1,0,2,0.01)));

    cf2 = hgroup("[8]misc", hgroup("[2]filter2", vslider("[0] cf",261.626,1,261.626,1)));
    cfmult2 = hgroup("[8]misc", hgroup("[2]filter2", vslider("[0] cf mult",1,1,64,1)));
    q2 = hgroup("[8]misc", hgroup("[2]filter2", vslider("[1] Q",1,1,100,1)));
    gain2 = hgroup("[8]misc", hgroup("[2]filter2", vslider("[2] gain",0.1,0,2,0.01)));

    clip = hgroup("[8]misc",vslider("[4] clip",1,0,1,0.001));

    pgain = hgroup("[8]misc",vslider("[5] post gain",1,0,16,0.001)); //make those db

    ose = hgroup("[8]misc",vgroup("[3] env mod", checkbox("[0] osc")));
    cf1e = hgroup("[8]misc",vgroup("[3] env mod", checkbox("[1] cf1")));
    cf2e = hgroup("[8]misc",vgroup("[3] env mod", checkbox("[2] cf2")));
    q1e = hgroup("[8]misc",vgroup("[3] env mod", checkbox("[3] q1")));
    q2e = hgroup("[8]misc",vgroup("[3] env mod", checkbox("[4] q2")));
};

process = mel <: hgroup("[8]misc",dm.freeverb_demo);
