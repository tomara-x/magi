import("stdfaust.lib");

N = 16; //number of steps
trig = ba.beat(hgroup("[0]main",hslider("[0]bpm",120,0,960,0.001)*4));
midc = 261.626;

semis(t,x,y,z,a,b,c) = f(t) +g(t)*x +h(t)*y +i(t)*z <: +(at(t)*a), +(bt(t)*b), +(ct(t)*c)
with {
    f(n) = hgroup("[3]t val", par(j,N, nentry("[%2j] %2j",0,-24,24,0.5))) : ba.selectn(N,n);
    g(n) = hgroup("[4]x mod", par(j,N, nentry("[%2j] %2j",0,-24,24,0.5))) : ba.selectn(N,n);
    h(n) = hgroup("[5]y mod", par(j,N, nentry("[%2j] %2j",0,-24,24,0.5))) : ba.selectn(N,n);
    i(n) = hgroup("[6]z mod", par(j,N, nentry("[%2j] %2j",0,-24,24,0.5))) : ba.selectn(N,n);
    at(n) = hgroup("[7]a trans", par(j,N, nentry("[%2j] %2j",0,-24,24,0.5))) : ba.selectn(N,n);
    bt(n) = hgroup("[8]b trans", par(j,N, nentry("[%2j] %2j",0,-24,24,0.5))) : ba.selectn(N,n);
    ct(n) = hgroup("[9]c trans", par(j,N, nentry("[%2j] %2j",0,-24,24,0.5))) : ba.selectn(N,n);
};

ratios = semis(t,x,y,z,a,b,c) : par(i,3, %(maxrange) : +(minrange) : ba.semi2ratio)
with {
    t = ba.counter(trig)%hgroup("[0]main",hslider("[2]active steps",N,1,N,1));
    x = hgroup("[1]dimension", hslider("[0]x mult",1,0,64,1));
    y = hgroup("[1]dimension", hslider("[1]y mult",1,0,64,1));
    z = hgroup("[1]dimension", hslider("[2]z mult",1,0,64,1));

    a = hgroup("[2]trans mult", hslider("[0]a",1,0,64,1));
    b = hgroup("[2]trans mult", hslider("[0]b",1,0,64,1));
    c = hgroup("[2]trans mult", hslider("[0]c",1,0,64,1));

    minrange = hgroup("[a]range", hslider("[0]min", 0, 0, 128, 1));
    maxrange = hgroup("[a]range", hslider("[1]max", 36, 1, 128, 1));
};

frqs = ratios : par(i,3, *(midc*2^(root/12)*2^oct))
with {
    root = hgroup("[0]main",hslider("[1]root note", 0,0,11,1));
    oct = hgroup("[a]range",hslider("[2]octave", 0,-8,8,1));
}

process = frqs : os.square, os.square, os.square;
