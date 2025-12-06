
import 'dart:io';
import 'dart:typed_data';
import 'package:empire_job/features/presentation/widgets/custom_text.dart';
import 'package:empire_job/shared/consts/color_consts.dart';
import 'package:flutter/material.dart';

class PlatformHelper {
  static bool isFile(dynamic file) {
    return file is File;
  }

  static String? getFilePath(dynamic file) {
    if (file is File) {
      return file.path;
    }
    return null;
  }

  static Future<Uint8List?> readFileBytes(dynamic file) async {
    if (file is File) {
      return await file.readAsBytes();
    }
    return null;
  }

  static String? createBlobUrl(Uint8List bytes) {
    // Not needed on mobile
    return null;
  }

  static void revokeBlobUrl(String url) {
    // Not needed on mobile
  }

  static void openInNewTab(String url) {
    // Not available on mobile
  }

  static Widget buildWebFallbackViewer(String url) {
    // Return error widget on mobile
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 48),
            SizedBox(height: 16),
            CustomText(
              text: 'Web fallback viewer only available on web platform',
              fontSize: 14,
              color: ColorConsts.black,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  static Widget buildImageFile(
    String filePath, {
    required Widget Function(BuildContext, Object, StackTrace?) onError,
  }) {
    return Image.file(
      File(filePath),
      fit: BoxFit.contain,
      errorBuilder: onError,
    );
  }
}