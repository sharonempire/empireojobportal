import 'package:empire_job/features/application/job/controllers/job_provider.dart';
import 'package:empire_job/features/application/job/models/job_model.dart';
import 'package:empire_job/features/presentation/widgets/common_textfield_widget.dart';
import 'package:empire_job/features/presentation/widgets/custom_text.dart';
import 'package:empire_job/features/presentation/widgets/multi_select_dropdown_widget.dart';
import 'package:empire_job/features/presentation/widgets/primary_button_widget.dart';
import 'package:empire_job/shared/consts/color_consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class JobDescriptionStep extends ConsumerStatefulWidget {
  final JobModel jobModel;
  final JobNotifier notifier;

  const JobDescriptionStep({
    super.key,
    required this.jobModel,
    required this.notifier,
  });

  @override
  ConsumerState<JobDescriptionStep> createState() =>
      _JobDescriptionStepState();
}

class _JobDescriptionStepState extends ConsumerState<JobDescriptionStep> {
  final _roleOverviewController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _roleOverviewController.text = widget.jobModel.roleOverview ?? '';
  }

  @override
  void dispose() {
    _roleOverviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: 'Job Description',
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: context.themeDark,
        ),
        const SizedBox(height: 32),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: 'Role Overview',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: context.themeDark,
            ),
            const SizedBox(height: 8),
            CommonTextfieldWidget(
              controller: _roleOverviewController,
              hintText: 'Enter your job description here...',
              useBorderOnly: true,
              borderColor: context.themeDivider,
              borderRadius: 8,
              onChanged: (value) => widget.notifier.setRoleOverview(value),
            ),
          ],
        ),
        const SizedBox(height: 50),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: 'Languages',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: context.themeDark,
                  ),
                  const SizedBox(height: 8),
                  MultiSelectDropdownWidget(
                    options: const [
                      'English',
                      'Spanish',
                      'French',
                      'German',
                      'Mandarin',
                      'Hindi',
                      'Other',
                    ],
                    initialSelected: widget.jobModel.languages,
                    height: 40,
                    onChanged: (values) => widget.notifier.setLanguages(values),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: 'Key Responsibilities',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: context.themeDark,
                  ),
                  const SizedBox(height: 8),
                  MultiSelectDropdownWidget(
                    options: const [
                      'Code Development',
                      'Team Management',
                      'Client Communication',
                      'Project Planning',
                      'Quality Assurance',
                      'Documentation',
                      'Other',
                    ],
                    initialSelected: widget.jobModel.keyResponsibilities,
                    height: 40,
                    onChanged: (values) =>
                        widget.notifier.setKeyResponsibilities(values),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: 'Benefits',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: context.themeDark,
                  ),
                  const SizedBox(height: 8),
                  MultiSelectDropdownWidget(
                    options: const [
                      'Health Insurance',
                      'Dental Insurance',
                      'Vision Insurance',
                      '401(k)',
                      'Paid Time Off',
                      'Flexible Schedule',
                      'Remote Work',
                      'Other',
                    ],
                    initialSelected: widget.jobModel.benefits,
                    height: 40,
                    onChanged: (values) => widget.notifier.setBenefits(values),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 48),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            PrimaryButtonWidget(
              text: 'Previous',
              showShadow: false,
              onPressed: () => widget.notifier.previousStep(),
              backgroundColor: context.themeWhite,
              textColor: context.themeDark,
              height: 40,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              borderRadius: 100,
              showBorder: true,
              borderColor: context.themeDivider,
              width: 130,
            ),
            const SizedBox(width: 16),
            PrimaryButtonWidget(
              showShadow: false,
              text: 'Next',
              onPressed: () => widget.notifier.nextStep(),
              backgroundColor: ColorConsts.black,
              textColor: ColorConsts.white,
              height: 40,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              borderRadius: 100,
              showBorder: false,
              width: 130,
            ),
          ],
        ),
      ],
    );
  }
}

