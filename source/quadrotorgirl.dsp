//trans rights

declare name "quadrotorgirl";
declare author "amy universe";
declare version "0.01";
declare license "WTFPL";
declare options "[midi:on][nvoices:4]";

import("stdfaust.lib");

//simple grain generator with a grain release envelope and a gate that mutes grain triggers
//all passed through a sweeping notch filter with its own clock and freq jump size
//there's a possibility of 32 overlapping grains (for now) (depending on the env length and trig frq)
//TODO: (randomness / different way to overlap grains), gated envelopes, grain fm

rain =  gate*grntrg*butt : ba.cycle(32) : par(i,32,en.are(0,r)*os.osc(frq)) :> fi.svf.notch(cf,q)*gain
with {
    grntrg = ba.beat(vslider("h:[0]t/[2]env trig hz[scale:log] [style:knob]",440,0.0001,2e4,0.0001)*60);
    gate = os.lf_pulsetrain(frq,pw)+1 : /(2)
    with {
        frq = vslider("h:[0]t/[0]gate frq [scale:log] [style:knob]",440,0.0001,2e4,0.0001);
        pw = vslider("h:[0]t/[1]gate width [style:knob]",0.5,0,1,0.001);
    };
    r = vslider("h:[0]t/[3]env release[scale:log] [style:knob]",0.01,0.001,4,0.0001);

    cf = ba.counter(os.lf_pulsetrain(frq,0.5)) : *(size) : %(2e4) : +(1)
    with {
        frq = vslider("h:[1]f/jmp frq [scale:log] [style:knob]",440,0.0001,2e4,0.0001);
        size = vslider("h:[1]f/jmp size [scale:log] [style:knob]",440,0.0001,2e4,0.0001);
    };
    frq = vslider("[-1]freq [scale:log] [style:knob]",440,0.0001,2e4,0.0001);
    butt = button("gate"); //midi gate
    q = vslider("h:[1]f/q [style:knob]",0.1,0.01,1,0.001);
    gain = vslider("[3]post gain [style:knob]",1,0,1,0.0001);
};

process = hgroup("quadrotorgirl", rain) <: _,_;
