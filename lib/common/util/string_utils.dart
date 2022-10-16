// TODO: [Leptopoda] deprecate as dart has it's own function (at least for the above)

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

String interpolate(String string, List<String?> params) {
  String result = string;
  for (int i = 0; i < params.length; i++) {
    result = result.replaceAll('%$i', params[i]!);
  }

  return result;
}
