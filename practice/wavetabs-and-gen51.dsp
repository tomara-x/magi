import("stdfaust.lib");

// wav = waveform{3,3,4};
// sig1 = rwtable(wav,0,5,0);
// sig2 = rdtable(wav,0);

gen51(semis,octs) = par(i,octs,par(j,c,(i+1)*ba.semi2ratio(ba.selectn(c,j,semis))))
with {
    c = ba.count(semis);
};
process = gen51(par(i,24,i/2),1);
