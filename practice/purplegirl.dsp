import("stdfaust.lib");

trig = ba.beat(132*4); //quarter notes at 132 bpm

x = ba.counter(trig)%16; //16 steps
y = hslider("[0]y",0,0,64,1);
z = hslider("[1]z",0,0,64,1);

index(i,j,k) = f(i) +g(i)*j +h(i)*k
with {
    //how to sort them!!
    f(x) = hgroup("[2]x val", par(j,16, nentry("[%j] %j",0,0,11,1))) : ba.selectn(16,x);
    g(x) = hgroup("[3]y mod", par(j,16, nentry("[%j] %j",0,0,11,1))) : ba.selectn(16,x);
    h(x) = hgroup("[4]z mod", par(j,16, nentry("[%j] %j",0,0,11,1))) : ba.selectn(16,x);
};

rat = ba.semi2ratio(index(x,y,z)%144);
midc = 261.626;
//metadata menu for modes
frq = midc*rat : qu.quantize(midc,qu.lydian);

env = en.adsr(0,0,1,0.2,trig);
mel = frq/16 : os.square*env : fi.resonlp(midc*16*env+midc*2,4,0.1);

led = 1 : ba.selectoutn(16, x) : hgroup("[-1]steps", par(i,16, vbargraph("[%i]S%i [style:led]",0,1))) :> _;

process = attach(mel, led) <: _,_;
