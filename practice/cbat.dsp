import("stdfaust.lib");
bpm = 81;
res = 4;
trig = ba.beat(bpm*res);
beat = ba.cycle(16, trig) : _,!,_,_,!,!,_,!,_,_,_,!,_,!,!,! :> _;
sig = sy.hat(3170,18000,0.0005,0,beat);
process = sig <: _,_;

/*
import("stdfaust.lib");

trig2gate(t,time) =  t : ba.peakholder(ba.sec2samp(time));

bpm = 96;

// htrig = ba.beat(bpm*3);
// f(x) = ba.resetCtr(12,x,htrig);
// hbeat = 1,5,9,10,11 : par(i,5,f) :> _;
hat = sy.hat(3100,18e3,0.0005,0,hbeat);
htrig = ba.beat(bpm*6);
f(x) = ba.resetCtr(24,x,htrig);
hbeat = 1,10,18,20,21,22 : par(i,6,f) :> _;

ktrig = ba.beat(bpm*4);
g(x) = ba.resetCtr(16,x,ktrig);
kbeat = 1,5,9,13 : par(i,4,g) :> _;
kick = sy.kick(44, 0.01, 0.001, .6, 1, trig2gate(kbeat,0.1));

process = kick+hat <: _,_;

//1,3,4,7,9,10,11,13 //amen!
// process = +(ba.beat(30)) ~ _ : -(1) : %(16);
// process = +(gate(30,0.5)) ~ _ : /(ma.SR);
*/

/*
import("stdfaust.lib");
trig2gate(t,time) =  t : ba.peakholder(ba.sec2samp(time));
bpm = 96;
htrig = ba.beat(bpm*3);
hbeat = ba.cycle(12, htrig) : _,!,!,_,!,!,_,!,!,_,!,_ :> _;
hat = sy.hat(3100,18e3,0.0005,0,hbeat);
ktrig = ba.beat(bpm*4);
kbeat = ba.cycle(16, ktrig) : _,!,!,!,_,!,!,!,_,!,!,!,_,!,_,! :> _;
kick = sy.kick(44, 0.01, 0.001, .6, 1, trig2gate(kbeat,0.05));
process = kick+hat <: dm.freeverb_demo;
*/
