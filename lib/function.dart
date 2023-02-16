String formatTietHoc(List tietHoc){
  String tietStr = "";
  for(int i = 0; i < tietHoc.length - 1; i++){
    tietStr += "${tietHoc[i]}, ";
  }
  tietStr += tietHoc.last.toString();
  return tietStr;
}