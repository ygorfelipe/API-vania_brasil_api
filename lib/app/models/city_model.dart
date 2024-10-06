// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

//! O EQUALITY E OBRIGATORIO
class CityModel {
  final String name;
  final String ibge;

  CityModel({required this.name, required this.ibge});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'nome': name,
      'codigo_ibge': ibge,
    };
  }

  factory CityModel.fromMap(Map<String, dynamic> map) {
    return switch (map) {
      {'nome': final String name, 'codigo_ibge': final String ibge} =>
        CityModel(name: name, ibge: ibge),
      _ => throw ArgumentError('Invalid json'),
    };
  }

  String toJson() => json.encode(toMap());

  factory CityModel.fromJson(String source) =>
      CityModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool operator ==(covariant CityModel other) {
    if (identical(this, other)) return true;

    return other.name == name && other.ibge == ibge;
  }

  @override
  int get hashCode => name.hashCode ^ ibge.hashCode;
}
