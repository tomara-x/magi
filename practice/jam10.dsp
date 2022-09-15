/*
import("stdfaust.lib");

list = par(i,16, par(j,8, (j+(j+1)*i)%16));
t = ba.beat(128);
c = ba.counter(t);
step = list : ba.selectn(8*16,c);
midc = 261.626;
frq = midc*ba.semi2ratio(step) : qu.quantize(midc,qu.dorian);

process = frq : os.osc*0.1 <: _,_;


//different
import("stdfaust.lib");

scaleRep(rats,octs) = par(i,octs,rats) : par(i,octs,par(j,c,_*(i+1)))
with {
    c = outputs(rats);
};

list = par(i,16, par(j,8, ((j+1)+(j+1)*i)%14));
t = ba.beat(128*4);
c = ba.counter(t)%outputs(list);
step = list : ba.selectn(outputs(list),c);
midc = 261.626;
scale = scaleRep(qu.eolian, 2);
frq = midc*ba.selectn(outputs(scale),step,scale)/2;

process = frq : os.osc*0.1 <: _,_;
*/

// a bit better
import("stdfaust.lib");

scaleRep(scal,octs) = par(i,octs,par(j,outputs(scal),ba.take(j+1,scal)*(i+1)));
scale = scaleRep(qu.eolian, 2);
list = par(i,14,par(j,8, ((j+1)+(j+1)*i)%14));

t = ba.beat(128*4);
c = ba.counter(t)%outputs(list);
step = list : ba.selectn(outputs(list),c);
rat = scale : ba.selectn(outputs(scale),step);
midc = 261.626;
frq = midc*rat/2;

process = frq : os.osc*0.1 <: _,_;
