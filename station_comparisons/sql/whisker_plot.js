//https://developers.google.com/chart/image/docs/gallery/compound_charts?hl=en#box_charts
var whisker_plot=function(wa,xlabel,opt) {
    opt = typeof opt !== 'undefined' ?  opt : {height:300,min:3,max:12};
    var min = typeof opt.min !== 'undefined' ?  opt.min : 3;
    var max = typeof opt.max !== 'undefined' ?  opt.max : 12;
    var height = typeof opt.height !== 'undefined' ?  opt.height : 300;
    var outliers = typeof opt.outliers !== 'undefined' ?  opt.outliers : false;
    var na=-10;
    var i;
    var l = wa.length;
    var width=l/5*height;
    var qn=[na];
    var q1=[na];
    var m=[na];
    var q3=[na];
    var qx=[na];
    var on=[na];
    var ox=[na];
    //var xlabel=['+'];
    var w;
    // Count total max and min outliers
    var outs_max=0;
    var outs=[];

    for (i=0;i<l;i++) {
      w=wa[i];
      //   xlabel.push(i);
      qn.push(w.qn.toFixed(2));
      q1.push(w.q1.toFixed(2));
      m.push(w.median.toFixed(2));
      q3.push(w.q3.toFixed(2));
      qx.push(w.qx.toFixed(2));
      outs[i]=[];
      if (outliers) {
        w.min_outliers.forEach(function(v) {outs[i].push(v.toFixed(2))});
      } else {
        if(w.min_outliers[0]) {
          outs[i].push(w.min_outliers[0].toFixed(2));
        }
      }
      if (outliers) {
        w.max_outliers.forEach(function(v) {outs[i].push(v.toFixed(2))});
      } else {
        if (w.max_outliers[0]) {
          outs[i].push(w.max_outliers[w.max_outliers.length-1].toFixed(2));
        }
      }
      if (outs[i].length > outs_max) {
       outs_max=outs[i].length;
      }
    }
    //xlabel.push('+');
    qn.push(na);
    q1.push(na);
    m.push(na);
    q3.push(na);
    qx.push(na);

    // Do complete series for outliers
    var outs_chd=[];
    var outs_chm=[];
    for (o=0; o<outs_max;o++) {
      var temp=[na];
      for (i=0;i<l;i++) {
        temp.push(outs[i][o]||na);
      }
      temp.push(na);
      outs_chd[o]=temp.join(',')
      outs_chm[o]='o,FF0000,'+(o+5)+',-1,7';
    }

    // Check total size:
    if (width*height > 300000) {
      width=300000/height;
    }

    var chs='chs='+width+'x'+height;
    var cht='cht=lc';  // Line chart lc=with labels ls=without
    var chds='chds='+min+','+max; // Y-axis
    var chd=[
      qn.join(','),
    	    q1.join(','),
    	    q3.join(','),
    	    qx.join(','),
    	    m.join(',')];
    // Add Outliers
    outs_chd.forEach(function(v){chd.push(v)});
    chd='chd=t0:'+chd.join('|');

    // Colors
    var chm=[
	     'F,FF9900,0,1:'+l+',25',
	      'H,000000,0,1:'+l+',1:20',
	'H,000000,4,1:'+l+',1:25',
	'H,000000,3,1:'+l+',1:20'];
  // Add Outliers
  outs_chm.forEach(function(v){chm.push(v)});
  //	'o,FF0000,5,-1,7',
//	'o,FF0000,6,-1,7'].join('|');

  chm='chm='+chm.join('|');


    // Axis Labels
    var chxt='chxt=x,y,r';
    // Axis ranges
    var chxr='chxr=1,'+min+','+max+',2|2,'+min+','+max+',2';
    var chxl='chxl=0:|+|'+xlabel.join('|')+'|+';

    return 'https://chart.googleapis.com/chart?'+[chs,cht,chds,chxt,chxr,chxl,chd,chm].join('&');
};

module.exports = {
    whisker_plot:whisker_plot
};
