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

import("stdfaust.lib");
random = +(12345) ~ *(1103515245);
process = random : aa.clip(0,0.1);
