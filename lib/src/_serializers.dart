part of 'serializers.dart';

Type _$TypeFromJson(Map<String, dynamic> json) {
  return Type(
    desugaredQualType: json['desugaredQualType'] as String,
    qualType: json['qualType'] as String,
    typeAliasDeclId: json['typeAliasDeclId'] as String,
  );
}

Map<String, dynamic> _$TypeToJson(Type instance) => <String, dynamic>{
      'desugaredQualType': instance.desugaredQualType,
      'qualType': instance.qualType,
      'typeAliasDeclId': instance.typeAliasDeclId,
    };

Decl _$DeclFromJson(Map<String, dynamic> json) {
  return Decl(
    id: json['id'] as String,
    kind: json['kind'] as String,
    tagUsed: json['tagUsed'] as String,
    name: json['name'] as String,
    opcode: json['opcode'] as String,
    decl: json['decl'] == null ? null
        : Decl.fromJson(json['decl'] as Map<String, dynamic>),
    inner: (json['inner'] as List)
        ?.map(
            (e) => e == null ? null : Decl.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    type: json['type'] == null
        ? null
        : Type.fromJson(json['type'] as Map<String, dynamic>),
    valueCategory: json['valueCategory'] as String,

    // We want strings (the JSON parser turned this into integers / floats etc.)
    value: json['value'] != null ? json['value'].toString() : null,
  );
}

Map<String, dynamic> _$DeclToJson(Decl instance) => <String, dynamic>{
      'id': instance.id,
      'kind': instance.kind,
      'tagUsed': instance.tagUsed,
      'name': instance.name,
      'opcode': instance.opcode,
      'inner': instance.inner,
      'type': instance.type != null ? _$TypeToJson(instance.type) : null,
      'valueCategory': instance.valueCategory,
      'value': instance.value,
    };
