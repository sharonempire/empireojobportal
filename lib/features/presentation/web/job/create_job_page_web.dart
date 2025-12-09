import 'package:empire_job/features/application/authentication/controller/auth_controller.dart';
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
import 'package:empire_job/shared/utils/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CreateJobPageWeb extends ConsumerStatefulWidget {
  const CreateJobPageWeb({super.key});

  @override
  ConsumerState<CreateJobPageWeb> createState() => _CreateJobPageWebState();
}

class _CreateJobPageWebState extends ConsumerState<CreateJobPageWeb> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkVerificationStatus();
    });
  }

  void _checkVerificationStatus() {
    final authState = ref.read(authControllerProvider);
    if (!authState.isVerified) {
      context.showErrorSnackbar(
        'Your account must be verified to create jobs. Please wait for admin verification.',
      );
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          context.go('/dashBoard');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final jobNotifier = ref.read(jobProvider.notifier);
    final jobState = ref.watch(jobProvider);
    final jobModel = jobState.currentJob;
    final currentStep = jobModel.currentStep;

    if (!authState.isVerified) {
      return Scaffold(
        backgroundColor: context.themeScaffoldCourse,
        body: Column(
          children: [
            const CommonNavbar(),
            Expanded(
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(32),
                  margin: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: context.themeWhite,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.block,
                        size: 64,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 24),
                      CustomText(
                        text: 'Account Verification Required',
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                      const SizedBox(height: 16),
                      CustomText(
                        text:
                            'Your account must be verified before you can create jobs. Please wait for admin verification.',
                        fontSize: 16,
                        textAlign: TextAlign.center,
                        color: context.themeIconGrey,
                        maxLines: 5,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          context.go('/dashBoard');
                        },
                        child: const CustomText(
                          text: 'Go to Dashboard',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

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
