import 'dart:convert';

import 'package:state_cities_api/app/models/city_model.dart';
import 'package:state_cities_api/app/models/state_model.dart';
import 'package:state_cities_api/cache/redis_cache.dart';

//* constantes para trabalharmos com as constantes correta
const _statesKey = 'STATES_KEY';
const _cityKey = 'CITY_KEY';

class LocationCacheDatasource {
  final RedisCache _cacheClient;

  LocationCacheDatasource(this._cacheClient);

  //* criando as implementações do cache

  Future<List<StateModel>> getCachedState() async {
    final statesCache = await _cacheClient.get(_statesKey);
    return switch (statesCache) {
      != null && String(isNotEmpty: true) => jsonDecode(statesCache)
          .map<StateModel>((s) => StateModel.fromMap(s))
          .toList(),
      _ => []
    };
  }

  Future<List<CityModel>> getCachedCitiesByState(String state) async {
    //* pegando a lista pro estados e não buscar 100% os estados
    //* onde no qual irei compor a base pelo stado
    final citiesCache = await RedisCache.instance.get('${state}_$_cityKey');

    return switch (citiesCache) {
      != null && String(isNotEmpty: true) => jsonDecode(citiesCache)
          .map<CityModel>((c) => CityModel.fromMap(c))
          .toList(),
      _ => []
    };
  }

  Future<void> setCachedStates(List<StateModel> states) async {
    final data = json.encode(states.map((s) => s.toMap()).toList());
    await _cacheClient.put(_statesKey, data, Duration(days: 180));
  }

  Future<void> setCachedCities(String state, List<CityModel> cities) async {
    final data = json.encode(cities.map((s) => s.toMap()).toList());
    _cacheClient.put('${state}_$_cityKey', data, Duration(days: 90));
  }
}
