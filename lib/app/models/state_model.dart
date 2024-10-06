// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

//! O EQUALITY E OBRIGATORIO
class StateModel {
  final String acronym;
  final String name;

  StateModel({required this.acronym, required this.name});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'sigla': acronym,
      'nome': name,
    };
  }

  factory StateModel.fromMap(Map<String, dynamic> map) {
    return switch (map) {
      {'sigla': final String sigla, 'nome': final String nome} =>
        StateModel(acronym: sigla, name: nome),
      _ => throw ArgumentError('Invalid json'),
    };
  }

  String toJson() => json.encode(toMap());

  factory StateModel.fromJson(String source) =>
      StateModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool operator ==(covariant StateModel other) {
    if (identical(this, other)) return true;

    return other.acronym == acronym && other.name == name;
  }

  @override
  int get hashCode => acronym.hashCode ^ name.hashCode;
}
