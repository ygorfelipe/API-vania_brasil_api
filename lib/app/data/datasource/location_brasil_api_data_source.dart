//! aqui não estamos trabalhando com interface
//! logo apos tera explicação

import 'package:dio/dio.dart';
import 'package:state_cities_api/app/models/city_model.dart';
import '../../models/state_model.dart';

class LocationBrasilApiDataSource {
  Future<List<StateModel>> getStates() async {
    final Response(:List data) =
        await Dio().get('https://brasilapi.com.br/api/ibge/uf/v1');
    return data.map((s) => StateModel.fromMap(s)).toList();
  }

  Future<List<CityModel>> getCitiesByState(String state) async {
    final Response(:List data) = await Dio().get(
        'https://brasilapi.com.br/api/ibge/municipios/v1/$state?providers=dados-abertos-br,gov,wikipedia');
    return data.map((s) => CityModel.fromMap(s)).toList();
  }
}
