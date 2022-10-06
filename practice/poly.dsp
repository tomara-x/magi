//trans rights
import("stdfaust.lib");

trig2gate(t,time) =  t : ba.peakholder(ba.sec2samp(time));

bpm = 96;


//polyriddim
htrig = ba.beat(bpm*3);
hbeat = ba.cycle(12, htrig) : _,!,!,!,_,!,!,!,_,!,!,! :> _;
hat = sy.hat(3100,18e3,0.0005,0,hbeat);

ktrig = ba.beat(bpm*4);
kbeat = ba.cycle(16, ktrig) : _,!,!,!,_,!,!,!,_,!,!,!,_,!,!,! :> _;
kick = sy.kick(44, 0.01, 0.001, .6, 1, trig2gate(kbeat,0.05));


/*
//polymeter
htrig = ba.beat(bpm*4);
hbeat = ba.cycle(12, htrig) : _,_,!,!,_,!,!,!,_,!,!,! :> _;
hat = sy.hat(3100,18e3,0.0005,0,hbeat);

ktrig = ba.beat(bpm*4);
kbeat = ba.cycle(16, ktrig) : _,_,!,!,_,!,!,!,_,!,!,!,_,!,!,! :> _;
kick = sy.kick(44, 0.01, 0.001, .6, 1, trig2gate(kbeat,0.05));
*/

process = kick+hat <: dm.freeverb_demo;
