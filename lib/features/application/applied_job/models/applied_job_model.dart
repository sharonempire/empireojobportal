import 'dart:convert';

class AppliedJobModel {
  final String id;
  final String? userId;
  final String? jobId;
  final Map<String, dynamic>? jobDetails;
  final String status;
  final DateTime? appliedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // Related data
  final String? userName;
  final String? jobName;

  AppliedJobModel({
    required this.id,
    this.userId,
    this.jobId,
    this.jobDetails,
    this.status = 'applied',
    this.appliedAt,
    this.createdAt,
    this.updatedAt,
    this.userName,
    this.jobName,
    String? candidateName,
    String? jobTitle,
  }) : _candidateName = candidateName,
       _jobTitle = jobTitle;

  // Direct fields from API
  final String? _candidateName;
  final String? _jobTitle;

  // Get candidate name - prefer direct field, then userName, then jobDetails
  String get candidateName {
    final candidate = _candidateName;
    if (candidate != null && candidate.isNotEmpty) {
      return candidate;
    }
    final user = userName;
    if (user != null && user.isNotEmpty) {
      return user;
    }
    if (jobDetails == null) return 'Unknown';
    // Try different possible keys for candidate name
    return jobDetails!['candidate_name']?.toString() ??
        jobDetails!['name']?.toString() ??
        jobDetails!['candidateName']?.toString() ??
        'Unknown';
  }

  // Get job title - prefer direct field, then jobName, then jobDetails
  String get jobTitle {
    final title = _jobTitle;
    if (title != null && title.isNotEmpty) {
      return title;
    }
    final job = jobName;
    if (job != null && job.isNotEmpty) {
      return job;
    }
    if (jobDetails == null) return 'Unknown Job';
    // Check nested job_details structure
    final nestedJobDetails = jobDetails!['job_details'];
    if (nestedJobDetails is Map) {
      return nestedJobDetails['job_title']?.toString() ??
          nestedJobDetails['title']?.toString() ??
          'Unknown Job';
    }
    return jobDetails!['job_title']?.toString() ??
        jobDetails!['title']?.toString() ??
        'Unknown Job';
  }

  // Format applied date
  String get formattedAppliedDate {
    if (appliedAt == null) return 'N/A';
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${appliedAt!.day} ${months[appliedAt!.month - 1]} ${appliedAt!.year}';
  }

  // Format status for display
  String get displayStatus {
    switch (status.toLowerCase()) {
      case 'applied':
        return 'Applied';
      case 'shortlisted':
        return 'Shortlisted';
      case 'rejected':
        return 'Rejected';
      case 'verified':
        return 'Verified';
      case 'pending':
        return 'Pending';
      default:
        return status;
    }
  }

  factory AppliedJobModel.fromMap(Map<String, dynamic> map) {
    DateTime? parseDateTime(dynamic value) {
      if (value == null) return null;
      if (value is DateTime) return value;
      if (value is String) {
        try {
          return DateTime.parse(value);
        } catch (e) {
          return null;
        }
      }
      return null;
    }

    Map<String, dynamic>? parseJobDetails(dynamic value) {
      if (value == null) return null;
      if (value is Map<String, dynamic>) return value;
      if (value is Map) {
        return Map<String, dynamic>.from(value);
      }
      if (value is String) {
        try {
          final decoded = jsonDecode(value);
          if (decoded is Map) {
            return Map<String, dynamic>.from(decoded);
          }
          return null;
        } catch (e) {
          return null;
        }
      }
      return null;
    }

    return AppliedJobModel(
      id: map['id']?.toString() ?? '',
      userId: map['user_id']?.toString(),
      jobId: map['job_id']?.toString(),
      jobDetails: parseJobDetails(map['job_details']),
      status: map['status']?.toString() ?? 'applied',
      appliedAt: parseDateTime(map['applied_at']),
      createdAt: parseDateTime(map['created_at']),
      updatedAt: parseDateTime(map['updated_at']),
      userName: map['user_name']?.toString(),
      jobName: map['job_name']?.toString(),
      candidateName: map['candidate_name']?.toString(),
      jobTitle: map['job_title']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'job_id': jobId,
      'job_details': jobDetails,
      'status': status,
      'applied_at': appliedAt?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'user_name': userName,
      'job_name': jobName,
      'candidate_name': _candidateName,
      'job_title': _jobTitle,
    };
  }

  AppliedJobModel copyWith({
    String? id,
    String? userId,
    String? jobId,
    Map<String, dynamic>? jobDetails,
    String? status,
    DateTime? appliedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? userName,
    String? jobName,
    String? candidateName,
    String? jobTitle,
  }) {
    return AppliedJobModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      jobId: jobId ?? this.jobId,
      jobDetails: jobDetails ?? this.jobDetails,
      status: status ?? this.status,
      appliedAt: appliedAt ?? this.appliedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      userName: userName ?? this.userName,
      jobName: jobName ?? this.jobName,
      candidateName: candidateName ?? _candidateName,
      jobTitle: jobTitle ?? _jobTitle,
    );
  }
}
