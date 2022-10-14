// TODO: [Leptopoda] deprecate this as propper localization does already have interpolation
String interpolate(String string, List<String?> params) {
  String result = string;
  for (int i = 0; i < params.length; i++) {
    result = result.replaceAll('%$i', params[i]!);
  }

  return result;
}
