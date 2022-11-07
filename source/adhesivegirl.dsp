//trans rights

declare name "adhesivegirl";
declare author "amy universe";
declare version "0.07";
declare license "WTFPL";
declare options "[midi:on][nvoices:8]";

import("stdfaust.lib");


N = 8; //oscillators per group
group(x) = par(i,N, frq(i) : min(ma.SR/2) : os.osc *(i<m) * env(i)) :> _/N
with {
    m = vslider("h:%x/v:freq/partials [style:knob]",N,0,N,1);
    noise = no.multinoise(N);
    rnd(i) = noise : ba.selector(i,N);
    frq(i) = (base_frq + gshift_hz + i*pshift_hz) * 2^(gshift_sm/12) * 2^(pshift_sm*i/12) *
        (2^(rnd_amt*rnd(i)/12) : ba.sAndH(ba.beat(noise_rate)) : fi.lowpass(1,noise_filter))
    with {
        gshift_hz = vslider("h:%x/v:freq/h:[0]group shift/hz [style:knob]",0,0,2000,0.1);
        gshift_sm = vslider("h:%x/v:freq/h:[0]group shift/semi [style:knob]",0,-24,24,0.1);
        pshift_hz = vslider("h:%x/v:freq/h:[1]partial shift/hz [style:knob]",0,0,2000,0.1);
        pshift_sm = vslider("h:%x/v:freq/h:[1]partial shift/semi [style:knob]",0,-24,24,0.1);
        rnd_amt = vslider("h:%x/v:freq/rnd amount [style:knob]",0,0,48,0.1);
        noise_rate = vslider("h:%x/v:freq/h:[2]noise/rate [style:knob]",20,1,200,1)*60;
        noise_filter = vslider("h:%x/v:freq/h:[2]noise/filter [style:knob]",20,1,200,1);
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


process = tgroup("adhesivegirl",par(i,4,hgroup("%i",group(i)))) :> _/4 <: _,_;

base_frq = nentry("/t:adhesivegirl/h:zmidistuff/freq",0,0,2e4,1); //midi frequency;
gate = button("/t:adhesivegirl/h:zmidistuff/gate"); //midi gate
vel = nentry("h:hidden/gain",0.5,0,1,0.01); //midi velocity
bend = ba.semi2ratio(hslider("h:hidden/bend[midi:pitchwheel]",0,-2,2,0.01)) : si.polySmooth(gate,0.999,1); //midi pitch bend
