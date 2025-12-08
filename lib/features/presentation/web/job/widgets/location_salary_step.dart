import 'package:empire_job/features/application/job/controllers/job_provider.dart';
import 'package:empire_job/features/application/job/models/job_model.dart';
import 'package:empire_job/features/presentation/widgets/common_single_selection_dropdown_widget.dart';
import 'package:empire_job/features/presentation/widgets/custom_text.dart';
import 'package:empire_job/features/presentation/widgets/primary_button_widget.dart';
import 'package:empire_job/features/presentation/widgets/range_slider_widget.dart';
import 'package:empire_job/shared/consts/color_consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LocationSalaryStep extends ConsumerWidget {
  final JobModel jobModel;
  final JobNotifier notifier;

  const LocationSalaryStep({
    super.key,
    required this.jobModel,
    required this.notifier,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                  SingleSelectDropdownWidget(
                    options: const [
                      'United States',
                      'Canada',
                      'United Kingdom',
                      'India',
                      'Australia',
                      'Germany',
                      'France',
                      'Other',
                    ],
                    initialSelected: jobModel.country,
                    hintText: 'Select country',
                    height: 40,
                    showShadow: false,
                    onChanged: (value) => notifier.setCountry(value),
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
                  SingleSelectDropdownWidget(
                    options: const [
                      'California',
                      'New York',
                      'Texas',
                      'Florida',
                      'Illinois',
                      'Other',
                    ],
                    initialSelected: jobModel.stateProvince,
                    hintText: 'Select state/province',
                    height: 40,
                    showShadow: false,
                    onChanged: (value) => notifier.setStateProvince(value),
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
                    text: 'City',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: context.themeDark,
                  ),
                  const SizedBox(height: 8),
                  SingleSelectDropdownWidget(
                    options: const [
                      'New York',
                      'Los Angeles',
                      'Chicago',
                      'Houston',
                      'Phoenix',
                      'Philadelphia',
                      'Other',
                    ],
                    initialSelected: jobModel.city,
                    hintText: 'Select city',
                    height: 40,
                    showShadow: false,
                    onChanged: (value) => notifier.setCity(value),
                    borderRadius: 100,
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
              initialMin: jobModel.minSalary,
              initialMax: jobModel.maxSalary,
              minValue: 0,
              maxValue: 110000,
              label: 'Salary',
              onChanged: (values) {
                notifier.setSalaryRange(values.start, values.end);
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
              onPressed: () => notifier.previousStep(),
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
              onPressed: () => notifier.nextStep(),
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

