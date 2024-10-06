import 'package:state_cities_api/app/data/datasource/location_brasil_api_data_source.dart';
import 'package:state_cities_api/app/data/datasource/location_cache_datasource.dart';
import 'package:state_cities_api/app/data/repository/location_repository.dart';
import 'package:vania/vania.dart';

import '../../../cache/redis_cache.dart';

class LocationController extends Controller {
  final LocationRepository _locationRepository;

  //! já inicializando o location brasil api
  LocationController()
      : _locationRepository = LocationRepository(
          LocationBrasilApiDataSource(),
          LocationCacheDatasource(RedisCache.instance),
        );

  //* utilizar injeção de dependencia para a LocationRepository.
  Future<Response> getStates() async {
    final state = await _locationRepository.getStates();
    return Response.json(state.map((s) => s.toMap()).toList());
  }

  Future<Response> getCitiesByState(String state) async {
    final cities = await _locationRepository.getCitiesByState(state);
    return Response.json(cities.map((c) => c.toMap()).toList());
  }
}
