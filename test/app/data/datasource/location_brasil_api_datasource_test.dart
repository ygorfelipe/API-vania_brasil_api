import 'package:state_cities_api/app/data/datasource/location_brasil_api_data_source.dart';
import 'package:state_cities_api/app/models/city_model.dart';
import 'package:state_cities_api/app/models/state_model.dart';
import 'package:test/test.dart';

void main() {
  late LocationBrasilApiDataSource datasource;
  setUp(() => datasource = LocationBrasilApiDataSource());

  test('getState return SP', () async {
    final result = await datasource.getStates();

    expect(result, isA<List<StateModel>>());
    expect(result.isNotEmpty, true);

    final expectedStateSP = result.any((state) => state.acronym == 'SP');
    expect(expectedStateSP, true);
  });

  test('getCities return RO', () async {
    final result = await datasource.getCitiesByState('RO');

    expect(result, isA<List<CityModel>>());
    expect(result.isNotEmpty, true);

    final expectedStateSP =
        result.any((city) => city.name.toLowerCase() == 'ariquemes');
    expect(expectedStateSP, true);
  });
}
