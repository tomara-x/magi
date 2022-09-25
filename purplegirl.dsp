import("stdfaust.lib");

N = 16; //number of steps
trig = ba.beat(hslider("[9]bpm",120,1,960,1)*4);
htrig = sum(i,N,trig : ba.resetCtr(N,i+1) * hgroup("[3]active", nentry("[%2i] %2i",1,0,1,1)));

t = ba.counter(htrig)%hslider("[8]active steps",N,1,N,1);
x = hslider("[0]x mult",1,0,64,1);
y = hslider("[1]y mult",1,0,64,1);
z = hslider("[2]z mult",1,0,64,1);

index(t,x,y,z) = f(t) +g(t)*x +h(t)*y +i(t)*z
with {
    f(n) = hgroup("[4]t val", par(j,N, nentry("[%2j] %2j",0,-14,14,1))) : ba.selectn(N,n);
    g(n) = hgroup("[5]x mod", par(j,N, nentry("[%2j] %2j",1,-14,14,1))) : ba.selectn(N,n);
    h(n) = hgroup("[6]y mod", par(j,N, nentry("[%2j] %2j",1,-14,14,1))) : ba.selectn(N,n);
    i(n) = hgroup("[7]z mod", par(j,N, nentry("[%2j] %2j",1,-14,14,1))) : ba.selectn(N,n);
};

//hot mess
minrange = hslider("[a]offset", 0, 0, 512, 1);
maxrange = hslider("[b]max", 128, 1, 512, 1);
rat = ba.semi2ratio((minrange+index(t,x,y,z))%maxrange);
midc = 261.626;
frq = midc*rat : qu.quantize(midc,qu.eolian);

//knobs!
rel = hgroup("[c]misc", hslider("[0] release [style:knob]",0.1,0,2,0.001)); 
env = en.ar(0,rel,htrig);

cfmult = hgroup("[c]misc",hslider("[1] fc mult [style:knob]",1,0,64,1));
q = hgroup("[c]misc",hslider("[2] Q [style:knob]",1,1,100,1));
gain = hgroup("[c]misc",hslider("[3] gain [style:knob]",0.1,0,2,0.01));
mel = frq/16 : os.square*env : fi.resonlp(midc*cfmult*env+midc,q,gain);

clip = hgroup("[c]misc",hslider("[4] clip [style:knob]",1,0,1,0.01));

process = mel : aa.clip(-clip,clip) <: _,_;
