import("stdfaust.lib");
scaleRep(scal,octs) = par(i,octs,par(j,outputs(scal),ba.take(j+1,scal)*(i+1)));
scale = scaleRep(qu.eolian, 2);

trig = ba.beat(128);
x = ba.counter(trig : ba.resetCtr(8,1))%14;
y = ba.counter(trig)%8;

num(i,j) = f(j)+g(j)*i
with {
    f(x) = rdtable(waveform{1,4,5,6,7,2,5,1},x);
    g(x) = rdtable(waveform{1,3,0,6,8,2,3,0},x);
};

//sure you can table the scale
gate = ba.pulsen(S*0.75,S) with{S=ba.sec2samp(1/((128)/60));};
rat = scale : ba.selectn(outputs(scale),num(x,y)%16);
midc = 261.626;
frq = midc*rat;

sig = pm.nylonGuitar(pm.f2l(frq/4),0.05,0.8,gate);

process = sig <: dm.freeverb_demo;
