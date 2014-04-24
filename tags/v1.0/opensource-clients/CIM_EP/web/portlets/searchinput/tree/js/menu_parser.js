// menu_parser.js

  var kar;
  var txt = '';
  var a = new Array;
  var mode = 0;
  var indent = -1;
  var cb_num = -1;
  var label = '';
  var valname = '';
  var max_indent = 3; // 0..3 = 4 indent levels
  var seq = [-1,-1,-1,-1]; // current sequence number at each indent level

function rtrim(s)
{

	var i=s.length -1;
	while(i > 0 && s.charAt(i) == ' ')
	{	
            i= i - 1;	
        }
	return s.substring(0, i+1);
}

function parse()
{ 
  var xstr = parent.portalScripts.getFromSSEWindow("getCollectionData")();
  for (i=0;i<xstr.length;i++) {
    kar = xstr.charAt(i);
    //if (i<100) alert("mode="+mode+"  xstr["+i+"]="+kar+"<");
    switch (mode) {
      case 0: // before indenting
        if (kar == ']') {
          indent = 0;
          mode = 1;
        }
        break;
      case 1: // within indenting
        if (kar == ']') {
          if (indent < max_indent)
            indent++;
        }
        else if ((kar != '[') && (kar != ' ')) {
          label = kar;
          seq[indent]++;
          for (j=indent+1;j<=max_indent;j++) {
            seq[j] = -1;
          }
          mode = 2;
        }
        break;
      case 2: // within label
        if ((kar == '{') || (kar == '[') || (kar == ']')) {
          if (!label)
            label = '?';
          cb_num += 1;
          if (indent == 0) {
            a[seq[0]] = new Array;
            a[seq[0]]['checkboxName'] = 'cb' + cb_num;
            a[seq[0]]['caption'] = rtrim(label);
//          a[seq[0]]['isOpen'] = true;
//txt+="a["+seq[0]+"] = new Array;\n";
//txt+="a["+seq[0]+"]['caption'] = "+label+";\n";
          }
          else if (indent == 1) {
            if (seq[indent] == 0) {
              a[seq[0]]['children'] = new Array;
//txt+="a["+seq[0]+"]['children'] = new Array;\n";
            }
            a[seq[0]]['children'][seq[1]] = new Array;
            a[seq[0]]['children'][seq[1]]['checkboxName'] = 'cb' + cb_num;
            a[seq[0]]['children'][seq[1]]['caption'] = rtrim(label);
//txt+="a["+seq[0]+"]['children']["+seq[1]+"] = new Array;\n";
//txt+="a["+seq[0]+"]['children']["+seq[1]+"]['caption'] = "+label+";\n";
          }
          else if (indent == 2) {
            if (seq[indent] == 0) {
              a[seq[0]]['children'][seq[1]]['children'] = new Array;
//txt+="a["+seq[0]+"]['children']["+seq[1]+"]['children'] = new Array;\n";
            }
            a[seq[0]]['children'][seq[1]]['children'][seq[2]] = new Array;
            a[seq[0]]['children'][seq[1]]['children'][seq[2]]['checkboxName'] = 'cb' + cb_num;
            a[seq[0]]['children'][seq[1]]['children'][seq[2]]['caption'] = rtrim(label);
//txt+="a["+seq[0]+"]['children']["+seq[1]+"]['children']["+seq[2]+"] = new Array;\n";
//txt+="a["+seq[0]+"]['children']["+seq[1]+"]['children']["+seq[2]+"]['caption'] = "+label+";\n";
          }
          else if (indent == 3) {
            if (seq[indent] == 0) {
              a[seq[0]]['children'][seq[1]]['children'][seq[2]]['children'] = new Array;
//txt+="a["+seq[0]+"]['children']["+seq[1]+"]['children']["+seq[2]+"]['children'] = new Array;\n";
            }
            a[seq[0]]['children'][seq[1]]['children'][seq[2]]['children'][seq[3]] = new Array;
            a[seq[0]]['children'][seq[1]]['children'][seq[2]]['children'][seq[3]]['checkboxName'] = 'cb' + cb_num;
            a[seq[0]]['children'][seq[1]]['children'][seq[2]]['children'][seq[3]]['caption'] = rtrim(label);
//txt+="a["+seq[0]+"]['children']["+seq[1]+"]['children']["+seq[2]+"]['children']["+seq[3]+"] = new Array;\n";
//txt+="a["+seq[0]+"]['children']["+seq[1]+"]['children']["+seq[2]+"]['children']["+seq[3]+"]['caption'] = "+label+";\n";
          }
          if (kar == '{') {
            valname = '';
            mode = 3;
          }
          else if (kar == '[') {
            indent = -1;
            mode = 1;
          }
          else if (kar == ']') {
            indent = 0;
            mode = 1;
          }
        }
        else {
          label = label + kar;
        }
        break;
      case 3: // within value name
        if ((kar == '}') || (kar == '[') || (kar == ']')) {
          if (!valname)
            valname = '';
          if (indent == 0) {
            a[seq[0]]['checkboxValue'] = valname;
//txt+="a["+seq[0]+"]['valueName'] = "+valname+";\n";
          }
          else if (indent == 1) {
            a[seq[0]]['children'][seq[1]]['checkboxValue'] = valname;
//txt+="a["+seq[0]+"]['children']["+seq[1]+"]['valueName'] = "+valname+";\n";
          }
          else if (indent == 2) {
            a[seq[0]]['children'][seq[1]]['children'][seq[2]]['checkboxValue'] = valname;
//txt+="a["+seq[0]+"]['children']["+seq[1]+"]['children']["+seq[2]+"]['valueName'] = "+valname+";\n";
          }
          else if (indent == 3) {
            a[seq[0]]['children'][seq[1]]['children'][seq[2]]['children'][seq[3]]['checkboxValue'] = valname;
//txt+="a["+seq[0]+"]['children']["+seq[1]+"]['children']["+seq[2]+"]['children']["+seq[3]+"]['valueName'] = "+valname+";\n";
          }
          if (kar == '}') {
            mode = 0;
          }
          else if (kar == '[') {
            indent = -1;
            mode = 1;
          }
          else if (kar == ']') {
            indent = 0;
            mode = 1;
          }
        }
        else if (kar != ' ') {
          valname = valname + kar;
        }
        break;
      default:
    }
  }
}
