import 'dart:convert';

import 'package:mocktail/mocktail.dart';
import 'package:state_cities_api/app/data/datasource/location_cache_datasource.dart';
import 'package:state_cities_api/app/models/city_model.dart';
import 'package:state_cities_api/app/models/state_model.dart';
import 'package:state_cities_api/cache/redis_cache.dart';
import 'package:test/test.dart';

class RedisClientMock extends Mock implements RedisCache {}

void main() {
  //* criando um grupo, onde tera varios test dentro de uma stack
  group('LocationCacheDataSource', () {
    late LocationCacheDatasource dataSource;
    late RedisClientMock redisClient;

    setUp(() {
      //! obrigatorio ter o fallback para não haver erro
      registerFallbackValue(Duration(seconds: 60));
      redisClient = RedisClientMock();
      dataSource = LocationCacheDatasource(redisClient);
    });

    test('getCachedStates should return a list of StateModel', () async {
      //* preparando a estrutura de test
      final expectedState = [
        StateModel(acronym: 'SP', name: 'São Paulo'),
        StateModel(acronym: 'RJ', name: 'Rio de Janeiro'),
      ];

      final cachedStates = expectedState.map((e) => e.toMap()).toList();

      when(() => redisClient.get(stateKey))
          .thenAnswer((_) async => json.encode(cachedStates));

      final states = await dataSource.getCachedState();

      //* verificandos
      expect(states, equals(expectedState));
    });

    test('setCachedStates should store the list of StateModel in cache',
        () async {
      //* preparando a estrutura de test
      final expectedState = [
        StateModel(acronym: 'SP', name: 'São Paulo'),
        StateModel(acronym: 'RJ', name: 'Rio de Janeiro'),
      ];

      final cachedStates = expectedState.map((e) => e.toMap()).toList();
      when(() => redisClient.put(any(), any(), any())).thenAnswer((_) async {});
      when(() => redisClient.get(stateKey))
          .thenAnswer((_) async => json.encode(cachedStates));

      await dataSource.setCachedStates(expectedState);
      final result = await dataSource.getCachedState();

      //* verificandos
      verify(() => redisClient.put(any(), any(), any())).called(1);
      verify(() => redisClient.get(stateKey)).called(1);
      expect(result, equals(expectedState));
    });

    test(
        'getCachedCitiesByStates should return a list of CityModel in state of SP',
        () async {
      final state = 'SP';
      final expectedCities = [
        CityModel(name: 'Itapetininga', ibge: ''),
        CityModel(name: 'Angatuba', ibge: ''),
      ];

      final cachedCities = expectedCities.map((c) => c.toMap()).toList();

      when(() => redisClient.get('${state}_$cityKey'))
          .thenAnswer((_) async => json.encode(cachedCities));

      final cities = await dataSource.getCachedCitiesByState(state);

      verify(() => redisClient.get('${state}_$cityKey')).called(1);
      expect(cities, equals(expectedCities));
    });

    test('setCachedCitiesByStates should store the list of CityModel in cache',
        () async {
      final state = 'SP';
      final expectedCities = [
        CityModel(name: 'Itapetininga', ibge: ''),
        CityModel(name: 'Angatuba', ibge: ''),
      ];

      final cachedCities = expectedCities.map((c) => c.toMap()).toList();

      when(() => redisClient.put(any(), any(), any())).thenAnswer((_) async {});
      when(() => redisClient.get('${state}_$cityKey'))
          .thenAnswer((_) async => json.encode(cachedCities));

      await dataSource.setCachedCities(state, expectedCities);
      final result = await dataSource.getCachedCitiesByState(state);

      verify(() => redisClient.put(any(), any(), any())).called(1);
      verify(() => redisClient.get('${state}_$cityKey')).called(1);
      expect(result, equals(expectedCities));
    });
  });
}
