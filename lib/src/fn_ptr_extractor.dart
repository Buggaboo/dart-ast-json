import 'serializers.dart';

// ignore_for_file: camel_case_types

String incrementSymbol(String str) => String.fromCharCodes(str.codeUnits.map((s) => normalizeSymbol(s + 1)));

final leftP  = '('.codeUnitAt(0);
final rightP = ')'.codeUnitAt(0);
int _weigh(String str) {
  int counter = 0;
  for (var c in str.codeUnits) {
    if (c == leftP) {
      counter++;
    }else if (c == rightP) {
      counter--;
    }
  }
  return counter;
}

List<int> sizesOfSplit(List<String> list) =>
    list.map((s) => s.length).toList();

String stripOuterParentheses(String clean) =>
    clean.substring(clean.indexOf('(')+1, clean.length-1);

void _replaceWithSymbol(String prevSymbol, String symbolPrefix,
    String input, Map<String, String> dict) {
  final clean = input.replaceFirst('(*)', '');
  final stripped = stripOuterParentheses(clean);
  final split = stripped.split(', ');
  final listBalance = split.map((s) => _weigh(s)).toList();

  var unbalanced = false;
  for (int b in listBalance) {
    if (0 < b) {
      unbalanced = true;
      break;
    }
  }

  if (unbalanced) {
    dict.remove(prevSymbol);
  }

  // final check
  var newSymbol = symbolPrefix;
  if (!unbalanced) {
    final balanceNested = split.where((s) => s.contains('(')).toList();
    for (int i=0; i<balanceNested.length; i++) {
      newSymbol = incrementSymbol(newSymbol);
      dict[newSymbol] = balanceNested[i];
      dict.remove(prevSymbol);
      dict[symbolPrefix] = input.replaceAll(balanceNested[i], newSymbol);
    }
    return;
  }

  var start = 0, end = 0;
  for (int i=0; i<listBalance.length; i++) {
    var b = listBalance[i];
    if (b == -1) {
      end = i;
      break;
    }
    if (b == 0) {
      continue;
    }
    if (b == 1) {
      start = i;
    }
  }

  final pattern = split.sublist(start, end + 1).join(', ');
  newSymbol = incrementSymbol(symbolPrefix);
  dict[newSymbol] = pattern;
  dict[symbolPrefix] = input.replaceAll(pattern, newSymbol);

  final prev2 = newSymbol;
  final prev1 = symbolPrefix;

  _replaceWithSymbol(prev1, symbolPrefix * 2, dict[symbolPrefix], dict);
  _replaceWithSymbol(prev2, newSymbol * 2, dict[newSymbol], dict);
}

List<Decl> _extractor(String name, String type) {
  final m = <String, String>{};
  _replaceWithSymbol("", name, type, m);
  if (m.isEmpty) {
    return [];
  }
  final sortedKeys = m.keys.toList();
  sortedKeys.sort();
  final prevRootName = sortedKeys[0];
  final rootContent = m[prevRootName];
  m.remove(prevRootName);
  m[name] = rootContent;
  return m.entries.map((e) =>
      Decl(kind: 'TypedefDecl', name: e.key, type:Type(qualType: e.value))).toList();
}

void extractNestedFunPtrs(List<Decl> extractable, List<Decl> typedefList) {
  extractable.forEach((e) =>
      typedefList.addAll(_extractor(e.name, e.type.qualType)));
}
