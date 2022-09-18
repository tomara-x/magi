import("stdfaust.lib");

//perfuma my darling!
clkmult(f,l) = par(i,N,ba.take(i+1,l)*f) : par(i,N,ba.beat)
with {
    N = ba.count(l);
};

// process = clkmult(137, (0.001,1,2,4));

//one-line witch
list = par(j,4,par(i,4, (0,1,i+j,3)));
// (0,1,0,3,0,1,1,3,0,1,2,3,0,1,3,3,
//  0,1,1,3,0,1,2,3,0,1,3,3,0,1,4,3,
//  0,1,2,3,0,1,3,3,0,1,4,3,0,1,5,3,
//  0,1,3,3,0,1,4,3,0,1,5,3,0,1,6,3)
process = list :> _;

//nah, bad idea
trig = ba.beat(137);
trace(t,l) = ba.if(c==1,n,trace(t,n))
with {
    i = ba.counter(t);
    n = l : ba.selectn(ba.count(l),i);
    c = ba.count(n);
};
// process = trace(trig, (0,3,1,3,4,4,(4,4,5),5));
