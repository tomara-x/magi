import("stdfaust.lib");

// schedule(in,p2,p3) = ba.if(ba.time < ba.sec2samp(p2+p3), in@(ba.sec2samp(p2)), 0);

// outputs input signal delayed by `start` seconds for `dur` seconds
schedule(in,start,dur) = in@(ba.sec2samp(start)) * gate
with {
    gate = 1 + -1@(ba.sec2samp(start+dur));
};
// start and dur in samples
scheduleSamp(in,start,dur) = in@(start) * gate
with {
    gate = 1 + -1@(start+dur);
};

process = scheduleSamp(no.pink_noise,44100,2*44100);

//i think the muted signal will still be computed, so this is nothing like a csound schedule
