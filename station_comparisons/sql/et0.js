var P=function(z) {
  return 101.3*Math.pow((293.0-0.0065*z)/293,5.26)
}

var psychrometric_constant = function(z) {
  return 0.665e-3*P(z);
}

var Tm = function(Tn,Tx) {
  return (Tn+Tx)/2.0;
}

var es = function(Tn,Tx) {
	return 0.6108 / 2 * (Math.exp(Tn * 17.27/ (Tn + 237.3))+ Math.exp(Tx * 17.27/ (Tx + 237.3)));
}

var ea = function(Tdew) {
	return 0.6108*Math.exp((Tdew*17.27/((Tdew+237.30))));
}

var et0=function(z,Tn,Tx,Tdew,U2,Rs,Rnl) {
  var GAM=psychrometric_constant(z)
  var TM=Tm(Tn,Tx);
  var EA=ea(Tdew);
  var ES=es(Tn,Tx);
	var DEL=4098.17*0.6108*(Math.exp(TM*17.27/(TM+237.3)))/Math.pow(TM+237.3,2);
	return (900.0*GAM/(TM+273)*U2*(ES-EA)+0.408*DEL*(Rs*(1.0-0.23)+Rnl))/(DEL+GAM*(1.0+0.34*U2))
}

module.exports = {
  P:P,
  psychrometric_constant:psychrometric_constant,
  Tm:Tm,
  ea:ea,
  es:es,
  et0:et0
};
