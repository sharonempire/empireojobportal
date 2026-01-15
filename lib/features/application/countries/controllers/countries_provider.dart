import 'package:empire_job/features/data/countries/countries_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CountriesState {
  final List<String> countries;
  final bool isLoading;
  final String? error;

  CountriesState({
    this.countries = const [],
    this.isLoading = false,
    this.error,
  });

  CountriesState copyWith({
    List<String>? countries,
    bool? isLoading,
    String? error,
  }) {
    return CountriesState(
      countries: countries ?? this.countries,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class CountriesNotifier extends StateNotifier<CountriesState> {
  final Ref ref;

  CountriesNotifier(this.ref) : super(CountriesState());

  Future<void> loadCountries() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final countriesRepository = ref.read(countriesRepositoryProvider);
      final countries = await countriesRepository.getCountries();

      state = state.copyWith(
        countries: countries,
        isLoading: false,
        error: null,
      );
    } catch (e) {
      debugPrint('Error loading countries: $e');
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}

final countriesProvider =
    StateNotifierProvider<CountriesNotifier, CountriesState>((ref) {
  return CountriesNotifier(ref);
});
