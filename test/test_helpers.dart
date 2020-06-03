extension ListDynamic on List<dynamic> {
  bool hasNoNulls() {
    for (var v in this) {
      if (v == null) { return false; }
    }
    return true;
  }
}

extension StringHelper on String {
  List<String> splitMapTrim() => this.split('\n').map((l) => l.trim()).toList();
}
