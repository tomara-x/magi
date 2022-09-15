import("stdfaust.lib");

sek = (0.5,2,4,7.5,0,9+12,6.25,4.5); //go back to ints for 12tet
gate = ba.pulsen(S*0.25,S) with{S=ba.sec2samp(1/((128)/60));};
env = en.adsr(0.005,0.05,.5,0.01,gate);
cnt = ba.counter(gate)%outputs(sek);

step = sek : ba.selectn(outputs(sek),cnt);
rat = ba.semi2ratio(step);
midc = 261.626;
frq = midc*rat;

//what if you want a long thin string (high freq and resonates long)
sig = pm.nylonGuitar(pm.f2l(frq/4),0.1,0.8,gate);// : fi.resonlp(12000,8,2);
process = sig : aa.clip(-.5,.5) <: _,_;
// process = frq : os.osc*0.1*env <: _,_;
