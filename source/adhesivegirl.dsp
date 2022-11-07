//trans rights

declare name "adhesivegirl";
declare author "amy universe";
declare version "0.02";
declare license "WTFPL";
declare options "[midi:on][nvoices:8]";

import("stdfaust.lib");


N = 32; //oscillators per group
group(x) = par(i,N, frq(i) : os.osc * env(i)) :> _/N
with {
    noise = no.multinoise(N);
    rnd(i) = noise : ba.selector(i,N);
    frq(i) = base_frq + gshift + i*pshift +
        (rnd_amt*rnd(i) : ba.sAndH(ba.beat(noise_rate)) : fi.lowpass(1,noise_filter))
    with {
        base_frq = nentry("h:hidden/freq",0,0,2e4,1); //midi frequency;
        gshift = vslider("h:%x/v:freq/group shift [style:knob]",0,0,2000,0.1);
        pshift = vslider("h:%x/v:freq/partial shift [style:knob]",0,0,2000,0.1);
        rnd_amt = vslider("h:%x/v:freq/rnd amount [style:knob]",0,0,10000,0.001);
        noise_rate = vslider("h:%x/v:freq/h:[0]noise/rate [style:knob]",20,1,200,1)*60;
        noise_filter = vslider("h:%x/v:freq/h:[0]noise/filter [style:knob]",20,1,200,1);
    };

    env(i) = gate : en.adsr(a+ar,d+dr,s+sr,r+rr)
    with {
        a = vslider("h:%x/h:[1]env/v:[0]attack/[0]attack [style:knob]",0,0,1,0.0001);
        ar = att_rnd*rnd(i) : ba.sAndH(ba.beat(noise_rate)) : fi.lowpass(1,noise_filter)
        with {
            att_rnd = vslider("h:%x/h:[1]env/v:[0]attack/[1]rnd amount [style:knob]",0,0,10,0.001);
            noise_rate = vslider("h:%x/h:[1]env/v:[0]attack/[2]rate [style:knob]",20,1,200,1)*60;
            noise_filter = vslider("h:%x/h:[1]env/v:[0]attack/[3]filter [style:knob]",20,1,200,1);
        };

        d = vslider("h:%x/h:[1]env/v:[1]decay/[0]decay [style:knob]",0,0,1,0.0001);
        dr = dec_rnd*rnd(i) : ba.sAndH(ba.beat(noise_rate)) : fi.lowpass(1,noise_filter)
        with {
            dec_rnd = vslider("h:%x/h:[1]env/v:[1]decay/[1]rnd amount [style:knob]",0,0,10,0.001);
            noise_rate = vslider("h:%x/h:[1]env/v:[1]decay/[2]rate [style:knob]",20,1,200,1)*60;
            noise_filter = vslider("h:%x/h:[1]env/v:[1]decay/[3]filter [style:knob]",20,1,200,1);
        };

        s = vslider("h:%x/h:[1]env/v:[2]sustain/[0]sustain [style:knob]",0,0,1,0.0001);
        sr = abs(sus_rnd*rnd(i) : ba.sAndH(ba.beat(noise_rate)) : fi.lowpass(1,noise_filter))
        with {
            sus_rnd = vslider("h:%x/h:[1]env/v:[2]sustain/[1]rnd amount [style:knob]",0,0,1,0.001);
            noise_rate = vslider("h:%x/h:[1]env/v:[2]sustain/[2]rate [style:knob]",20,1,200,1)*60;
            noise_filter = vslider("h:%x/h:[1]env/v:[2]sustain/[3]filter [style:knob]",20,1,200,1);
        };

        r = vslider("h:%x/h:[1]env/v:[3]release/[0]release [style:knob]",0.01,0,1,0.0001);
        rr = rel_rnd*rnd(i) : ba.sAndH(ba.beat(noise_rate)) : fi.lowpass(1,noise_filter)
        with {
            rel_rnd = vslider("h:%x/h:[1]env/v:[3]release/[1]rnd amount [style:knob]",0,0,10,0.001);
            noise_rate = vslider("h:%x/h:[1]env/v:[3]release/[2]rate [style:knob]",20,1,200,1)*60;
            noise_filter = vslider("h:%x/h:[1]env/v:[3]release/[3]filter [style:knob]",20,1,200,1);
        };
    };
};


process = group(0) <: _,_;

gate = button("h:hidden/gate"); //midi gate
vel = nentry("h:hidden/gain",0.5,0,1,0.01); //midi velocity
bend = ba.semi2ratio(hslider("h:hidden/bend[midi:pitchwheel]",0,-2,2,0.01)) : si.polySmooth(gate,0.999,1); //midi pitch bend
