import("stdfaust.lib");
scaleRep(scal,octs) = par(i,octs,par(j,outputs(scal),ba.take(j+1,scal)*(i+1)));
scale = scaleRep(qu.lydian, 3);

N = outputs(scale);
trig = ba.beat(110*4);
z = ba.counter(trig : ba.resetCtr(N*4,1))%16;
x = ba.counter(trig : ba.resetCtr(8,1))%N;
y = ba.counter(trig)%8;

num(i,j,k) = f(j) +g(j)*i +h(j)*k
with {
    f(x) = rdtable(waveform{1,1,1,1,1,1,1,1},x);
    g(x) = rdtable(waveform{0,3,0,0,1,2,0,-1},x);
    h(x) = rdtable(waveform{1,6,8,6,4,3,6,2},x);
};

rat = scale : ba.selectn(N,num(x,y,z)%N);
midc = 261.626;
frq = midc*rat;

process = frq/4 : os.saw3 : fi.resonlp(2000,6,0.1) <: dm.freeverb_demo,z;
