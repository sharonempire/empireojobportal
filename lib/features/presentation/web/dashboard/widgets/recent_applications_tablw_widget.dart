import 'package:empire_job/features/presentation/web/dashboard/widgets/status_cell_widget.dart';
import 'package:empire_job/features/presentation/web/dashboard/widgets/table_cell_widget.dart';
import 'package:empire_job/features/presentation/web/dashboard/widgets/table_header_widget.dart';
import 'package:empire_job/features/presentation/widgets/custom_text.dart';
import 'package:empire_job/shared/consts/color_consts.dart';
import 'package:flutter/material.dart';

class RecentApplicationsTable extends StatelessWidget {
  final List<Map<String, dynamic>> applications = [
    {
      'name': 'Anjana Priya',
      'title': 'Software Developer',
      'date': '29 Nov 2025',
      'status': 'Shortlisted',
    },
    {
      'name': 'Anjana Priya',
      'title': 'Software Developer',
      'date': '29 Nov 2025',
      'status': 'Applied',
    },
    {
      'name': 'Anjana Priya',
      'title': 'Software Developer',
      'date': '29 Nov 2025',
      'status': 'Rejected',
    },
    {
      'name': 'Anjana Priya',
      'title': 'Software Developer',
      'date': '29 Nov 2025',
      'status': 'Shortlisted',
    },
    {
      'name': 'Anjana Priya',
      'title': 'Software Developer',
      'date': '29 Nov 2025',
      'status': 'Shortlisted',
    },
    {
      'name': 'Anjana Priya',
      'title': 'Software Developer',
      'date': '29 Nov 2025',
      'status': 'Applied',
    },
    {
      'name': 'Anjana Priya',
      'title': 'Software Developer',
      'date': '29 Nov 2025',
      'status': 'Rejected',
    },
  ];

  RecentApplicationsTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(35),
      decoration: BoxDecoration(
        color: context.themeWhite,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: context.themeIconGrey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: 'Recent Applications',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(height: 36),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              children: [
                Table(
                  columnWidths: const {
                    0: FlexColumnWidth(2),
                    1: FlexColumnWidth(2),
                    2: FlexColumnWidth(1.5),
                    3: FlexColumnWidth(1.5),
                  },
                  children: [
                    TableRow(
                      children: [
                        TableHeaderWidget('Candidate Name'),
                        TableHeaderWidget('Job Title'),
                        TableHeaderWidget('Applied On'),
                        TableHeaderWidget('Status'),
                      ],
                    ),
                  ],
                ),

                Divider(color: context.themeDivider.withOpacity(.5),),
                ...applications.asMap().entries.map((entry) {
                  final app = entry.value;
                  return Column(
                    children: [
                      Table(
                        columnWidths: const {
                          0: FlexColumnWidth(2),
                          1: FlexColumnWidth(2),
                          2: FlexColumnWidth(1.5),
                          3: FlexColumnWidth(1.5),
                        },
                        children: [
                          TableRow(
                            children: [
                              TableCellWidget(app['name']),
                              TableCellWidget(app['title']),
                              TableCellWidget(app['date']),
                              StatusCell(app['status']),
                            ],
                          ),
                        ],
                      ),

                      Divider(
                        color: context.themeDivider.withOpacity(0.5),
                 
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
