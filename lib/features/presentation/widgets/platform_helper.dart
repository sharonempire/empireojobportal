import 'dart:html' as html;
import 'dart:ui_web' as ui_web;
import 'dart:typed_data';
import 'package:empire_job/features/presentation/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class PlatformHelper {
  static final Set<String> _registeredViewTypes = {};

  static bool isFile(dynamic file) {
    // On web, dart:io File doesn't exist
    return false;
  }

  static String? getFilePath(dynamic file) {
    return null;
  }

  static Future<Uint8List?> readFileBytes(dynamic file) async {
    return null;
  }

  static String? createBlobUrl(Uint8List bytes) {
    final blob = html.Blob([bytes], 'application/pdf');
    return html.Url.createObjectUrlFromBlob(blob);
  }

  static void revokeBlobUrl(String url) {
    html.Url.revokeObjectUrl(url);
  }

  static void openInNewTab(String url) {
    html.AnchorElement(href: url)
      ..target = '_blank'
      ..click();
  }

  static Widget buildWebFallbackViewer(String url) {
    final String viewType = 'pdf-fallback-viewer-${url.hashCode}';
    if (!_registeredViewTypes.contains(viewType)) {
      ui_web.platformViewRegistry.registerViewFactory(viewType, (int viewId) {
        final iframe = html.IFrameElement()
          ..src = url
          ..style.border = 'none'
          ..style.width = '100%'
          ..style.height = '100%'
          ..allowFullscreen = true;
        return iframe;
      });
      _registeredViewTypes.add(viewType);
    }

    return HtmlElementView(viewType: viewType);
  }

  static Widget buildImageFile(
    String filePath, {
    required Widget Function(BuildContext, Object, StackTrace?) onError,
  }) {
    // On web, can't use File, return error widget
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            CustomText(
              text: 'File loading not supported on web. Use URL or bytes instead.',
              fontSize: 14,
              color: Colors.white,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}