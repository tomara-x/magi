import("stdfaust.lib");
scaleRep(scal,octs) = par(i,octs,par(j,outputs(scal),ba.take(j+1,scal)*(i+1)));

scale = scaleRep(qu.eolian, 2);
list = par(i,14,par(j,8, ((j+1)+(j+1)*i)%14));
step = list : ba.selectn(outputs(list),ba.time);
tabSize = outputs(list);
sequence(i) = tabSize,step,int(i) : rdtable;

t = ba.beat(128*4);
c = ba.counter(t)%outputs(list);

rat = scale : ba.selectn(outputs(scale),sequence(c));
midc = 261.626;
frq = midc*rat/2;

process = frq : os.osc*0.1 <: _,_;


//a much worse method
/*
import("stdfaust.lib");
scaleRep(scal,octs) = par(i,octs,par(j,outputs(scal),ba.take(j+1,scal)*(i+1)));

scale = scaleRep(qu.eolian, 2);
list = par(i,14,par(j,8,rat(num(i,j))))
with {
    num(i,j) = ((j+1)+(j+1)*i)%14;
    rat(x) = scale : ba.selectn(outputs(scale),x);
};

step = list : ba.selectn(outputs(list),ba.time);
tabSize = outputs(list);
sequence(i) = tabSize,step,int(i) : rdtable;

t = ba.beat(128*4);
c = ba.counter(t)%outputs(list);

rat = sequence(c);
midc = 261.626;
frq = midc*rat/2;

process = frq : os.osc*0.1 <: _,_;
*/
