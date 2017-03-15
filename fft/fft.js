var statewide = function() {
    return [3.80000344759448,3.37241570426343,2.98848553693941,2.70012106485601,2.38930214273498,2.03123198503821,1.76906058726106,1.6015210993811,1.45574468970531,1.28634681025683,1.13471224048035,1.14812877579674,1.14311733458844,1.17049720519879,1.33208044752798,1.49104802998844,1.57203662992406,1.71610941360572,1.96386135170138,2.08797742516025,2.19466357341965,2.50227013114089,3.03964604446435,3.34164195622777,3.59620271945776,3.62968113958865,3.96244810759992,4.20505219846233,4.46889790832936,4.87798903673321,5.33488244099353,5.58047907309925,5.78570062523704,5.73216902228751,6.07729247941205,6.41383094817757,6.70444079913044,6.8928676026226,6.93039971173247,6.92795756321174,6.87515329242875,6.81027639687444,6.676686649322,6.50350448806176,6.3447307476927,6.21433526882241,6.03554667658608,5.77904124803468,5.43198856149357,4.97467484951981,4.63246474069876,4.27677450058678];
};

var cum_et = function (E,D,d) {
    var ang=2*Math.PI*(d/365);
    var d1=ang-2*Math.PI*(D[1])/365;
    var d2=ang-2*Math.PI*(D[2]-D[1])/365;
    var et=E[0]*d-(365/2*Math.PI)( E[1]*Math.sin(d1)
				  +E[2]*Math.sin(d1));
    return et;
};

var et = function (E,D,d) {
    var d1=2*Math.PI*(d-D[1])/365;
    var d2=(2*2*Math.PI/365)*((d-D[1])-D[2]);
    var et=E[0]+E[1]*Math.cos(d1)+E[2]*Math.cos(d2);
    return et;
};

var ifft = function (E,D,N) {
    var n;
    var et=[];
    for (n=0;n<N;n++) {
	et[n]=this.et(E,D,365*(n/N));
    }
    return et;
};

var fft = function(et) {
    var N=et.length;
    var i,n;
    var re=[];
    var im=[];
    var E=[],D=[];
    var ang, etc, ets;

    for (i=0;i<3;i++) {
    	re[i]=0;
	im[i]=0;
	for (n=0;n<N;n++) {
	    ang=2*Math.PI*n/N;
	    re[i]+=et[n]*Math.cos(-i*ang);
	    im[i]+=et[n]*Math.sin(-ang*i);
	}
	switch(i) {
	case 0:
	    D[i]=0;
	    E[i]=Math.sqrt(Math.pow(re[i],2)+
		       Math.pow(im[i],2))/N;
	    break;
	case 1:
	    D[i]=(365 - 365/(2*Math.PI)*Math.atan2(im[i],re[i])) % 365;
     E[i]=2*Math.sqrt(Math.pow(re[i],2)+
			   Math.pow(im[i],2))/N;
	    break;
	default:
	    D[i]=((365.0/(2*Math.PI*i))*(-Math.atan2(im[i],re[i]))-D[i-1]) % (365.0/i);
	    E[i]=2*Math.sqrt(Math.pow(re[i],2)+
			     Math.pow(im[i],2))/N;
	    // Center on max
	    D[i]=(D[i]<-365.0/4)?D[i]+(365.0/2):D[i];
	    // Then center again, but on either high or low
	    E[i]=(D[i] < -365.0/8)?-E[i]:(D[i] < 365.0/8)?E[i]:-E[i];
	    D[i]=(D[i] < -365.0/8)?D[i]+(365.0/4):(D[i] < 365.0/8)?D[i]:D[i]-(365.0/4)
	}
    }
    return({e:E,d:D,re:re,im:im});
};

module.exports = {
    statewide:statewide,
    fft:fft,
    et:et,
    cum_et:cum_et,
    ifft:ifft
};
