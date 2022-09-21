import("stdfaust.lib");

trig = ba.beat(132*4); //quarter notes at 132 bpm

x = ba.counter(trig)%16; //16 steps
y = hslider("y",0,0,64,1);
z = hslider("z",0,0,64,1);

index(i,j,k) = f(i) +g(i)*j +h(i)*k
with {
    f(x) = rdtable(waveform{0,0,2,0,5,0,7,3,6,3,1,0,5,3,7,2},x);
    g(x) = rdtable(waveform{1,0,0,0,1,0,0,2,0,7,0,1,0,0,1,0},x);
    h(x) = rdtable(waveform{1,6,5,2,1,9,1,3,0,0,0,0,4,9,0,7},x);
};

rat = ba.semi2ratio(index(x,y,z)%144);
midc = 261.626;
frq = midc*rat;

env = en.adsr(0,0,1,0.2,trig);
mel = frq/16 : os.square*env : fi.resonlp(midc*16*env+midc*2,4,0.1);

process =  mel <: dm.freeverb_demo;
