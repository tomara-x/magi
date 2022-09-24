//use tab/shift+tab to select entry boxes and up/down keys to change values quickly

import("stdfaust.lib");

N = 16; //number of steps
trig = ba.beat(hslider("[9]bpm",120,1,960,1)*4);
//hbout active steps checkboxes?
t = ba.counter(trig)%hslider("[8]active steps",N,1,N,1);
x = hslider("[0]x mult",1,0,64,1);
y = hslider("[1]y mult",1,0,64,1);
z = hslider("[2]z mult",1,0,64,1);

index(t,x,y,z) = f(t) +g(t)*x +h(t)*y +i(t)*z
with {
    f(n) = hgroup("[4]t val", par(j,N, nentry("[%2j] %2j",0,-14,14,1))) : ba.selectn(N,n);
    g(n) = hgroup("[5]x mod", par(j,N, nentry("[%2j] %2j",1,-14,14,1))) : ba.selectn(N,n);
    h(n) = hgroup("[6]y mod", par(j,N, nentry("[%2j] %2j",1,-14,14,1))) : ba.selectn(N,n);
    i(n) = hgroup("[7]z mod", par(j,N, nentry("[%2j] %2j",1,-14,14,1))) : ba.selectn(N,n);
};

rat = ba.semi2ratio(index(t,x,y,z)%hslider("[a]max index out (range)", 128, 1, 512, 1)); //what? a? hex?
midc = 261.626;

// scale = nentry("scale[style:menu{'eolian':0;'ionian':1;'dorian':2;'locrian':3;'phrygian':4;'lydian':5;'mixolydian':6;'pentatonic m':7}]",0,0,7,1);
//bad way to do it, this is a list of 49+5 elements
// scaleList = (qu.eolian,qu.ionian,qu.dorian,qu.locrian,qu.phrygian,qu.lydian,qu.mixo,qu.penta);
frq = midc*rat : qu.quantize(midc,qu.eolian);

env = en.adsr(0,0,1,0.2,trig);
mel = frq/16 : os.square*env : fi.resonlp(midc*16*env+midc*2,2,0.05);

led = 1 : ba.selectoutn(N, t) : hgroup("[3]steps", par(i,N, vbargraph("[%2i] %2i [style:led]",0,1))) :> _;

process = attach(mel, led) <: _,_;
