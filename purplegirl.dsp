// this is a very unfaithful replication of one aspeect of msr [https://aria.dog/modules]
// thank you aria <3

//what about multiphonics...
index(t,x,y,z) = f(t) +g(t)*x +h(t)*y +i(t)*z
with {
    f(n) = hgroup("[3]t val", par(j,N, nentry("[%2j] %2j",0,-14,14,1))) : ba.selectn(N,n);
    g(n) = hgroup("[4]x mod", par(j,N, nentry("[%2j] %2j",1,-14,14,1))) : ba.selectn(N,n);
    h(n) = hgroup("[5]y mod", par(j,N, nentry("[%2j] %2j",1,-14,14,1))) : ba.selectn(N,n);
    i(n) = hgroup("[6]z mod", par(j,N, nentry("[%2j] %2j",1,-14,14,1))) : ba.selectn(N,n);
};

import("stdfaust.lib");

N = 16; //number of steps
trig = ba.beat(hgroup("[0]main",hslider("[0]bpm",120,1,960,1)*4));
htrig = sum(i,N,trig : ba.resetCtr(N,i+1) * hgroup("[2]active", nentry("[%2i] %2i",1,0,1,1)));
t = ba.counter(htrig)%hgroup("[0]main",hslider("[2]active steps",N,1,N,1));
x = hgroup("[1]dimension", hslider("[0]x mult",1,0,64,1));
y = hgroup("[1]dimension", hslider("[1]y mult",1,0,64,1));
z = hgroup("[1]dimension", hslider("[2]z mult",1,0,64,1));

minrange = hgroup("[7]range", hslider("[0]min (lol)", 0, 0, 128, 1));
maxrange = hgroup("[7]range", hslider("[1]max", 36, 1, 128, 1));
rat = ba.semi2ratio((index(t,x,y,z)%maxrange)+minrange);
midc = 261.626;
oct = hgroup("[7]range", hslider("[2]octave", 0,-8,8,1));
root = hgroup("[0]main", hslider("[1]root note", 0,0,11,1));
frq = midc*2^(root/12)*rat : qu.quantize(midc,qu.lydian) * 2^oct; //i'm coming for you next!

mel = frq : os.square*env <: fi.resonlp(cf1*cfmult1*env+cf1,q1,gain1),
                             fi.resonlp(cf2*cfmult2*env+cf2,q2,gain2) :> aa.clip(-clip,clip)
with {
    rel = hgroup("[8]misc", vslider("[0] release",0.1,0,2,0.001)); 
    env = en.ar(0,rel,htrig);

    cf1 = hgroup("[8]misc", hgroup("[1]filter1", vslider("[0] cf",261.626,1,261.626,1)));
    cfmult1 = hgroup("[8]misc", hgroup("[1]filter1", vslider("[1] cf mult",1,0,64,1)));
    q1 = hgroup("[8]misc", hgroup("[1]filter1", vslider("[2] Q",1,1,100,1)));
    gain1 = hgroup("[8]misc", hgroup("[1]filter1", vslider("[3] gain",0.1,0,2,0.01)));

    cf2 = hgroup("[8]misc", hgroup("[2]filter2", vslider("[0] cf",261.626,1,261.626,1)));
    cfmult2 = hgroup("[8]misc", hgroup("[2]filter2", vslider("[0] cf mult",1,0,64,1)));
    q2 = hgroup("[8]misc", hgroup("[2]filter2", vslider("[1] Q",1,1,100,1)));
    gain2 = hgroup("[8]misc", hgroup("[2]filter2", vslider("[2] gain",0.1,0,2,0.01)));

    clip = hgroup("[8]misc",vslider("[3] clip",1,0,1,0.01));
};

//copied from demo.lib (just to fuck with the ui a bit)
freeverb_demo = _,_ <: (*(g)*fixedgain,*(g)*fixedgain :
    re.stereo_freeverb(combfeed, allpassfeed, damping, spatSpread)),
    *(1-g), *(1-g) :> _,_
with{
    scaleroom   = 0.28;
    offsetroom  = 0.7;
    allpassfeed = 0.5;
    scaledamp   = 0.4;
    fixedgain   = 0.1;
    origSR = 44100;

    parameters(x) = hgroup("[8]misc",hgroup("Freeverb",x));
    knobGroup(x) = parameters(vgroup("[0]room",x));
    damping = knobGroup(hslider("[0] Damp [style:knob] [tooltip: Somehow control the
        density of the reverb.]",0.5, 0, 1, 0.025)*scaledamp*origSR/ma.SR);
    combfeed = knobGroup(hslider("[1] RoomSize [style:knob] [tooltip: The room size
        between 0 and 1 with 1 for the largest room.]", 0.5, 0, 1, 0.025)*scaleroom*
        origSR/ma.SR + offsetroom);
    spatSpread = knobGroup(hslider("[2] Stereo Spread [style:knob] [tooltip: Spatial
        spread between 0 and 1 with 1 for maximum spread.]",0.5,0,1,0.01)*46*ma.SR/origSR
        : int);
    g = parameters(vslider("[1] Wet [tooltip: The amount of reverb applied to the signal
        between 0 and 1 with 1 for the maximum amount of reverb.]", 0.3333, 0, 1, 0.025));
};

process = mel <: freeverb_demo;
