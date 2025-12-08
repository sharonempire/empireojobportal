import 'package:empire_job/features/presentation/web/dashboard/widgets/job_posting_status_widget.dart';
import 'package:empire_job/features/presentation/web/dashboard/widgets/recent_applications_tablw_widget.dart';
import 'package:empire_job/features/presentation/web/dashboard/widgets/stats_card_widget.dart';
import 'package:empire_job/features/presentation/widgets/common_navbar.dart';
import 'package:empire_job/features/presentation/widgets/responsive_horizontal_scroll.dart';
import 'package:empire_job/shared/consts/color_consts.dart';
import 'package:empire_job/features/presentation/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class DashboardPageWeb extends StatelessWidget {
  const DashboardPageWeb({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.themeScaffoldCourse,
      body: ResponsiveHorizontalScroll(
        child: SingleChildScrollView(
          child: Column(
            children: [
              CommonNavbar(),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 70,
                  vertical: 42,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      color: context.themeWhite,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          CustomText(
                            text: 'Create a Job That Attracts the Right Talent',
                            fontSize: 26,
                            fontWeight: FontWeight.w600,
                          ),
                          const SizedBox(height: 8),
                          CustomText(
                            text:
                                'Craft a clear and compelling job post to reach qualified candidates. Add details like role, skills, salary, and requirements, and publish it instantly across the portal.',
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: context.themeIconGrey,
                            maxLines: 2,
                          ),
                          const SizedBox(height: 16),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton.icon(
                              onPressed: () {},
                              icon:  Icon(Icons.add, size: 18,color: context.themeBlueText,),
                              label: CustomText(
                                text: 'Post a New Job',
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: context.themeBlueText,
                              ),
                           
                            ),
                          ), 
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    Row(
                      children: [
                        Expanded(
                          child: StatsCard(
                            icon: Icons.trending_up,
                            title: 'Total Jobs Posted',
                            value: '125',
                          ),
                        ),
                        const SizedBox(width: 30),
                        Expanded(
                          child: StatsCard(
                            icon: Icons.trending_up,
                            title: 'Active Jobs',
                            value: '125',
                          ),
                        ),
                        const SizedBox(width: 30),
                        Expanded(
                          child: StatsCard(
                            icon: Icons.trending_up,
                            title: 'Application Received',
                            value: '1250',
                          ),
                        ),
                        const SizedBox(width: 30),
                        Expanded(
                          child: StatsCard(
                            icon: Icons.trending_up,
                            title: 'Closed Jobs',
                            value: '84',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 3, child: RecentApplicationsTable()),
                        const SizedBox(width: 24),

                        Expanded(flex: 2, child: JobPostingStatus()),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
