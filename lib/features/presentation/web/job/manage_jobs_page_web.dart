import 'package:empire_job/features/presentation/widgets/common_navbar.dart';
import 'package:empire_job/features/presentation/widgets/custom_text.dart';
import 'package:empire_job/features/presentation/widgets/responsive_horizontal_scroll.dart';
import 'package:empire_job/shared/consts/color_consts.dart';
import 'package:flutter/material.dart';

class ManageJobsPageWeb extends StatelessWidget {
  const ManageJobsPageWeb({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.themeScaffoldCourse,
      body: Column(
        children: [
          const CommonNavbar(),
          Expanded(
            child: ResponsiveHorizontalScroll(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 170,
                    vertical: 65,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: 'Manage Your Posted Jobs with Ease',
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                          ),
                          const SizedBox(height: 20),
                          CustomText(
                            text:
                                'View and track all your active, closed, and draft job postings in one place. Monitor performance, check application counts, and make quick updates anytime.',
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: context.themeIconGrey,
                          ),
                        ],
                      ),
                      const SizedBox(height: 50),
                      CustomText(
                        text: 'View Posted Jobs',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      const SizedBox(height: 10),
                      Divider(color: context.themeDivider),
                      const SizedBox(height: 10),
                      ..._buildJobListings(context),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildJobListings(BuildContext context) {
    final jobs = [
      {
        'company': 'Accenture',
        'companyInitial': 'A',
        'jobTitle': 'Data Analyst',
        'location': 'Canada',
        'description':
            'Amazon is seeking a Cloud Support Associate to provide technical assistance to global customers using AWS services.',
        'status': 'Active',
        'postedDate': '12 Dec 2025',
      },
      {
        'company': 'Nike',
        'companyInitial': 'N',
        'jobTitle': 'Software Engineer',
        'location': 'United States',
        'description':
            'Nike is looking for a talented Software Engineer to join our innovative team and help build cutting-edge applications.',
        'status': 'Closed',
        'postedDate': '10 Dec 2025',
      },
      {
        'company': 'Amazon',
        'companyInitial': 'a',
        'jobTitle': 'Cloud Support Associate',
        'location': 'United States',
        'description':
            'Amazon is seeking a Cloud Support Associate to provide technical assistance to global customers using AWS services.',
        'status': 'Closed',
        'postedDate': '8 Dec 2025',
      },
      {
        'company': 'Microsoft',
        'companyInitial': 'M',
        'jobTitle': 'Product Manager',
        'location': 'United States',
        'description':
            'Microsoft is hiring a Product Manager to drive innovation and deliver exceptional products to our customers.',
        'status': 'Active',
        'postedDate': '5 Dec 2025',
      },
      {
        'company': 'CS',
        'companyInitial': 'CS',
        'jobTitle': 'Full Stack Developer',
        'location': 'Canada',
        'description':
            'We are looking for an experienced Full Stack Developer to join our dynamic team and work on exciting projects.',
        'status': 'Active',
        'postedDate': '3 Dec 2025',
      },
      {
        'company': 'Accenture',
        'companyInitial': 'A',
        'jobTitle': 'Business Analyst',
        'location': 'United Kingdom',
        'description':
            'Accenture is seeking a Business Analyst to help transform businesses through data-driven insights and strategies.',
        'status': 'Active',
        'postedDate': '1 Dec 2025',
      },
    ];

    return jobs.map((job) => _buildJobCard(context, job)).toList();
  }

Widget _buildJobCard(BuildContext context, Map<String, String> job) {
  final isActive = job['status'] == 'Active';

  return Column(
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: context.themeDark,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: CustomText(
                text: job['companyInitial']!,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: context.themeWhite,
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: job['jobTitle']!,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
                const SizedBox(height: 2),
                CustomText(
                  text: job['location']!,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: context.themeIconGrey,
                ),
                const SizedBox(height: 2),
                CustomText(
                  text: job['description']!,
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  color: context.themeIconGrey,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CustomText(
                text: job['status']!,
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isActive
                    ? const Color(0xFF4CAF50)
                    : const Color(0xFFE53935),
              ),
              const SizedBox(height: 20), 
              
              CustomText(
                text: 'Posted On : ${job['postedDate']!}',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: context.themeIconGrey,
              ),
            ],
          ),
        ],
      ),
      SizedBox(height: 12),
      Divider(color: context.themeDivider),
      SizedBox(height: 12),
    ],
  );
}
}
