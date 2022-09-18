//skinning cats for funzies
if1 = _,_,_ : (_ != 0.0) , ro.cross(2) : select2 : _;
if2 = (_ == 0.0),_,_ : select2;
if3(cond,then,else) = select2((cond == 0.0),then,else);

//comparator distortion
cmpdst(in,op,thr) = op(in,thr);
// process = cmpdst(_,>,0.1);
