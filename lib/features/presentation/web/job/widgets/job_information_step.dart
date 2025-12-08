import 'package:empire_job/features/application/job/controllers/job_provider.dart';
import 'package:empire_job/features/application/job/models/job_model.dart';
import 'package:empire_job/features/presentation/widgets/common_single_selection_dropdown_widget.dart';
import 'package:empire_job/features/presentation/widgets/common_textfield_widget.dart';
import 'package:empire_job/features/presentation/widgets/custom_text.dart';
import 'package:empire_job/features/presentation/widgets/primary_button_widget.dart';
import 'package:empire_job/shared/consts/color_consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class JobInformationStep extends ConsumerStatefulWidget {
  final JobModel jobModel;
  final JobNotifier notifier;

  const JobInformationStep({
    super.key,
    required this.jobModel,
    required this.notifier,
  });

  @override
  ConsumerState<JobInformationStep> createState() =>
      _JobInformationStepState();
}

class _JobInformationStepState extends ConsumerState<JobInformationStep> {
  final _jobTitleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _jobTitleController.text = widget.jobModel.jobTitle ?? '';
  }

  @override
  void dispose() {
    _jobTitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: 'Job Information',
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: context.themeDark,
        ),
        const SizedBox(height: 36),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: 'Job Title / Position',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: context.themeDark,
                  ),
                  const SizedBox(height: 8),
                  CommonTextfieldWidget(
                    controller: _jobTitleController,
                    hintText: 'What is your Job title',
                    useBorderOnly: true,
                    borderColor: context.themeDivider,
                    borderRadius: 100,
                    height: 40,
                    onChanged: (value) => widget.notifier.setJobTitle(value),
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
                    text: 'Industry Type',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: context.themeDark,
                  ),
                  const SizedBox(height: 8),
                  SingleSelectDropdownWidget(
                    showShadow: false,
                    options: const [
                      'Technology',
                      'Finance',
                      'Healthcare',
                      'Education',
                      'Manufacturing',
                      'Retail',
                      'Real Estate',
                      'Other',
                    ],
                    initialSelected: widget.jobModel.jobType,
                    hintText: 'Select Your industry type',
                    height: 40,
                    onChanged: (value) => widget.notifier.setJobType(value),
                    borderRadius: 100,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 36),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: 'Work Experience',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: context.themeDark,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: SingleSelectDropdownWidget(
                          options: const [
                            '0',
                            '1',
                            '2',
                            '3',
                            '4',
                            '5',
                            '6',
                            '7',
                            '8',
                            '9',
                            '10+',
                          ],
                          initialSelected: widget.jobModel.minExperience,
                          hintText: 'Min exp',
                          height: 40,
                          onChanged: (value) =>
                              widget.notifier.setMinExperience(value),
                          borderRadius: 100,
                          showShadow: false,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SingleSelectDropdownWidget(
                          options: const [
                            '0',
                            '1',
                            '2',
                            '3',
                            '4',
                            '5',
                            '6',
                            '7',
                            '8',
                            '9',
                            '10+',
                          ],
                          initialSelected: widget.jobModel.maxExperience,
                          hintText: 'Max exp',
                          height: 40,
                          onChanged: (value) =>
                              widget.notifier.setMaxExperience(value),
                          borderRadius: 100,
                          showShadow: false,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 36),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: 'Job Type',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: context.themeDark,
                  ),
                  const SizedBox(height: 8),
                  SingleSelectDropdownWidget(
                    options: const [
                      'Full-time',
                      'Part-time',
                      'Contract',
                      'Internship',
                      'Temporary',
                    ],
                    initialSelected: widget.jobModel.industryType,
                    hintText: 'Select your Job type',
                    height: 40,
                    onChanged: (value) => widget.notifier.setIndustryType(value),
                    borderRadius: 100,
                    showShadow: false,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: 'Work Mode',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: context.themeDark,
                  ),
                  const SizedBox(height: 8),
                  SingleSelectDropdownWidget(
                    options: const ['Remote', 'On-site', 'Hybrid'],
                    initialSelected: widget.jobModel.workMode,
                    hintText: 'Select work mode',
                    height: 40,
                    showShadow: false,
                    onChanged: (value) => widget.notifier.setWorkMode(value),
                    borderRadius: 100,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 48),
        Align(
          alignment: Alignment.centerRight,
          child: PrimaryButtonWidget(
            text: 'Next',
            onPressed: () => widget.notifier.nextStep(),
            backgroundColor: ColorConsts.black,
            textColor: ColorConsts.white,
            height: 42,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            borderRadius: 100,
            showBorder: false,
            showShadow: false,
            width: 130,
          ),
        ),
      ],
    );
  }
}

