//trans rights
import("stdfaust.lib");

modAmp = hslider("[0]mod amp",1,0,10,0.001) : si.smoo;
carAmp = hslider("[1]car amp",0.1,0,1,0.001) : si.smoo;
modFrq = hslider("[2]mod frq",220,20,2e4,1) : si.smoo;
carFrq = hslider("[3]car frq",440,20,2e4,1) : si.smoo;
modFB = hslider("[4]mod feedback",0,0,100,0.001) : si.smoo;
carFB = hslider("[5]car feedback",0,0,100,0.001) : si.smoo;

op(amp,frq,fb) = (_+_ : os.oscp(frq)*amp) ~ *(fb);

process = 0 : op(modAmp,modFrq,modFB) : op(carAmp,carFrq,carFB) <: _,_;
