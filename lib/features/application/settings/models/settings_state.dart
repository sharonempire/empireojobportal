class SettingsState {
  final int selectedTabIndex;
  final bool isLoading;
  final String finderType;

  SettingsState({
    required this.selectedTabIndex,
    this.isLoading = false,
    this.finderType = 'course',
  });

  SettingsState copyWith({
    int? selectedTabIndex,
    bool? isLoading,
    String? finderType,
  }) {
    return SettingsState(
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
      isLoading: isLoading ?? this.isLoading,
      finderType: finderType ?? this.finderType,
    );
  }
}