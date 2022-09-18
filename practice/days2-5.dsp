//doodles and examples from the manual
//for sentimental reasons

//delay 2 seconds
//process = no.noise*0.1 : @(ma.SR*2);

//process = +(1,3);   //prefex
//process = 1,3 : +;  //core
//process = 1+3;      //infix

//foreign constant (fvariable, ffunction)
//sr = fconstant(int fSamplingFreq, <math.h>);

//can those be returned by functions?
//struct = environment {
//  m = -1;
//  n = 1;
//};

//can be inlined
//environment{m = -1; n = 1;}.m; // -1

//N = 10;
//process = route(N,N,par(i,N,(i+1,N-i)));

//process = 1,1 : + : _,1 : +;
//process = +(1,(+(1,1)));

//import("stdfaust.lib");
//add1 = +(1);
//add2 = +(2);
//add3 = +(3);
//mute = *(0);
//process = add2~add1 : mute;

// any diff between those?
//process = add1~_ : out;
//process = _~add1 : out;

//import("stdfaust.lib");
//filter = +~*(0.9);
//process = no.no.noise*0.01 : filter;
//process = 135 : ba.beat;

//clock
//process = 60 : ba.beat;

//eq
import("stdfaust.lib");
nBands = 8;
filterBank(N) = hgroup("Filter Bank",seq(i,N,oneBand(i)))
with {
    oneBand(j) = vgroup("[%j]Band %a",fi.peak_eq(l,f,b))
    with {
        a = j+1; // just so that band numbers don't start at 0
        l = vslider("[2]Level[unit:db]",0,-70,12,0.01) : si.smoo;
        f = nentry("[1]Freq",(80+(1000*8/N*(j+1)-80)),20,20000,0.01) : si.smoo;
        b = f/hslider("[0]Q[style:knob]",1,1,50,0.01) : si.smoo;
    };
};
process = no.noise*0.01 : filterBank(nBands) <: _,_;

//additive synth with par iteration
import("stdfaust.lib");
freq = hslider("freq",440,50,3000,0.01);
gain = hslider("gain",1,0,1,0.01);
gate = button("gate");
envelope = gain*gate : si.smoo;
nHarmonics = 4;
process = par(i,nHarmonics,os.osc(freq*(i+1))) :> /(nHarmonics)*envelope;

//mute = *(0);
//process = par(j,4,par(i,2,i:mute));

//am with prod iteration
import("stdfaust.lib");
freq = hslider("[0]freq",440,50,3000,0.01);
gain = hslider("[1]gain",1,0,1,0.01);
shift = hslider("[2]shift",0,0,1,0.01);
gate = button("[3]gate");
envelope = gain*gate : si.smoo;
nOscs = 16;
process = prod(i,nOscs,os.osc(freq*(i+1+shift)))*envelope;
