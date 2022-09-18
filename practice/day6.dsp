//i shan't perish like a human
//that lydian is just a list of ratios (2^0/12,...)
import("stdfaust.lib");
step = ba.counter(ba.beat(135))%7;
ratio = qu.lydian : ba.selectn(7,step);
process = 440*ratio : os.osc;


//noooooo!
//import("stdfaust.lib");
//struct = environment{x=1;y=3;};
//structs = par(i,4,struct);
//process = ba.take(1,structs).x;


//import("stdfaust.lib");
// list = ((0,13),(3,4)); // 3 items
// list = (0,13,(3,4));   // 4 items
// list = ((0,13,3,4));   // 4 items
// list = (0,(13,3),4);   // 3 items
//process = ba.count(list);


//cute af!
duplicate(1,x) = x;
duplicate(n,x) = x,duplicate(n-1,x);

count((x,rest)) = 1+count(rest);
count(x) = 1;
