//this is terrible, saved for logging purposes

import("stdfaust.lib");

node(init,t,scale) = scale : ba.selectn(n,c%n)
with{
    c = init + ba.counter(t);
    n = ba.count(scale);
};

trigseq(t,n) = t : ba.selectoutn(n,ba.counter(t)%n);

T = ba.beat(137); //yeah, she's our witch
C = ba.counter(T);
N = 8;

sequence(t) = node(0,t,qu.lydian);
process = trigseq(T,N) : par(i,N, i,_,qu.lydian : node) : ba.selectn(N,C)*440 : os.osc*0.1;
