//80bpm kick
import("stdfaust.lib");
trig = ba.pulsen(ba.sec2samp(0.5), ba.sec2samp(60/80));
sig = sy.kick(44, 0.01, 0.001, .6, 1, trig);
process = sig <: _,_;
