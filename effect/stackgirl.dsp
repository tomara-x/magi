//trans rights

declare name "stackgirl";
declare author "amy universe";
declare version "0.00";
declare license "WTFPL";

import("stdfaust.lib");

//mutes every other sample (if i did it right)
//fuck with the modulo and inverting samps later

f = _ ~ +(1); //ba.time?
process = _*(f%2) <: _,_;
