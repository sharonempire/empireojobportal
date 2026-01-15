import 'package:empire_job/features/data/network/network_calls.dart';
import 'package:empire_job/shared/supabase/keys.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final countriesRepositoryProvider = Provider<CountriesRepository>((ref) {
  final networkService = ref.watch(networkServiceProvider);
  return CountriesRepository(networkService: networkService);
});

class CountriesRepository {
  final NetworkService networkService;

  CountriesRepository({required this.networkService});

  Future<List<String>> getCountries() async {
    try {
      final countries = await networkService.pull(
        table: SupabaseTables.countries,
        orderBy: 'name',
        ascending: true,
      );

      return countries
          .map((country) => country['name']?.toString() ?? '')
          .where((name) => name.isNotEmpty)
          .toList();
    } catch (e) {
      debugPrint('Error fetching countries: $e');
      rethrow;
    }
  }
}
