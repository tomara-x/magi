import("stdfaust.lib");

scaleRep(scal,octs) = par(i,octs,par(j,outputs(scal),ba.take(j+1,scal)*(i+1)));
scale = scaleRep(qu.lydian,4); //4 octaves of the scale
N = outputs(scale); //number of notes in selected range

trig1 = ba.beat(110*4); //quarter notes at 110 bpm
trig2 = trig1 : ba.resetCtr(16,1); //pulse every 16th trig1
trig3 = trig2 : ba.resetCtr(4,1); //pulse every 4th trig2

x = ba.counter(trig1)%16; //32 steps
y = ba.counter(trig2)%N;
z = ba.counter(trig3)%8;

index(i,j,k) = f(i) +g(i)*j +h(i)*k
with {
    f(x) = rdtable(waveform{0,0,2,0,5,0,7,3,6,3,1,0,5,3,7,2},x);
    g(x) = rdtable(waveform{1,0,0,0,1,0,0,2,0,7,0,1,0,0,1,0},x);
    h(x) = rdtable(waveform{1,6,5,2,1,9,1,3,0,0,0,0,4,9,0,7},x);
};

rat = scale : ba.selectn(N,index(x,y,z)%N);
midc = 261.626;
frq = midc*rat;

trig2gate(trig,time) =  trig : ba.peakholder(ba.sec2samp(time));

t = trig2gate(trig3,2*60/110);
kick = sy.kick(44, 0.03, 0.001, 4, 1, t);

env = en.adsr(0,0,1,0.2,trig1);
// mel = frq/2 : os.square*0.1*(env+0.1) : ve.moog_vcf(0.1,midc*8*(env+0.5));
// mel = frq/2 : os.square*env*0.1 : ve.moog_vcf(0.9,midc*4*env+midc*2);
mel = frq : os.square*env : fi.resonlp(midc*16*env+midc*2,4,0.1);

process =  mel + kick <: dm.freeverb_demo;
