// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:state_cities_api/app/data/datasource/location_brasil_api_data_source.dart';
import 'package:state_cities_api/app/data/datasource/location_cache_datasource.dart';
import 'package:state_cities_api/app/models/city_model.dart';
import 'package:state_cities_api/app/models/state_model.dart';

class LocationRepository {
  final LocationBrasilApiDataSource _locationbrasilAPI;
  final LocationCacheDatasource _locationCache;
  LocationRepository(
    this._locationbrasilAPI,
    this._locationCache,
  );

  Future<List<StateModel>> getStates() async {
    //* fazendo a logica da API cache
    //* verificando se fez já a busica

    var states = await _locationCache.getCachedState();
    if (states.isEmpty) {
      log('[state] - Não tem no cache');
      states = await _locationbrasilAPI.getStates();
      if (states.isNotEmpty) {
        //* inserindo os dados no cache
        _locationCache.setCachedStates(states);
      }
    } else {
      log('[state] - peguei do cache');
    }

    return states;
  }

  Future<List<CityModel>> getCitiesByState(String state) async {
    var cities = await _locationCache.getCachedCitiesByState(state);
    if (cities.isEmpty) {
      log('[state] - Não tem no cache');
      cities = await _locationbrasilAPI.getCitiesByState(state);
      _locationCache.setCachedCities(state, cities);
    } else {
      log('[state] - peguei do cache');
    }
    return cities;
  }
}
