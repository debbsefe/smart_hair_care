import 'dart:convert';

import 'package:drift/drift.dart';

/// TypeConverter for storing list of specific curl patterns as JSON
class SpecificPatternsConverter extends TypeConverter<List<String>, String> {
  const SpecificPatternsConverter();

  @override
  List<String> fromSql(String fromDb) {
    if (fromDb.isEmpty) return [];
    try {
      final decoded = json.decode(fromDb) as List;
      return decoded.map((e) => e.toString()).toList();
    } on FormatException {
      return [];
    }
  }

  @override
  String toSql(List<String> value) {
    return json.encode(value);
  }
}
