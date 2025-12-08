import 'package:empire_job/features/application/job/controllers/job_provider.dart';
import 'package:empire_job/features/application/job/models/job_model.dart';
import 'package:empire_job/features/presentation/web/job/widgets/job_information_step.dart';
import 'package:empire_job/features/presentation/widgets/common_navbar.dart';
import 'package:empire_job/features/presentation/widgets/custom_text.dart';
import 'package:empire_job/features/presentation/widgets/responsive_horizontal_scroll.dart';
import 'package:empire_job/features/presentation/web/job/widgets/location_salary_step.dart';
import 'package:empire_job/features/presentation/web/job/widgets/job_description_step.dart';
import 'package:empire_job/features/presentation/web/job/widgets/required_qualification_step.dart';
import 'package:empire_job/features/presentation/web/job/widgets/progress_indicator_widget.dart';
import 'package:empire_job/shared/consts/color_consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateJobPageWeb extends ConsumerStatefulWidget {
  const CreateJobPageWeb({super.key});

  @override
  ConsumerState<CreateJobPageWeb> createState() => _CreateJobPageWebState();
}

class _CreateJobPageWebState extends ConsumerState<CreateJobPageWeb> {
  @override
  Widget build(BuildContext context) {
    final jobNotifier = ref.read(jobProvider.notifier);
    final jobModel = ref.watch(jobProvider);
    final currentStep = jobModel.currentStep;

    return Scaffold(
      backgroundColor: context.themeScaffoldCourse,
      body: ResponsiveHorizontalScroll(
        breakpoint: 1100,
        minWidth: 1100,
        child: Column(
          children: [
            const CommonNavbar(),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 72,
                    vertical: 46,
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 115,
                      vertical: 80,
                    ),
                    color: context.themeWhite,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: 'Create Your Job Opening',
                          fontSize: 32,
                          fontWeight: FontWeight.w500,
                          color: context.themeDark,
                        ),
                        const SizedBox(height: 8),
                        CustomText(
                          text:
                              'Provide the essential job details and reach the right candidates faster.',
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: context.themeIconGrey,
                        ),
                        const SizedBox(height: 48),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ProgressIndicatorWidget(currentStep: currentStep),
                            const SizedBox(width: 100),
                            Expanded(
                              child: _buildStepContent(
                                context,
                                currentStep,
                                jobModel,
                                jobNotifier,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepContent(
    BuildContext context,
    int currentStep,
    JobModel jobModel,
    JobNotifier jobNotifier,
  ) {
    switch (currentStep) {
      case 1:
        return JobInformationStep(jobModel: jobModel, notifier: jobNotifier);
      case 2:
        return LocationSalaryStep(jobModel: jobModel, notifier: jobNotifier);
      case 3:
        return JobDescriptionStep(jobModel: jobModel, notifier: jobNotifier);
      case 4:
        return RequiredQualificationStep(
          jobModel: jobModel,
          notifier: jobNotifier,
        );
      default:
        return const SizedBox();
    }
  }
}
