//trans rights
//don't even need a "multiplied clock" you can just delay signaals by values!
import("stdfaust.lib");

trig2gate(t,time) =  t : ba.peakholder(ba.sec2samp(time));

bpm = 86;

htrig = ba.beat(bpm*3);
hbeat = ba.cycle(12, htrig) : _,!,!,!,_,!,!,!,_,!,!,! :> _;
hat = sy.hat(3100,18e3,0.0005,0,hbeat);

ktrig = ba.beat(bpm*4);
kbeat = ba.cycle(16, ktrig) : _,!,!,!,_,!,!,!,_,!,!,!,(_ <: _,_@(ba.tempo(bpm)/8)),!,!,! :> _; //play the 4, then a delayed by 8th version
kick = sy.kick(44, 0.002, 0.0005, .1, 1, trig2gate(kbeat,0.05));

process = kick+hat /*: *(5) : aa.sine2 : *(5) : aa.cubic1 : *(0.5)*/ <: dm.freeverb_demo; //aim, you're dirty
