String concatStringList(List<String> list, String separator) {
  var result = "";

  for (var element in list) {
    result += element + separator;
  }

  if (result != "") {
    result = result.substring(0, result.length - separator.length);
  }

  return result;
}

String interpolate(String string, List<String> params) {
  String result = string;
  for (int i = 1; i < params.length + 1; i++) {
    result = result.replaceAll('%$i\$', params[i - 1]);
  }

  return result;
}
