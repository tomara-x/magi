//trans rights

declare name "adhesivegirl";
declare author "amy universe";
declare version "0.10";
declare license "WTFPL";
declare options "[midi:on][nvoices:8]";

import("stdfaust.lib");

//TODO: noise filter affecting group freq without any noise being added, meditate on the hz shift

N = 16; //oscillators per group

//frequency of each partial, making sure it's in range [10 to sr/2] Hz,
//going into oscillators, mult by 0 for inactive ones, mult by envelopes and velocity,
//then summed into filter (tracking key), and divided for loudness
group(x) = par(i,N, frq(i) : max(10) : min(ma.SR/2) :
            os.osc *(i<m) * env(i) * vel) :> fi.svf.lp(min(frq(0),ma.SR/2)+offset,q)/N
with {
    offset = vslider("v:[0]part/[1]filter cf [style:knob]",0,0,1e4,0.1);
    q = vslider("v:[0]part/[2]filter q [style:knob]",1,0.001,4,0.001);
    m = vslider("v:[0]part/[0]n [style:knob]",N,0,N,1);
    noise = no.multinoise(N);
    rnd(i) = noise : ba.selector(i,N);

    //midi key frequency, shifted by group shift, then by partial shift, all shifted by group and partial
    //semitone shift, then frequency randomness is added
    frq(i) = (base_frq + gshift_hz + i*pshift_hz) * 2^(gshift_sm/12) * 2^(pshift_sm*i/12) *
        (2^(rnd_amt*rnd(i)/12) : ba.sAndH(ba.beat(noise_rate)) : fi.lowpass(1,noise_filter))
    with {
        gshift_hz = vslider("v:[2]freq/h:[0]group shift/hz [style:knob]",0,0,2000,0.1);
        gshift_sm = vslider("v:[2]freq/h:[0]group shift/semi [style:knob]",0,-48,48,0.1);
        pshift_hz = vslider("v:[2]freq/h:[1]partial shift/hz [style:knob]",0,0,2000,0.1);
        pshift_sm = vslider("v:[2]freq/h:[1]partial shift/semi [style:knob]",0,-24,24,0.1);
        rnd_amt = vslider("v:[1]noise/[0]rnd amount [style:knob]",0,0,48,0.1);
        noise_rate = vslider("v:[1]noise/[1]rate [style:knob]",20,0.1,200,0.1)*60;
        noise_filter = vslider("v:[1]noise/[2]filter [style:knob]",20,1,200,1);
    };

    //envelope segments, each with its own randomess amount, rate, and smoothness 
    env(i) = gate : en.adsr(a+ar,d+dr,min(max(s+sr,0),1),r+rr)
    with {
        a = vslider("h:[a]env/v:[0]attack/[0]attack [style:knob]",0,0,1,0.0001);
        ar = att_rnd*rnd(i) : ba.sAndH(ba.beat(noise_rate)) : fi.lowpass(1,noise_filter)
        with {
            att_rnd = vslider("h:[a]env/v:[0]attack/[1]rnd amount [style:knob]",0,0,10,0.001);
            noise_rate = vslider("h:[a]env/v:[0]attack/[2]rate [style:knob]",20,0.1,200,0.1)*60;
            noise_filter = vslider("h:[a]env/v:[0]attack/[3]filter [style:knob]",20,1,200,1);
        };

        d = vslider("h:[a]env/v:[1]decay/[0]decay [style:knob]",0,0,1,0.0001);
        dr = dec_rnd*rnd(i) : ba.sAndH(ba.beat(noise_rate)) : fi.lowpass(1,noise_filter)
        with {
            dec_rnd = vslider("h:[a]env/v:[1]decay/[1]rnd amount [style:knob]",0,0,10,0.001);
            noise_rate = vslider("h:[a]env/v:[1]decay/[2]rate [style:knob]",20,0.1,200,0.1)*60;
            noise_filter = vslider("h:[a]env/v:[1]decay/[3]filter [style:knob]",20,1,200,1);
        };

        s = vslider("h:[a]env/v:[2]sustain/[0]sustain [style:knob]",0,0,1,0.0001);
        sr = sus_rnd*rnd(i) : ba.sAndH(ba.beat(noise_rate)) : fi.lowpass(1,noise_filter)
        with {
            sus_rnd = vslider("h:[a]env/v:[2]sustain/[1]rnd amount [style:knob]",0,0,1,0.001);
            noise_rate = vslider("h:[a]env/v:[2]sustain/[2]rate [style:knob]",20,0.1,200,0.1)*60;
            noise_filter = vslider("h:[a]env/v:[2]sustain/[3]filter [style:knob]",20,1,200,1);
        };

        r = vslider("h:[a]env/v:[3]release/[0]release [style:knob]",0.01,0,1,0.0001);
        rr = rel_rnd*rnd(i) : ba.sAndH(ba.beat(noise_rate)) : fi.lowpass(1,noise_filter)
        with {
            rel_rnd = vslider("h:[a]env/v:[3]release/[1]rnd amount [style:knob]",0,0,10,0.001);
            noise_rate = vslider("h:[a]env/v:[3]release/[2]rate [style:knob]",20,0.1,200,0.1)*60;
            noise_filter = vslider("h:[a]env/v:[3]release/[3]filter [style:knob]",20,1,200,1);
        };
    };
};

G = 4; //number of groups
process = tgroup("adhesivegirl",par(i,G,hgroup("%i",group(i)))) :> _/G <: _,_;

//midi
base_frq = nentry("/t:adhesivegirl/h:midistuff/freq",0,0,2e4,1)*bend;
gate = button("/t:adhesivegirl/h:midistuff/gate");
vel = nentry("/t:adhesivegirl/h:midistuff/gain",0.5,0,1,0.01);
bend = ba.semi2ratio(hslider("/t:adhesivegirl/h:midistuff/bend[midi:pitchwheel]",0,-2,2,0.01)) : si.polySmooth(gate,0.999,1);
