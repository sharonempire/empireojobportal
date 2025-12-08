import 'package:empire_job/features/presentation/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class StatusCell extends StatelessWidget {
  final String status;

  const StatusCell(this.status, {super.key});

  Color _getStatusColor() {
    switch (status) {
      case 'Shortlisted':
        return Colors.orange;
      case 'Applied':
        return Colors.blue;
      case 'Rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: CustomText(
        text: status,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: _getStatusColor(),
      ),
    );
  }
}