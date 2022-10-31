//trans rights

declare name "quadrotorgirl";
declare author "amy universe";
declare version "0.05";
declare license "WTFPL";
declare options "[midi:on][nvoices:8]";

import("stdfaust.lib");

//TODO: delay randomization, mod wheel

bi2uni = _ : +(1) : /(2) : _;

rain(x,in) = gate * g1 * g2 : en.adsr(a,d,s,r) * in * vel
with {
    rnd = no.noise : ba.sAndH(ba.beat(vslider("h:%2x/noise rate [style:knob]",2e4,1,2e4,1)*60));

    g1 = os.lf_pulsetrain(frq+fr,width+wr) : bi2uni
    with {
        frq = vslider("h:%2x/h:[0]g1/[0]frq [style:knob]",0,0,2000,0.1);
        width = vslider("h:%2x/h:[0]g1/[2]pw [style:knob]",0,0,1,0.001);
        fr = vslider("h:%2x/h:[0]g1/[1]frq rnd [style:knob]",0,0,1,0.001) * rnd * 1000; //scale
        wr = vslider("h:%2x/h:[0]g1/[3]pw rnd [style:knob]",0,0,1,0.001) * abs(rnd);
    };

    g2 = os.lf_pulsetrain(frq+fr,width+wr) : bi2uni
    with {
        frq = vslider("h:%2x/h:[1]g2/[0]frq [style:knob]",0,0,2000,0.1);
        width = vslider("h:%2x/h:[1]g2/[2]pw [style:knob]",0,0,1,0.001);
        fr = vslider("h:%2x/h:[1]g2/[1]frq rnd [style:knob]",0,0,1,0.001) * rnd * 1000;
        wr = vslider("h:%2x/h:[1]g2/[3]pw rnd [style:knob]",0,0,1,0.001) * abs(rnd);
    };

    a = vslider("h:%2x/h:[2]env/[0]attack [style:knob]",0,0,0.01,0.0001);
    d = vslider("h:%2x/h:[2]env/[1]decay [style:knob]",0,0,0.01,0.0001);
    s = vslider("h:%2x/h:[2]env/[2]sustain [style:knob]",0,0,1,0.0001);
    r = vslider("h:%2x/h:[2]env/[3]release [style:knob]",0.01,0,1,0.0001);
};

op(amp,frq,fb) = (_+_ : os.oscp(frq)*amp) ~ *(fb); //pm operator

gate = button("h:hidden (yeah! don't look here!)/gate"); //midi gate
vel = nentry("h:hidden (yeah! don't look here!)/gain",0.5,0,1,0.01); //midi velocity
frq = nentry("h:hidden (yeah! don't look here!)/freq",0,0,2e4,1); //midi frequency
bend = ba.semi2ratio(hslider("h:hidden (yeah! don't look here!)/bend[midi:pitchwheel]",0,-2,2,0.01)) : si.polySmooth(gate,0.999,1);

fb = vslider("feedback [style:knob]",0,0,1,0.001); //carrier feedback

process = par(s,2, op(1,frq*bend,fb) <: par(i,4,rain(i)/4) :> _ );
//greyhole?
