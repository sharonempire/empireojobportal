import 'package:empire_job/features/presentation/widgets/common_textfield_widget.dart';
import 'package:empire_job/features/presentation/widgets/custom_text.dart';
import 'package:empire_job/features/presentation/widgets/primary_button_widget.dart';
import 'package:empire_job/shared/consts/color_consts.dart';
import 'package:empire_job/shared/utils/bottonavigationbar.dart';
import 'package:empire_job/shared/utils/responsive.dart';
import 'package:empire_job/shared/widgets/common_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class JobPageApp extends StatefulWidget {
  const JobPageApp({super.key});

  @override
  State<JobPageApp> createState() => _JobPageAppState();
}

class _JobPageAppState extends State<JobPageApp> {
  int _currentStep = 0;
  final int _totalSteps = 4;

  // Step 1 Controllers
  final _jobTitleController = TextEditingController();
  String? _selectedIndustryType;
  String? _selectedJobType;
  String? _selectedWorkMode;
  String? _selectedMinExp;
  String? _selectedMaxExp;

  // Step 2 Controllers
  String? _selectedCountry;
  String? _selectedState;
  String? _selectedCity;
  RangeValues _salaryRange = const RangeValues(40000, 80000);

  // Step 3 Controllers
  final _roleOverviewController = TextEditingController();
  String? _selectedLanguages;
  String? _selectedResponsibilities;
  String? _selectedBenefits;

  // Step 4 Controllers
  String? _selectedEducation;
  String? _selectedSkills;

  @override
  void dispose() {
    _jobTitleController.dispose();
    _roleOverviewController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      setState(() {
        _currentStep++;
      });
    } else {
      // Submit the form
      _submitJob();
    }
  }

  void _submitJob() {
    // Handle job submission
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Job posted successfully!')));
    context.goNamed('dashboard');
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
    return Scaffold(
      backgroundColor: ColorConsts.lightGreyBackground,
      appBar: CommonAppBar(
        showProfile: true,
        profileName: 'Michael Roberts',
        profileImageUrl:
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&h=100&fit=crop',
        showNotification: true,
        onNotificationPressed: () {
          // Handle notification tap
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
                          _buildProgressBar(),
                          SizedBox(height: context.rSpacing(24)),
                          // Step Content
                          _buildStepContent(),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: context.rSpacing(24)),

                  // Next/Submit Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      PrimaryButtonWidget(
                        text: _currentStep == _totalSteps - 1
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
    );
  }

  Widget _buildProgressBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LinearProgressIndicator(
          value: (_currentStep + 1) / _totalSteps,
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
              text: 'Step ${_currentStep + 1} of $_totalSteps',
              fontSize: context.rFontSize(10),
              color: ColorConsts.textColor,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildStep1();
      case 1:
        return _buildStep2();
      case 2:
        return _buildStep3();
      case 3:
        return _buildStep4();
      default:
        return const SizedBox();
    }
  }

  // Step 1: Job Information
  Widget _buildStep1() {
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
        _buildFieldLabel('Job Title / Position'),
        SizedBox(height: context.rSpacing(8)),
        CommonTextfieldWidget(
          controller: _jobTitleController,
          hintText: 'Ex- Data Analyst',
          hintFontSize: context.rFontSize(10),
          useBorderOnly: true,
          height: context.rHeight(30),
          borderRadius: 8,
        ),
        SizedBox(height: context.rSpacing(20)),
        _buildFieldLabel('Industry Type'),
        SizedBox(height: context.rSpacing(8)),
        _buildDropdown(
          value: _selectedIndustryType,
          hint: 'Information Technology',
          onChanged: (val) => setState(() => _selectedIndustryType = val),
        ),
        SizedBox(height: context.rSpacing(20)),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFieldLabel('Job Type'),
                  SizedBox(height: context.rSpacing(8)),
                  _buildDropdown(
                    value: _selectedJobType,
                    hint: 'Full-time',
                    onChanged: (val) => setState(() => _selectedJobType = val),
                  ),
                ],
              ),
            ),
            SizedBox(width: context.rSpacing(16)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFieldLabel('Work Mode'),
                  SizedBox(height: context.rSpacing(8)),
                  _buildDropdown(
                    value: _selectedWorkMode,
                    hint: 'Hybrid',
                    onChanged: (val) => setState(() => _selectedWorkMode = val),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: context.rSpacing(20)),
        _buildFieldLabel('Work Experience'),
        SizedBox(height: context.rSpacing(8)),
        Row(
          children: [
            Expanded(
              child: _buildDropdown(
                value: _selectedMinExp,
                hint: 'Min-exp',
                onChanged: (val) => setState(() => _selectedMinExp = val),
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
                value: _selectedMaxExp,
                hint: 'Max-exp',
                onChanged: (val) => setState(() => _selectedMaxExp = val),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Step 2: Location & Salary Details
  Widget _buildStep2() {
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
        _buildFieldLabel('Country'),
        SizedBox(height: context.rSpacing(8)),
        _buildDropdown(
          value: _selectedCountry,
          hint: 'Select your country',
          onChanged: (val) => setState(() => _selectedCountry = val),
        ),
        SizedBox(height: context.rSpacing(20)),
        _buildFieldLabel('State / Province / Region'),
        SizedBox(height: context.rSpacing(8)),
        _buildDropdown(
          value: _selectedState,
          hint: 'Select your state',
          onChanged: (val) => setState(() => _selectedState = val),
        ),
        SizedBox(height: context.rSpacing(20)),
        _buildFieldLabel('City'),
        SizedBox(height: context.rSpacing(8)),
        _buildDropdown(
          value: _selectedCity,
          hint: 'Select your city',
          onChanged: (val) => setState(() => _selectedCity = val),
        ),
        SizedBox(height: context.rSpacing(20)),
        _buildFieldLabel('Salary'),
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
                        '\$${_salaryRange.start.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')} - '
                        '\$${_salaryRange.end.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
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
                    values: _salaryRange,
                    min: 0,
                    max: 150000,
                    onChanged: (values) {
                      setState(() {
                        _salaryRange = values;
                      });
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
        _buildFieldLabel('Role Overview'),
        SizedBox(height: context.rSpacing(8)),
        CommonTextfieldWidget(
          controller: _roleOverviewController,
          hintText: 'Enter you job description here...',
          useBorderOnly: true,
          hintFontSize: context.rFontSize(10),
          height: context.rHeight(110),
          borderRadius: 8,
          maxLines: 4,
        ),
        SizedBox(height: context.rSpacing(10)),
        _buildFieldLabel('Languages'),
        SizedBox(height: context.rSpacing(8)),
        _buildDropdown(
          value: _selectedLanguages,
          hint: 'Select your locations',
          onChanged: (val) => setState(() => _selectedLanguages = val),
        ),
        SizedBox(height: context.rSpacing(20)),
        _buildFieldLabel('Key Responsibilities'),
        SizedBox(height: context.rSpacing(8)),
        _buildDropdown(
          value: _selectedResponsibilities,
          hint: 'Select your responsibilities',
          onChanged: (val) => setState(() => _selectedResponsibilities = val),
        ),
        SizedBox(height: context.rSpacing(20)),
        _buildFieldLabel('Benefits'),
        SizedBox(height: context.rSpacing(8)),
        _buildDropdown(
          value: _selectedBenefits,
          hint: 'Select your benefits',
          onChanged: (val) => setState(() => _selectedBenefits = val),
        ),
      ],
    );
  }

  // Step 4: Required Qualifications
  Widget _buildStep4() {
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
        _buildFieldLabel('Education'),
        SizedBox(height: context.rSpacing(8)),
        _buildDropdown(
          value: _selectedEducation,
          hint: 'Select your education',
          onChanged: (val) => setState(() => _selectedEducation = val),
        ),
        SizedBox(height: context.rSpacing(20)),
        _buildFieldLabel('Skills'),
        SizedBox(height: context.rSpacing(8)),
        _buildDropdown(
          value: _selectedSkills,
          hint: 'Select your skills',
          onChanged: (val) => setState(() => _selectedSkills = val),
        ),
      ],
    );
  }

  Widget _buildFieldLabel(String label) {
    return CustomText(
      text: label,
      fontSize: context.rFontSize(12),
      fontWeight: FontWeight.w500,
      color: ColorConsts.black,
    );
  }

  Widget _buildDropdown({
    String? value,
    required String hint,
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
          items: const [],
          onChanged: onChanged,
        ),
      ),
    );
  }
}
