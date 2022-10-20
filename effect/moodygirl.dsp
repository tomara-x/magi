//trans rights

declare name "moodygirl";
declare author "amy universe";
declare version "-0.02";
declare license "WTFPL";

import("stdfaust.lib");

N = 16;
mood = _ : pm.modalModel(N,par(i,N,f(i)),par(i,N,d(i)),par(i,N,a(i)))/N : _
with {
    f(x) = vslider("./h:[0]frq/freq %2x [style:knob]",220,0,2e4,0.1);
    a(x) = vslider("./h:[1]amp/amp %2x [style:knob]",0.1,0,1,0.001);
    d(x) = vslider("./h:[2]decay/decay %2x [style:knob]",1,0,10,0.001);
};

//process = no.noise*0.01*((os.lf_pulsetrain(60,0.5)+1)/2) : vgroup("moodygirl", mood) <: _,_;
process = _,_ : vgroup("moodygirl", mood),vgroup("moodygirl", mood) : _,_;
