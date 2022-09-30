import("stdfaust.lib");
bpm = 81;
res = 4;
trig = ba.beat(bpm*res);
beat = ba.cycle(16, trig) : _,!,_,_,!,!,_,!,_,_,_,!,_,!,!,! :> _;
sig = sy.hat(3170,18000,0.0005,0,beat);
process = sig <: _,_;
