//jam10
import("stdfaust.lib");

list = par(i,16, par(j,8, (j+(j+1)*i)%16));
t = ba.beat(128);
c = ba.counter(t);
step = list : ba.selectn(8*16,c);
midc = 261.626;
frq = midc*ba.semi2ratio(step) : qu.quantize(midc,qu.dorian);

process = frq : os.osc*0.1 <: _,_;
