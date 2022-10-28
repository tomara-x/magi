//trans rights

declare name "quadrotorgirl";
declare author "amy universe";
declare version "0.02";
declare license "WTFPL";
declare options "[midi:on][nvoices:4]";

import("stdfaust.lib");

//TODO: delay randomization, filter for the noise, grain fm, decay and sustain check

bi2uni = _ : +(1) : /(2) : _;

rain(x,in) = gate * g1 * g2 : en.adsr(a,d,s,r) * in * vel
with {
    gate = button("h:hidden/gate"); //midi gate
    vel = nentry("h:hidden/gain",0.5,0,1,0.01); //midi velocity

    g1 = os.lf_pulsetrain(frq+fr,width+wr) : bi2uni
    with {
        frq = vslider("h:%2x/[0] g1 frq [style:knob]",0,0,200,0.1);
        width = vslider("h:%2x/[2] g1 pw [style:knob]",0,0,1,0.001);
        fr = vslider("h:%2x/[1] g1 frq rnd [style:knob]",0,0,1,0.001) * no.noise * 1000; //scale
        wr = vslider("h:%2x/[3] g1 pw rnd [style:knob]",0,0,1,0.001) * no.noise;
    };

    g2 = os.lf_pulsetrain(frq+fr,width+wr) : bi2uni
    with {
        frq = vslider("h:%2x/[4] g2 hfrq [style:knob]",0,0,200,0.1);
        width = vslider("h:%2x/[6] g2 pw [style:knob]",0,0,1,0.001);
        fr = vslider("h:%2x/[5] g2 frq rnd [style:knob]",0,0,1,0.001) * no.noise * 1000;
        wr = vslider("h:%2x/[7] g2 pw rnd [style:knob]",0,0,1,0.001) * no.noise;
    };

    a = vslider("h:%2x/[8] attack [style:knob]",0,0,0.01,0.0001);
    d = vslider("h:%2x/[9] decay [style:knob]",0,0,0.01,0.0001);
    s = vslider("h:%2x/[a] sustain [style:knob]",0,0,1,0.0001);
    r = vslider("h:%2x/[b] release [style:knob]",0.01,0,1,0.0001);
};

// process = nentry("h:hidden/freq",0,0,2e4,1) : os.osc <: par(i,4,rain(i)/4) :> _ <: _,_;
process = nentry("h:hidden/freq",0,0,2e4,1) : os.osc <: par(j,4,par(i,4,rain(i)/16)) :> _ <: _,_;
//greyhole
