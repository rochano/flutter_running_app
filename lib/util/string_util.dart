class StringUtils {
  static String convertDateToString(DateTime date) {
    String y = date.year.toString();
    String m = date.month.toString();
    String d = date.day.toString();
    if (m.length == 1) {
      m = "0" + m;
    }
    if (d.length == 1) {
      d = "0" + d;
    }
    return y + m + d;
  }

  static String convertTimeToString(DateTime time) {
    String h = time.hour.toString();
    String m = time.minute.toString();
    String s = time.second.toString();
    if (h.length == 1) {
      h = "0" + h;
    }
    if (m.length == 1) {
      m = "0" + m;
    }
    if (s.length == 1) {
      s = "0" + s;
    }
    return h + m + s;
  }
}
