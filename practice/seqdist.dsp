//trans rights
import("stdfaust.lib");

trig2gate(t,time) =  t : ba.peakholder(ba.sec2samp(time));

bpm = 86;

htrig = ba.beat(bpm*3);
hbeat = ba.cycle(12, htrig) : _,!,!,!,_,!,!,!,_,!,!,! :> _;
hat = sy.hat(3100,18e3,0.0005,0,hbeat);

ktrig = ba.beat(bpm*8);
kbeat = ba.cycle(32, ktrig) : par(i,3,_,_,!,!,!,!,!,!),_,_,_,!,!,_,!,! :> _;
kick = sy.kick(44, 0.002, 0.0005, .6, 1, trig2gate(kbeat,0.05));

process = kick+hat : *(10) : aa.sine2 : *(10) : aa.cubic1 : *(0.5) <: dm.freeverb_demo;
