import 'package:empire_job/features/application/countries/controllers/countries_provider.dart';
import 'package:empire_job/features/application/job/controllers/job_provider.dart';
import 'package:empire_job/features/application/job/models/job_model.dart';
import 'package:empire_job/features/presentation/widgets/common_single_selection_dropdown_widget.dart';
import 'package:empire_job/features/presentation/widgets/common_textfield_widget.dart';
import 'package:empire_job/features/presentation/widgets/custom_text.dart';
import 'package:empire_job/features/presentation/widgets/primary_button_widget.dart';
import 'package:empire_job/features/presentation/widgets/range_slider_widget.dart';
import 'package:empire_job/shared/consts/color_consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LocationSalaryStep extends ConsumerStatefulWidget {
  final JobModel jobModel;
  final JobNotifier notifier;

  const LocationSalaryStep({
    super.key,
    required this.jobModel,
    required this.notifier,
  });

  @override
  ConsumerState<LocationSalaryStep> createState() => _LocationSalaryStepState();
}

class _LocationSalaryStepState extends ConsumerState<LocationSalaryStep> {
  late TextEditingController _stateController;
  late TextEditingController _cityController;
  bool _hasLoadedCountries = false;

  @override
  void initState() {
    super.initState();
    _stateController = TextEditingController(text: widget.jobModel.stateProvince);
    _cityController = TextEditingController(text: widget.jobModel.city);
    
    // Load countries when widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCountriesIfNeeded();
    });
  }


  void _loadCountriesIfNeeded() {
    final countriesState = ref.read(countriesProvider);
    if (countriesState.countries.isEmpty && !countriesState.isLoading && !_hasLoadedCountries) {
      _hasLoadedCountries = true;
      ref.read(countriesProvider.notifier).loadCountries();
    }
  }

  @override
  void dispose() {
    _stateController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final countriesState = ref.watch(countriesProvider);
    
    // Try to load countries if not loaded
    if (!_hasLoadedCountries && !countriesState.isLoading && countriesState.countries.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadCountriesIfNeeded();
      });
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: 'Location & Salary Details',
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: context.themeDark,
        ),

        const SizedBox(height: 32),

        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: 'Country',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: context.themeDark,
                  ),
                  const SizedBox(height: 8),
                  countriesState.isLoading
                      ? Container(
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border.all(color: context.themeBorderLightGrey),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: const Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                        )
                      : SingleSelectDropdownWidget(
                          options: countriesState.countries.isNotEmpty
                              ? countriesState.countries
                              : const ['Loading...'],
                          initialSelected: widget.jobModel.country,
                          hintText: 'Select country',
                          height: 40,
                          showShadow: false,
                          onChanged: (value) => widget.notifier.setCountry(value),
                          borderRadius: 100,
                        ),
                ],
              ),
            ),
            const SizedBox(width: 48),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: 'State/Province/Region',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: context.themeDark,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  CommonTextfieldWidget(
                    controller: _stateController,
                    hintText: 'Enter state/province/region',
                    height: 40,
                    borderRadius: 100,
                    useBorderOnly: true,
                    borderColor: context.themeBorderLightGrey,
                    fillColor: Colors.transparent,
                    onChanged: (value) => widget.notifier.setStateProvince(value),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 48),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: 'City',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: context.themeDark,
                  ),
                  const SizedBox(height: 8),
                  CommonTextfieldWidget(
                    controller: _cityController,
                    hintText: 'Enter city',
                    height: 40,
                    borderRadius: 100,
                    useBorderOnly: true,
                    borderColor: context.themeBorderLightGrey,
                    fillColor: Colors.transparent,
                    onChanged: (value) => widget.notifier.setCity(value),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        CustomText(
          text: 'Salary',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: context.themeDark,
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: context.themeBorderLightGrey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 40),
            child: RangeSliderWidget(
              initialMin: widget.jobModel.minSalary,
              initialMax: widget.jobModel.maxSalary,
              minValue: 0,
              maxValue: 110000,
              label: 'Salary',
              onChanged: (values) {
                widget.notifier.setSalaryRange(values.start, values.end);
              },
            ),
          ),
        ),
        const SizedBox(height: 48),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            PrimaryButtonWidget(
              text: 'Previous',
              onPressed: () => widget.notifier.previousStep(),
              backgroundColor: context.themeWhite,
              textColor: context.themeDark,
              height: 40,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              borderRadius: 100,
              showBorder: true,
              showShadow: false,
              borderColor: context.themeDivider,
              width: 130,
            ),
            const SizedBox(width: 16),
            PrimaryButtonWidget(
              text: 'Next',
              onPressed: () => widget.notifier.nextStep(),
              backgroundColor: ColorConsts.black,
              textColor: ColorConsts.white,
              height: 40,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              borderRadius: 100,
              showBorder: false,
              width: 120,
              showShadow: false,
            ),
          ],
        ),
      ],
    );
  }
}
