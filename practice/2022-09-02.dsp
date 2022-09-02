//trans rights

/*
import("stdfaust.lib");
freq0 = os.osc(880)*880;
freq2 = 440;
gain0 = 0.1;
gain2 = 0.1;
process = 
    os.osc(freq0)*gain0,
    os.osc(freq2)*gain2 
    :> _ // merging signals here
    <: dm.zita_light; // and then splitting them for stereo in
*/

/*
import("stdfaust.lib");
carrierFreq = 400;
modulatorFreq = 110;
index = 0.1;
process = os.osc(carrierFreq+os.osc(modulatorFreq)*index) <: dm.zita_light;
*/

/*
import("stdfaust.lib");
random = +(12345) ~ *(1103515245);
process = random : aa.clip(-1,1)*0.1;
*/

/*
import("stdfaust.lib");
process = 
    dm.cubicnl_demo : // distortion 
    dm.wah4_demo <: // wah pedal
    dm.phaser2_demo : // stereo phaser 
    dm.compressor_demo : // stereo compressor
    dm.zita_light; // stereo reverb
*/

/*
import("stdfaust.lib");
freq = hslider("[2]frq", 440, 20, 440*8, 1);
res = hslider("[3]res", 0, -1, 1, 0.01);
gate = button("[1]gate");
string(frequency,resonance,trigger) = trigger : ba.impulsify : fi.fb_fcomb(1024,del,1,resonance)
with {
    del = ma.SR/frequency;
};
process = string(freq,res,gate) <: _,_;
*/

//study
import("stdfaust.lib");
freqMod = hslider("h:Modulator/Frequency", 777, 20, 15000, 1) : si.smoo;
modIndex = hslider("h:Modulator/Modulation Index", 1000, 0, 10000, 1) : si.smoo;
freq = hslider("h:General Parameters/freq", 440, 20, 8000, 1) : si.smoo;
gain = hslider("gain", 1, 0, 1, 0.01) : si.smoo;
gate = button("gate") : si.smoo;
process = vgroup("FMsynth [style:keyboard]",os.osc(freqMod)*modIndex + freq : os.osc*gate*gain <: _,_);
