class Subs {
  String arrow = "-->";  //Arrow separating start time from end time
  String tokens = ":,";
  String[] lines;
  
  //These all contain the different parts of the subtitle each relate to each (at startArr index 1 relates to index 1 of endArr and subArr
  IntList startArr = new IntList();
  IntList endArr = new IntList();
  StringList subArr = new StringList();
  
  Subs(String fname) {
    //Load the file into the lines array
    String[] lines = loadStrings(fname);
    int i = 0;
    while (i < lines.length) {
      //If the line contains an arrow, you have a new subtitle - get it into a StringList
      if (lines[i].contains(arrow)){
        StringList subtitle = new StringList();
        subtitle.append(lines[i++]);
        while (lines[i].length() > 0) {
          subtitle.append(" " + lines[i++]);
        }
        calcTimes(subtitle);
        println();
      }
      i++;  //Skip line
    }
  }
  int parseTime(String[] timeArr) {
    //Returns time in ms; time array has format hours, minutes, seconds, milliseconds
    String[] arr = timeArr[0].split(":");
    int time = 0;
    String[] milli = arr[2].split(",");
    time += int(arr[0].trim())*3600000;
    time += int(arr[1].trim())*60000;
    time += int(milli[0].trim())*1000;
    time += int(milli[1].trim());
    
    int t = time;  //Replace this with time calculation
    return t;
  }
  void calcTimes(StringList subtitle) {

    String[] startTimeArr = new String[1];
    String[] endTimeArr = new String[1];
    String t0 = "";
    startTimeArr[0] = subtitle.get(0).split(arrow)[0];
    endTimeArr[0] = subtitle.get(0).split(arrow)[1];
    for (int i=1; i<subtitle.size(); i++) {
      t0 += subtitle.get(i);
    }
    int t1 = parseTime(startTimeArr);  //Start time
    int t2 = parseTime(endTimeArr);    //End time
    endArr.append(t2);
    startArr.append(t1);
    subArr.append(t0);
  }
}
