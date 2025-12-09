class SettingsState {
  final int selectedTabIndex;
  final bool isLoading;
  final String finderType;
  final String? companyName;
  final String? companyEmail;
  final String? companyWebsite;
  final String? companyAddress;
  final bool isLoadingCompanyData;

  SettingsState({
    required this.selectedTabIndex,
    this.isLoading = false,
    this.finderType = 'course',
    this.companyName,
    this.companyEmail,
    this.companyWebsite,
    this.companyAddress,
    this.isLoadingCompanyData = false,
  });

  SettingsState copyWith({
    int? selectedTabIndex,
    bool? isLoading,
    String? finderType,
    String? companyName,
    String? companyEmail,
    String? companyWebsite,
    String? companyAddress,
    bool? isLoadingCompanyData,
  }) {
    return SettingsState(
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
      isLoading: isLoading ?? this.isLoading,
      finderType: finderType ?? this.finderType,
      companyName: companyName ?? this.companyName,
      companyEmail: companyEmail ?? this.companyEmail,
      companyWebsite: companyWebsite ?? this.companyWebsite,
      companyAddress: companyAddress ?? this.companyAddress,
      isLoadingCompanyData: isLoadingCompanyData ?? this.isLoadingCompanyData,
    );
  }
}