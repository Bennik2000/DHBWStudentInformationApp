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
