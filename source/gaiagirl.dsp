//trans rights

declare name "gaiagirl";
declare author "amy universe";
declare version "0.03";
declare license "WTFPL";
declare options "[midi:on][nvoices:8]";

import("stdfaust.lib");

//this is supposed to be a wave-terrain synth with a superformula scanning shape

//tables
N = 1 << 16;
wave = float(ba.time)*(2.0*ma.PI)/float(N) <: sin,cos,tan;
W = outputs(wave);

// rotation (i think)
xp = os.hsp_phasor(1,frq,0,0);
yp = os.hsp_phasor(1,frq,0,0.5);

//formula shape
superf(sig) = (abs(cos((m1*sig)/4)/a)^n2 + abs(sin((m2*sig)/4)/b)^n3)^-1/n1 : %(N) //this doesn't keep it in range (cus offset)
with {
    m1 = vslider("h:[1]superformula/[0]m1 [style:knob]",4,-64,64,0.001);
    m2 = vslider("h:[1]superformula/[1]m2 [style:knob]",4,-64,64,0.001);
    n1 = vslider("h:[1]superformula/[2]n1 [style:knob]",10,0.001,64,0.001);
    n2 = vslider("h:[1]superformula/[3]n2 [style:knob]",6,1,64,0.001);
    n3 = vslider("h:[1]superformula/[4]n3 [style:knob]",6,1,8,0.001);
    a = vslider("h:[1]superformula/[5]a [style:knob]",6,0.01,64,0.001);
    b = vslider("h:[1]superformula/[6]b [style:knob]",6,0.01,64,0.001);
};

//rotate the formula and scan the wave-tables
x = par(i,W,rdtable(N,wave : ba.selector(i,W), superf(xp)*g + o*N)) //this feels wrong (the read range)
with {
    g = vslider("h:[0]hehe/h:[1]rotor/[0]x gain [style:knob]",1,0,1,0.001);
    o = vslider("h:[0]hehe/h:[1]rotor/[2]x pose [style:knob]",0.5,0,1,0.001);
};
y = par(i,W,rdtable(N,wave : ba.selector(i,W), superf(yp)*g + o*N))
with {
    g = vslider("h:[0]hehe/h:[1]rotor/[1]y gain [style:knob]",1,0,1,0.001);
    o = vslider("h:[0]hehe/h:[1]rotor/[3]y pose [style:knob]",0.5,0,1,0.001);
};

//selection of which wave-table we scanning
process = (x : ba.selectn(W,wx)) * (y : ba.selectn(W,wy)) * env * vel <: _,_
with {
    wx = vslider("h:[0]hehe/h:[0]waveform/x [style:knob]",0,0,W-1,1);
    wy = vslider("h:[0]hehe/h:[2]waveform/y [style:knob]",0,0,W-1,1);
};

//midi and envelope biz
frq = nentry("h:hidden/freq",0,0,2e4,1) * bend;
gate = button("h:hidden/gate");
vel = nentry("h:hidden/gain",0.5,0,1,0.01);
bend = ba.semi2ratio(hslider("h:hidden/bend [midi:pitchwheel] [style:knob]",0,-2,2,0.01)) : si.polySmooth(gate,0.999,1);
env = gate : en.adsr(a,d,s,r)
with {
    a = vslider("h:[2]env/[0]attack [style:knob]",0.01,0,4,0.0001);
    d = vslider("h:[2]env/[1]decay [style:knob]",0,0,4,0.0001);
    s = vslider("h:[2]env/[2]sustain [style:knob]",1,0,1,0.0001);
    r = vslider("h:[2]env/[3]release [style:knob]",0.01,0,4,0.0001);
};
