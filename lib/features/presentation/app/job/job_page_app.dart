import 'package:empire_job/features/application/job/controllers/job_provider.dart';
import 'package:empire_job/features/presentation/widgets/common_textfield_widget.dart';
import 'package:empire_job/features/presentation/widgets/custom_text.dart';
import 'package:empire_job/features/presentation/widgets/multi_select_dropdown_widget.dart';
import 'package:empire_job/features/presentation/widgets/primary_button_widget.dart';
import 'package:empire_job/shared/consts/color_consts.dart';
import 'package:empire_job/shared/utils/bottonavigationbar.dart';
import 'package:empire_job/shared/utils/responsive.dart';
import 'package:empire_job/shared/widgets/common_app_bar.dart';
import 'package:empire_job/shared/widgets/description_textfield_widget.dart';
import 'package:empire_job/shared/widgets/exit_confirmation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class JobPageApp extends ConsumerStatefulWidget {
  const JobPageApp({super.key});

  @override
  ConsumerState<JobPageApp> createState() => _JobPageAppState();
}

class _JobPageAppState extends ConsumerState<JobPageApp> {
  final int _totalSteps = 4;
  final _formKey = GlobalKey<FormState>();

  // Step 1 Controllers
  final _jobTitleController = TextEditingController();

  // Step 3 Controllers
  final _roleOverviewController = TextEditingController();

  // Dropdown options
  final List<String> _industryTypes = [
    'Information Technology',
    'Healthcare',
    'Finance',
    'Education',
    'Manufacturing',
    'Retail',
    'Other',
  ];

  final List<String> _jobTypes = [
    'Full-time',
    'Part-time',
    'Contract',
    'Freelance',
    'Internship',
  ];

  final List<String> _workModes = ['Remote', 'On-site', 'Hybrid'];

  final List<String> _experienceOptions = [
    '0 years',
    '1 year',
    '2 years',
    '3 years',
    '4 years',
    '5+ years',
  ];

  final List<String> _countries = [
    'India',
    'United States',
    'Canada',
    'United Kingdom',
    'Australia',
    'Germany',
    'UAE',
  ];

  final List<String> _states = [
    'Maharashtra',
    'Karnataka',
    'Tamil Nadu',
    'Delhi',
    'Gujarat',
    'California',
    'Texas',
  ];

  final List<String> _cities = [
    'Mumbai',
    'Bangalore',
    'Chennai',
    'Delhi',
    'Hyderabad',
    'Pune',
  ];

  final List<String> _languages = [
    'English',
    'Spanish',
    'French',
    'German',
    'Mandarin',
    'Hindi',
    'Other',
  ];

  final List<String> _responsibilities = [
    'Code Development',
    'Team Management',
    'Client Communication',
    'Project Planning',
    'Quality Assurance',
    'Documentation',
    'Other',
  ];

  final List<String> _benefits = [
    'Health Insurance',
    'Dental Insurance',
    'Vision Insurance',
    '401(k)',
    'Paid Time Off',
    'Flexible Schedule',
    'Remote Work',
    'Other',
  ];

  final List<String> _educationOptions = [
    'High School',
    'Bachelor\'s Degree',
    'Master\'s Degree',
    'PhD',
    'Diploma',
  ];

  final List<String> _skillsOptions = [
    'JavaScript',
    'Python',
    'Java',
    'Flutter',
    'React',
    'Node.js',
    'SQL',
    'AWS',
    'TypeScript',
    'Dart',
    'C++',
    'Go',
    'Kotlin',
    'Swift',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    // Reset the job form when entering the page
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(jobProvider.notifier).resetJob();
    });
  }

  @override
  void dispose() {
    _jobTitleController.dispose();
    _roleOverviewController.dispose();
    super.dispose();
  }

  bool _validateStep(int step) {
    final jobState = ref.read(jobProvider);
    final job = jobState.currentJob;

    switch (step) {
      case 1:
        if (_jobTitleController.text.trim().isEmpty) {
          _showError('Please enter job title');
          return false;
        }
        if (job.industryType == null || job.industryType!.isEmpty) {
          _showError('Please select industry type');
          return false;
        }
        if (job.jobType == null || job.jobType!.isEmpty) {
          _showError('Please select job type');
          return false;
        }
        if (job.workMode == null || job.workMode!.isEmpty) {
          _showError('Please select work mode');
          return false;
        }
        if (job.minExperience == null || job.minExperience!.isEmpty) {
          _showError('Please select minimum experience');
          return false;
        }
        if (job.maxExperience == null || job.maxExperience!.isEmpty) {
          _showError('Please select maximum experience');
          return false;
        }
        return true;
      case 2:
        if (job.country == null || job.country!.isEmpty) {
          _showError('Please select country');
          return false;
        }
        if (job.stateProvince == null || job.stateProvince!.isEmpty) {
          _showError('Please select state/province');
          return false;
        }
        if (job.city == null || job.city!.isEmpty) {
          _showError('Please select city');
          return false;
        }
        if (job.minSalary <= 0 || job.maxSalary <= 0) {
          _showError('Please set salary range');
          return false;
        }
        if (job.minSalary > job.maxSalary) {
          _showError('Minimum salary cannot be greater than maximum salary');
          return false;
        }
        return true;
      case 3:
        if (_roleOverviewController.text.trim().isEmpty) {
          _showError('Please enter role overview');
          return false;
        }
        if (job.languages.isEmpty) {
          _showError('Please select at least one language');
          return false;
        }
        if (job.keyResponsibilities.isEmpty) {
          _showError('Please select at least one key responsibility');
          return false;
        }
        if (job.benefits.isEmpty) {
          _showError('Please select at least one benefit');
          return false;
        }
        return true;
      case 4:
        if (job.education == null || job.education!.isEmpty) {
          _showError('Please select education requirement');
          return false;
        }
        if (job.skills.isEmpty) {
          _showError('Please select at least one skill');
          return false;
        }
        return true;
      default:
        return true;
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: ColorConsts.textColorRed,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _nextStep() {
    final jobNotifier = ref.read(jobProvider.notifier);
    final currentStep = jobNotifier.currentStep;

    // Validate form fields first (for text fields)
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Validate current step before proceeding (for dropdowns and other fields)
    if (!_validateStep(currentStep)) {
      return;
    }

    if (currentStep < _totalSteps) {
      jobNotifier.nextStep();
    } else {
      // Submit the form
      _submitJob();
    }
  }

  Future<void> _submitJob() async {
    try {
      await ref.read(jobProvider.notifier).submitJob();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Job posted successfully!')),
        );
        context.goNamed('dashboard');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: ColorConsts.textColorRed,
          ),
        );
      }
    }
  }

  void _onNavTap(int index) {
    switch (index) {
      case 0:
        context.goNamed('dashboard');
        break;
      case 1:
        // Already on jobs
        break;
      case 2:
        context.goNamed('settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final jobState = ref.watch(jobProvider);
    final currentStep = jobState.currentJob.currentStep;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        final shouldExit = await showExitConfirmationDialog(context);
        if (shouldExit && context.mounted) {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        backgroundColor: ColorConsts.lightGreyBackground,
        appBar: CommonAppBar(
          showProfile: true,
          profileName: 'Create Job',
          profileImageUrl: null,
          showNotification: true,
          onNotificationPressed: () {
            context.pushNamed('notifications');
          },
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(context.rSpacing(20)),
            child: Container(
              margin: EdgeInsets.only(bottom: context.rSpacing(12)),
              padding: EdgeInsets.all(context.rSpacing(12)),
              decoration: BoxDecoration(
                color: ColorConsts.white,
                borderRadius: BorderRadius.circular(context.rSpacing(8)),
                border: Border.all(color: ColorConsts.lightGrey, width: 1),
              ),
              child: Padding(
                padding: EdgeInsets.all(context.rSpacing(8)),
                child: Column(
                  children: [
                    // Content
                    Expanded(
                      child: Form(
                        key: _formKey,
                        child: SingleChildScrollView(
                          padding: EdgeInsets.all(context.rSpacing(16)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title Section
                              CustomText(
                                text: 'Create Your Job Opening',
                                fontSize: context.rFontSize(16),
                                fontWeight: FontWeight.bold,
                                color: ColorConsts.black,
                              ),
                              SizedBox(height: context.rSpacing(8)),
                              CustomText(
                                text:
                                    'Provide the essential job details and reach the right candidates faster.',
                                fontSize: context.rFontSize(12),
                                color: ColorConsts.textColor,
                              ),
                              SizedBox(height: context.rSpacing(16)),
                              // Progress Bar
                              _buildProgressBar(currentStep),
                              SizedBox(height: context.rSpacing(24)),
                              // Step Content
                              _buildStepContent(currentStep),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: context.rSpacing(24)),

                    // Next/Submit Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (currentStep > 1)
                          Padding(
                            padding: EdgeInsets.only(
                              right: context.rSpacing(8),
                            ),
                            child: PrimaryButtonWidget(
                              text: 'Back',
                              onPressed: () {
                                ref.read(jobProvider.notifier).previousStep();
                              },
                              backgroundColor: ColorConsts.white,
                              textColor: ColorConsts.black,
                              showBorder: true,
                              showShadow: false,
                              height: context.rHeight(30),
                              width: context.rSpacing(80),
                              borderRadius: 26,
                              fontSize: context.rFontSize(12),
                            ),
                          ),
                        jobState.isSubmittingJob
                            ? const CircularProgressIndicator(
                                color: ColorConsts.black,
                              )
                            : PrimaryButtonWidget(
                                text: currentStep == _totalSteps
                                    ? 'Submit'
                                    : 'Next',
                                onPressed: _nextStep,
                                backgroundColor: ColorConsts.black,
                                textColor: ColorConsts.white,
                                showBorder: false,
                                showShadow: false,
                                height: context.rHeight(30),
                                width: context.rSpacing(90),
                                borderRadius: 26,
                                fontSize: context.rFontSize(12),
                              ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: AppBottomNavigationBar(
          currentIndex: 1,
          onTap: _onNavTap,
        ),
      ),
    );
  }

  Widget _buildProgressBar(int currentStep) {
    // Calculate progress: step 1 = 0%, step 2 = 25%, step 3 = 50%, step 4 = 75%
    final progress = (currentStep - 1) / _totalSteps;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LinearProgressIndicator(
          value: progress,
          backgroundColor: ColorConsts.lightGrey,
          valueColor: const AlwaysStoppedAnimation<Color>(
            ColorConsts.textColorRed,
          ),
          minHeight: 4,
          borderRadius: BorderRadius.circular(2),
        ),
        SizedBox(height: context.rSpacing(6)),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CustomText(
              text: 'Step $currentStep of $_totalSteps',
              fontSize: context.rFontSize(10),
              color: ColorConsts.textColor,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStepContent(int currentStep) {
    switch (currentStep) {
      case 1:
        return _buildStep1();
      case 2:
        return _buildStep2();
      case 3:
        return _buildStep3();
      case 4:
        return _buildStep4();
      default:
        return const SizedBox();
    }
  }

  // Step 1: Job Information
  Widget _buildStep1() {
    final jobState = ref.watch(jobProvider);
    final job = jobState.currentJob;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: CustomText(
            text: 'Job Information',
            fontSize: context.rFontSize(14),
            fontWeight: FontWeight.bold,
            color: ColorConsts.black,
          ),
        ),
        SizedBox(height: context.rSpacing(24)),
        _buildFieldLabel('Job Title / Position', isRequired: true),
        SizedBox(height: context.rSpacing(8)),
        CommonTextfieldWidget(
          controller: _jobTitleController,
          hintText: 'Ex- Data Analyst',
          hintFontSize: context.rFontSize(10),
          useBorderOnly: true,
          height: context.rHeight(30),
          borderRadius: 8,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Job title is required';
            }
            return null;
          },
          onChanged: (value) {
            ref.read(jobProvider.notifier).setJobTitle(value);
          },
        ),
        SizedBox(height: context.rSpacing(20)),
        _buildFieldLabel('Industry Type', isRequired: true),
        SizedBox(height: context.rSpacing(8)),
        _buildDropdown(
          value: job.industryType,
          hint: 'Information Technology',
          items: _industryTypes,
          onChanged: (val) {
            ref.read(jobProvider.notifier).setIndustryType(val);
          },
        ),
        SizedBox(height: context.rSpacing(20)),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFieldLabel('Job Type', isRequired: true),
                  SizedBox(height: context.rSpacing(8)),
                  _buildDropdown(
                    value: job.jobType,
                    hint: 'Full-time',
                    items: _jobTypes,
                    onChanged: (val) {
                      ref.read(jobProvider.notifier).setJobType(val);
                    },
                  ),
                ],
              ),
            ),
            SizedBox(width: context.rSpacing(16)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFieldLabel('Work Mode', isRequired: true),
                  SizedBox(height: context.rSpacing(8)),
                  _buildDropdown(
                    value: job.workMode,
                    hint: 'Hybrid',
                    items: _workModes,
                    onChanged: (val) {
                      ref.read(jobProvider.notifier).setWorkMode(val);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: context.rSpacing(20)),
        _buildFieldLabel('Work Experience', isRequired: true),
        SizedBox(height: context.rSpacing(8)),
        Row(
          children: [
            Expanded(
              child: _buildDropdown(
                value: job.minExperience,
                hint: 'Min-exp',
                items: _experienceOptions,
                onChanged: (val) {
                  ref.read(jobProvider.notifier).setMinExperience(val);
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.rSpacing(12)),
              child: CustomText(
                text: 'to',
                fontSize: context.rFontSize(14),
                color: ColorConsts.textColor,
              ),
            ),
            Expanded(
              child: _buildDropdown(
                value: job.maxExperience,
                hint: 'Max-exp',
                items: _experienceOptions,
                onChanged: (val) {
                  ref.read(jobProvider.notifier).setMaxExperience(val);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Step 2: Location & Salary Details
  Widget _buildStep2() {
    final jobState = ref.watch(jobProvider);
    final job = jobState.currentJob;
    final minSalary = job.minSalary;
    final maxSalary = job.maxSalary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: CustomText(
            text: 'Location & Salary Details',
            fontSize: context.rFontSize(14),
            fontWeight: FontWeight.bold,
            color: ColorConsts.black,
          ),
        ),
        SizedBox(height: context.rSpacing(24)),
        _buildFieldLabel('Country', isRequired: true),
        SizedBox(height: context.rSpacing(8)),
        _buildDropdown(
          value: job.country,
          hint: 'Select your country',
          items: _countries,
          onChanged: (val) {
            ref.read(jobProvider.notifier).setCountry(val);
          },
        ),
        SizedBox(height: context.rSpacing(20)),
        _buildFieldLabel('State / Province / Region', isRequired: true),
        SizedBox(height: context.rSpacing(8)),
        _buildDropdown(
          value: job.stateProvince,
          hint: 'Select your state',
          items: _states,
          onChanged: (val) {
            ref.read(jobProvider.notifier).setStateProvince(val);
          },
        ),
        SizedBox(height: context.rSpacing(20)),
        _buildFieldLabel('City', isRequired: true),
        SizedBox(height: context.rSpacing(8)),
        _buildDropdown(
          value: job.city,
          hint: 'Select your city',
          items: _cities,
          onChanged: (val) {
            ref.read(jobProvider.notifier).setCity(val);
          },
        ),
        SizedBox(height: context.rSpacing(20)),
        _buildFieldLabel('Salary', isRequired: true),
        SizedBox(height: context.rSpacing(16)),
        Container(
          height: context.rHeight(95),
          padding: EdgeInsets.symmetric(
            horizontal: context.rSpacing(16),
            vertical: context.rSpacing(12),
          ),
          decoration: BoxDecoration(
            border: Border.all(color: ColorConsts.lightGrey),
            borderRadius: BorderRadius.circular(context.rSpacing(8)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: 'Salary',
                    fontSize: context.rFontSize(11),
                    color: ColorConsts.textColor,
                  ),
                  CustomText(
                    text:
                        '\$${minSalary.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')} - '
                        '\$${maxSalary.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
                    fontSize: context.rFontSize(11),
                    fontWeight: FontWeight.w500,
                    color: ColorConsts.black,
                  ),
                ],
              ),
              SizedBox(
                height: context.rSpacing(24),
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 3,
                    activeTrackColor: ColorConsts.textColorRed,
                    inactiveTrackColor: ColorConsts.lightGrey,
                    thumbColor: ColorConsts.textColorRed,
                    overlayColor: ColorConsts.textColorRed.withOpacity(0.1),
                    rangeThumbShape: RoundRangeSliderThumbShape(
                      enabledThumbRadius: context.rSpacing(7),
                    ),
                  ),
                  child: RangeSlider(
                    values: RangeValues(minSalary, maxSalary),
                    min: 0,
                    max: 150000,
                    onChanged: (values) {
                      ref
                          .read(jobProvider.notifier)
                          .setSalaryRange(values.start, values.end);
                    },
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: '\$0',
                    fontSize: context.rFontSize(10),
                    color: ColorConsts.textColor,
                  ),
                  CustomText(
                    text: '\$150,000',
                    fontSize: context.rFontSize(10),
                    color: ColorConsts.textColor,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Step 3: Job Description
  Widget _buildStep3() {
    final jobState = ref.watch(jobProvider);
    final job = jobState.currentJob;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: CustomText(
            text: 'Job Description',
            fontSize: context.rFontSize(16),
            fontWeight: FontWeight.bold,
            color: ColorConsts.black,
          ),
        ),
        SizedBox(height: context.rSpacing(24)),
        DescriptionTextfieldWidget(
          controller: _roleOverviewController,
          labelText: 'Role Overview',
          hintText: 'Enter your job description here...',
          isRequired: true,
          height: context.rHeight(120),
          maxLines: null,
          minLines: 4,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Role overview is required';
            }
            return null;
          },
          onChanged: (value) {
            ref.read(jobProvider.notifier).setRoleOverview(value);
          },
        ),
        SizedBox(height: context.rSpacing(16)),
        _buildFieldLabel('Languages', isRequired: true),
        SizedBox(height: context.rSpacing(8)),
        MultiSelectDropdownWidget(
          options: _languages,
          initialSelected: job.languages,
          height: context.rHeight(35),
          onChanged: (values) {
            ref.read(jobProvider.notifier).setLanguages(values);
          },
        ),
        SizedBox(height: context.rSpacing(16)),
        _buildFieldLabel('Key Responsibilities', isRequired: true),
        SizedBox(height: context.rSpacing(8)),
        MultiSelectDropdownWidget(
          options: _responsibilities,
          initialSelected: job.keyResponsibilities,
          height: context.rHeight(35),
          onChanged: (values) {
            ref.read(jobProvider.notifier).setKeyResponsibilities(values);
          },
        ),
        SizedBox(height: context.rSpacing(16)),
        _buildFieldLabel('Benefits', isRequired: true),
        SizedBox(height: context.rSpacing(8)),
        MultiSelectDropdownWidget(
          options: _benefits,
          initialSelected: job.benefits,
          height: context.rHeight(35),
          onChanged: (values) {
            ref.read(jobProvider.notifier).setBenefits(values);
          },
        ),
      ],
    );
  }

  // Step 4: Required Qualifications
  Widget _buildStep4() {
    final jobState = ref.watch(jobProvider);
    final job = jobState.currentJob;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: CustomText(
            text: 'Required Qualifications',
            fontSize: context.rFontSize(16),
            fontWeight: FontWeight.bold,
            color: ColorConsts.black,
          ),
        ),
        SizedBox(height: context.rSpacing(24)),
        _buildFieldLabel('Education', isRequired: true),
        SizedBox(height: context.rSpacing(8)),
        _buildDropdown(
          value: job.education,
          hint: 'Select your education',
          items: _educationOptions,
          onChanged: (val) {
            ref.read(jobProvider.notifier).setEducation(val);
          },
        ),
        SizedBox(height: context.rSpacing(16)),
        _buildFieldLabel('Skills', isRequired: true),
        SizedBox(height: context.rSpacing(8)),
        MultiSelectDropdownWidget(
          options: _skillsOptions,
          initialSelected: job.skills,
          height: context.rHeight(35),
          onChanged: (values) {
            ref.read(jobProvider.notifier).setSkills(values);
          },
        ),
      ],
    );
  }

  Widget _buildFieldLabel(String label, {bool isRequired = false}) {
    return Row(
      children: [
        CustomText(
          text: label,
          fontSize: context.rFontSize(12),
          fontWeight: FontWeight.w500,
          color: ColorConsts.black,
        ),
        if (isRequired) ...[
          SizedBox(width: context.rSpacing(4)),
          CustomText(
            text: '*',
            fontSize: context.rFontSize(12),
            fontWeight: FontWeight.w500,
            color: ColorConsts.textColorRed,
          ),
        ],
      ],
    );
  }

  Widget _buildDropdown({
    String? value,
    required String hint,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      height: context.rHeight(35),
      padding: EdgeInsets.symmetric(horizontal: context.rSpacing(12)),
      decoration: BoxDecoration(
        border: Border.all(color: ColorConsts.lightGrey),
        borderRadius: BorderRadius.circular(context.rSpacing(20)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: CustomText(
            text: hint,
            fontSize: context.rFontSize(10),
            color: ColorConsts.iconGrey,
          ),
          isExpanded: true,
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: ColorConsts.iconGrey,
            size: context.rIconSize(20),
          ),
          items: items
              .map(
                (item) => DropdownMenuItem<String>(
                  value: item,
                  child: CustomText(
                    text: item,
                    fontSize: context.rFontSize(10),
                    color: ColorConsts.black,
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
