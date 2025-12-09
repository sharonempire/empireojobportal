import 'package:empire_job/features/application/job/controllers/job_provider.dart';
import 'package:empire_job/features/application/job/models/job_model.dart';
import 'package:empire_job/features/presentation/widgets/common_single_selection_dropdown_widget.dart';
import 'package:empire_job/features/presentation/widgets/custom_text.dart';
import 'package:empire_job/features/presentation/widgets/multi_select_dropdown_widget.dart';
import 'package:empire_job/features/presentation/widgets/primary_button_widget.dart';
import 'package:empire_job/shared/consts/color_consts.dart';
import 'package:empire_job/shared/utils/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class RequiredQualificationStep extends ConsumerWidget {
  final JobModel jobModel;
  final JobNotifier notifier;

  const RequiredQualificationStep({
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
          text: 'Required Qualification',
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
                    text: 'Education',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: context.themeDark,
                  ),
                  const SizedBox(height: 8),
                  SingleSelectDropdownWidget(
                    showShadow: false,
                    options: const [
                      'High School',
                      'Associate Degree',
                      'Bachelor\'s Degree',
                      'Master\'s Degree',
                      'PhD',
                      'Other',
                    ],
                    initialSelected: jobModel.education,
                    hintText: 'Select your education',
                    height: 40,
                    onChanged: (value) => notifier.setEducation(value),
                    borderRadius: 100,
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
                    text: 'Skills',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: context.themeDark,
                  ),
                  const SizedBox(height: 8),
                  MultiSelectDropdownWidget(
                    options: const [
                      'JavaScript',
                      'Python',
                      'Java',
                      'React',
                      'Node.js',
                      'SQL',
                      'Communication',
                      'Leadership',
                      'Project Management',
                      'Other',
                    ],
                    initialSelected: jobModel.skills,
                    height: 40,
                    onChanged: (values) => notifier.setSkills(values),
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
              showShadow: false,
              text: 'Previous',
              onPressed: () => notifier.previousStep(),
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
              text: 'Submit',
              onPressed: () async {
                try {
                  await notifier.submitJob();
                  if (context.mounted) {
                    context.showSuccessSnackbar('Job created successfully!');
                    Future.delayed(const Duration(milliseconds: 500), () {
                      if (context.mounted) {
                        context.go('/dashBoard');
                      }
                    });
                  }
                } catch (e) {
                  if (context.mounted) {
                    context.showErrorSnackbar(e.toString());
                  }
                }
              },
              backgroundColor: ColorConsts.black,
              textColor: ColorConsts.white,
              height: 40,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              borderRadius: 100,
              showBorder: false,
              showShadow: false,
              width: 130,
            ),
          ],
        ),
      ],
    );
  }
}

