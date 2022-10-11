//trans rights

declare name "nailgirl";
declare author "amy universe";
declare version "0.01";
declare license "WTFPL";

import("stdfaust.lib");

dist = _ : *(g0) : aa.tanh1 : *(g1) : aa.sine2 : *(g2) : _
with {
        g0 = vslider("[0]tanh",1,0.01,100,0.01);
        g1 = vslider("[1]sine",1,0.01,100,0.01);
        g2 = vslider("[2]post",0.5,0,1,0.01);
};

process = _,_ : hgroup("nailgirl",hgroup("l",dist),hgroup("r",dist)) <: _,_;


//_ : (*(wet) : effect), *(1-wet) : _
