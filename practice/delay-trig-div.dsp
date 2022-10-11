//trans rights
import("stdfaust.lib");

//will get back to this

trig2gate(t,time) =  t : ba.peakholder(ba.sec2samp(time));

bpm = 60;
trig = ba.beat(bpm); //trigger at beat
beat = ba.tempo(bpm); // beat length in samples

hbeat = trig <: _,_@(beat/3),_@(beat/6) :> _;
hat = sy.hat(3100,18e3,0.0005,0,hbeat);

kbeat = trig <: _,_@(beat*1),_@(beat*2),_@(beat*3),_@(beat*3.25) :> _;
kick = sy.kick(44, 0.05, 0.005, .9, 1, trig2gate(kbeat,0.05));

process = kick+hat <: dm.freeverb_demo;
