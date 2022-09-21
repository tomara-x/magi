import("stdfaust.lib");

scaleRep(scal,octs) = par(i,octs,par(j,outputs(scal),ba.take(j+1,scal)*(i+1)));
scale = scaleRep(qu.lydian,4); //4 octaves of the scale
N = outputs(scale); //number of notes in selected range

trig1 = ba.beat(110*4); //quarter notes at 110 bpm
trig2 = trig1 : ba.resetCtr(16,1); //pulse every 16th trig1
trig3 = trig2 : ba.resetCtr(8,1); //pulse every 8th trig2

x = ba.counter(trig1)%16; //16 steps
y = ba.counter(trig2)%N;
z = ba.counter(trig3)%32;

index(i,j,k) = f(i) +g(i)*j +h(i)*k
with {
    f(x) = rdtable(waveform{0,0,2,0,5,0,7,3,6,3,1,0,5,3,7,2},x);
    g(x) = rdtable(waveform{2,3,1,3,1,2,0,2,0,8,3,1,0,0,0,0},x);
    h(x) = rdtable(waveform{1,6,5,2,1,9,1,3,6,8,4,7,4,9,4,7},x);
};

rat = scale : ba.selectn(N,index(x,y,z)%N);
midc = 261.626;
frq = midc*rat;

env = en.adsr(0,0,1,0.2,trig1);
mel = frq/2 : os.square*env*0.1 : ve.moog_vcf(0.6,midc*4*env);

t = trig3 : ba.peakholder(2*ba.sec2samp(60/110));
kick = sy.kick(44, 0.03, 0.001, 4, 1, t);

process =  mel + kick <: dm.freeverb_demo;
