void prt(Object? object, {Object? tag}) {
  // ignore: avoid_print
  print("${tag ?? ""} ${object?.toString()}");
}
