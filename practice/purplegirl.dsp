import("stdfaust.lib");

N = 16; //number of steps
trig = ba.beat(132*4); //quarter notes at 132 bpm
x = ba.counter(trig)%N;
y = hslider("[0]y",1,0,64,1);
z = hslider("[1]z",1,0,64,1);

index(i,j,k) = f(i) +g(i)*j +h(i)*k
with {
    f(x) = hgroup("[3]x val", par(j,N, nentry("[%2j] %2j",0,-12,12,1))) : ba.selectn(N,x);
    g(x) = hgroup("[4]y mod", par(j,N, nentry("[%2j] %2j",1,-12,12,1))) : ba.selectn(N,x);
    h(x) = hgroup("[5]z mod", par(j,N, nentry("[%2j] %2j",1,-12,12,1))) : ba.selectn(N,x);
};

rat = ba.semi2ratio(index(x,y,z)%144);
midc = 261.626;
//metadata menu for modes
frq = midc*rat : qu.quantize(midc,qu.lydian);

env = en.adsr(0,0,1,0.2,trig);
mel = frq/16 : os.square*env : fi.resonlp(midc*8*env+midc*2,4,0.1);

led = 1 : ba.selectoutn(N, x) : hgroup("[2]steps", par(i,N, vbargraph("[%2i]S%2i [style:led]",0,1))) :> _;

process = attach(mel, led) <: _,_;
