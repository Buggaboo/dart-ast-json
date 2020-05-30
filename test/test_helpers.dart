extension ListDynamic on List<dynamic> {
  bool hasNoNulls() {
    for (var v in this) {
      if (v == null) { return false; }
    }
    return true;
  }
}