// this is a very unfaithful replication of one aspeect of msr [https://aria.dog/modules]
// thank you aria <3
import("stdfaust.lib");

N = 16; //number of steps
trig = ba.beat(hslider("[9]bpm",120,1,960,1)*4);
htrig = sum(i,N,trig : ba.resetCtr(N,i+1) * hgroup("[1]active", nentry("[%2i] %2i",1,0,1,1)));

t = ba.counter(htrig)%hslider("[6]active steps",N,1,N,1);
x = hgroup("[0]dimension", hslider("[0]x mult",1,0,64,1));
y = hgroup("[0]dimension", hslider("[1]y mult",1,0,64,1));
z = hgroup("[0]dimension", hslider("[2]z mult",1,0,64,1));

index(t,x,y,z) = f(t) +g(t)*x +h(t)*y +i(t)*z
with {
    f(n) = hgroup("[2]t val", par(j,N, nentry("[%2j] %2j",0,-14,14,1))) : ba.selectn(N,n);
    g(n) = hgroup("[3]x mod", par(j,N, nentry("[%2j] %2j",1,-14,14,1))) : ba.selectn(N,n);
    h(n) = hgroup("[4]y mod", par(j,N, nentry("[%2j] %2j",1,-14,14,1))) : ba.selectn(N,n);
    i(n) = hgroup("[5]z mod", par(j,N, nentry("[%2j] %2j",1,-14,14,1))) : ba.selectn(N,n);
};

//hot mess
minrange = hgroup("[7]range", hslider("[0]offset", 36, 0, 512, 1));
maxrange = hgroup("[7]range", hslider("[1]max", 92, 1, 512, 1));
rat = ba.semi2ratio((minrange+index(t,x,y,z))%maxrange);
midc = 261.626;
frq = midc*rat : qu.quantize(midc,qu.lydian);

//knobs!
rel = hgroup("[c]misc", vslider("[0] release",0.1,0,2,0.001)); 
env = en.ar(0,rel,htrig);

cfmult = hgroup("[c]misc",vslider("[1] fc mult",1,0,64,1));
q = hgroup("[c]misc",vslider("[2] Q",1,1,100,1));
gain = hgroup("[c]misc",vslider("[3] gain",0.1,0,2,0.01));
mel = frq/16 : os.square*env : fi.resonlp(midc*cfmult*env+midc,q,gain);

clip = hgroup("[c]misc",vslider("[4] clip",1,0,1,0.01));

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

    parameters(x) = hgroup("[c]misc",vgroup("Freeverb",x));
    knobGroup(x) = parameters(vgroup("[0]",x));
    damping = knobGroup(hslider("[0] Damp [tooltip: Somehow control the
        density of the reverb.]",0.5, 0, 1, 0.025)*scaledamp*origSR/ma.SR);
    combfeed = knobGroup(hslider("[1] RoomSize [tooltip: The room size
        between 0 and 1 with 1 for the largest room.]", 0.5, 0, 1, 0.025)*scaleroom*
        origSR/ma.SR + offsetroom);
    spatSpread = knobGroup(hslider("[2] Stereo Spread [tooltip: Spatial
        spread between 0 and 1 with 1 for maximum spread.]",0.5,0,1,0.01)*46*ma.SR/origSR
        : int);
    g = parameters(hslider("[1] Wet [tooltip: The amount of reverb applied to the signal
        between 0 and 1 with 1 for the maximum amount of reverb.]", 0.3333, 0, 1, 0.025));
};

process = mel : aa.clip(-clip,clip) <: freeverb_demo;
