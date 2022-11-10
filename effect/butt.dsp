//trans rights

declare name "butt";
declare author "amy universe";
declare version "0.02";
declare license "WTFPL";

import("stdfaust.lib");
import("physmodels.lib");

//touch butt, hear cute noises
N = 20;
rnd = no.multinoise(N) : par(i,N,ba.sAndH(button("BUTT") : ba.impulsify));

butt(r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13,r14,r15,r16,r17,r18,r19,r20,excitation) =
endChain(chain(
    fluteHead : stringSegment(0.1,r1) : in(excitation) : violinBowedString(r11,r12,r13,r14) :
    violinBow(r3,r4) : out : stringSegment(0.1,r20) : violinBow(r9,r10) :
    brassLips(0.1,r17,r18) : violinBody : fluteEmbouchure(r15) :
    nylonString(0.1,r19,excitation) : violinBowedString(r5,r6,r7,r8) :
    stringSegment(0.1,r2) : openTube(0.1,r16) : fluteHead));

process = rnd,_ : butt : fi.dcblocker : aa.clip(-1,1) <: _,_;
