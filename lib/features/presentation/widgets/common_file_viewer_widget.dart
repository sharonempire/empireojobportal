import 'package:empire_job/features/presentation/widgets/custom_text.dart';
import 'package:empire_job/shared/consts/color_consts.dart';

import 'platform_helper_mobile.dart'
    if (dart.library.html) 'platform_helper.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'dart:typed_data' show Uint8List;
import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:http/http.dart' as http;

class CommonFileViewerWidget {
  static void show({
    required BuildContext context,
    required dynamic file,
    String? fileName,
  }) {
    String? fileExtension;
    String? filePath;
    Uint8List? fileBytes;
    String? displayName;
    bool isUrl = false;
    bool isLocalFile = false;
    if (file is String && file.startsWith('http')) {
      filePath = file;
      isUrl = true;
      displayName = file.split('/').last.split('?').first;
      fileExtension = displayName.contains('.')
          ? displayName.split('.').last.toLowerCase()
          : null;
      debugPrint('🔍 Detected as URL string: $filePath');
    } else if (file is Map && file['isUrl'] == true) {
      filePath = file['url'] as String;
      isUrl = true;
      displayName =
          file['name'] as String? ?? filePath.split('/').last.split('?').first;
      fileExtension =
          file['extension'] as String? ??
          (displayName.contains('.')
              ? displayName.split('.').last.toLowerCase()
              : null);
      debugPrint('🔍 Detected as URL object: $filePath');
    } else if (!kIsWeb && PlatformHelper.isFile(file)) {
      // On non-web, File from dart:io is available
      filePath = PlatformHelper.getFilePath(file);
      isLocalFile = true;
      displayName = filePath?.split('/').last ?? 'Unknown';
      fileExtension = displayName.contains('.')
          ? displayName.split('.').last.toLowerCase()
          : null;
      debugPrint('🔍 Detected as local File: $filePath');
    } else if (file is PlatformFile) {
      fileExtension = file.extension?.toLowerCase();
      fileBytes = file.bytes;
      filePath = file.path;
      displayName = file.name;
      isLocalFile = true;

      if (fileExtension == null && file.name.contains('.')) {
        fileExtension = file.name.split('.').last.toLowerCase();
      }
      debugPrint(
        '🔍 Detected as PlatformFile: ${file.name}, bytes: ${fileBytes?.length}',
      );
    } else if (file is String) {
      // Local path provided as String (works on mobile/desktop)
      filePath = file;
      isLocalFile = true;
      displayName = file.split('/').last;
      fileExtension = displayName.contains('.')
          ? displayName.split('.').last.toLowerCase()
          : null;
      debugPrint('🔍 Detected as local path: $filePath');
    }

    final finalFileName = fileName ?? displayName ?? 'File Preview';

    if (fileExtension == null && fileName != null && fileName.contains('.')) {
      fileExtension = fileName.split('.').last.toLowerCase();
    }

    final isPdf = fileExtension == 'pdf';
    final isImage = [
      'jpg',
      'jpeg',
      'png',
      'gif',
      'bmp',
      'webp',
    ].contains(fileExtension);

    final isDocument = ['doc', 'docx'].contains(fileExtension);

    if (!isPdf && !isImage && !isDocument) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'File type not supported for preview${fileExtension != null ? ": .$fileExtension" : ""}. Only PDF and images are supported.',
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
      return;
    }

    if (isDocument) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Word documents cannot be previewed. Please upload as PDF for preview.',
          ),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(20),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 900, maxHeight: 800),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: ColorConsts.backgroundColorScaffold,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: CustomText(
                        text: finalFileName,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: ColorConsts.black,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: ColorConsts.black),
                      onPressed: () => Navigator.of(context).pop(),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
              // Content
              Expanded(
                child: Container(
                  color: isImage ? Colors.black : Colors.white,
                  child: isPdf
                      ? _SyncfusionPdfViewer(
                          filePath: filePath,
                          fileBytes: fileBytes,
                          isUrl: isUrl,
                          isLocalFile: isLocalFile,
                          originalFile: file,
                        )
                      : _ImageViewer(
                          filePath: filePath,
                          fileBytes: fileBytes,
                          isUrl: isUrl,
                          isLocalFile: isLocalFile,
                          originalFile: file,
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SyncfusionPdfViewer extends StatefulWidget {
  final String? filePath;
  final Uint8List? fileBytes;
  final bool isUrl;
  final bool isLocalFile;
  final dynamic originalFile;

  const _SyncfusionPdfViewer({
    this.filePath,
    this.fileBytes,
    this.isUrl = false,
    this.isLocalFile = false,
    this.originalFile,
  });

  @override
  State<_SyncfusionPdfViewer> createState() => _SyncfusionPdfViewerState();
}

class _SyncfusionPdfViewerState extends State<_SyncfusionPdfViewer> {
  final PdfViewerController _pdfViewerController = PdfViewerController();
  bool _isLoading = true;
  String? _error;
  bool _hasLoadFailed = false;
  bool _useFallbackViewer = false;
  String? _blobUrl;
  Uint8List? _downloadedBytes;
  Uint8List? _localFileBytes;

  @override
  void initState() {
    super.initState();
    _validateAndLoad();
  }

  Future<void> _validateAndLoad() async {
    try {
      debugPrint('🔧 PDF Viewer - Starting load process');
      debugPrint('🔧 isUrl: ${widget.isUrl}');
      debugPrint('🔧 isLocalFile: ${widget.isLocalFile}');
      debugPrint('🔧 filePath: ${widget.filePath}');
      debugPrint('🔧 fileBytes provided: ${widget.fileBytes != null}');
      debugPrint('🔧 originalFile type: ${widget.originalFile.runtimeType}');

      if (widget.isLocalFile) {
        if (widget.fileBytes != null && widget.fileBytes!.isNotEmpty) {
          _localFileBytes = widget.fileBytes;
        } else if (widget.originalFile is PlatformFile) {
          try {
            final platformFile = widget.originalFile as PlatformFile;
            if (platformFile.bytes != null) {
              _localFileBytes = platformFile.bytes;
            }
          } catch (e) {
            debugPrint('🔧 Error reading PlatformFile bytes: $e');
          }
        } else if (!kIsWeb && PlatformHelper.isFile(widget.originalFile)) {
          try {
            _localFileBytes = await PlatformHelper.readFileBytes(
              widget.originalFile,
            );
          } catch (e) {
            debugPrint('🔧 Error reading File bytes: $e');
          }
        }
      }

      if (widget.isUrl && widget.filePath != null && _localFileBytes == null) {
        try {
          final response = await http.get(Uri.parse(widget.filePath!));
          if (response.statusCode == 200) {
            _downloadedBytes = response.bodyBytes;
          } else {
            throw Exception('HTTP ${response.statusCode}');
          }
        } catch (e) {
          debugPrint('🔧 Failed to download PDF: $e');
        }
      }

      final bytes = _localFileBytes ?? _downloadedBytes ?? widget.fileBytes;
      if (bytes != null && bytes.isNotEmpty) {
        if (bytes.length >= 4) {
          final header = String.fromCharCodes(bytes.take(4));

          if (!header.startsWith('%PDF')) {
            setState(() {
              _error =
                  'Invalid PDF file. The file may be corrupted or not a valid PDF.';
              _isLoading = false;
              _hasLoadFailed = true;
            });
            return;
          }
        }

        if (kIsWeb && widget.isLocalFile && bytes.isNotEmpty) {
          try {
            _blobUrl = PlatformHelper.createBlobUrl(bytes);
            setState(() {
              _useFallbackViewer = true;
              _isLoading = false;
            });
            return;
          } catch (e) {
            debugPrint('🔧 Error creating blob URL: $e');
          }
        }
      }

      if (kIsWeb && widget.isUrl && widget.filePath != null) {
        setState(() {
          _useFallbackViewer = true;
          _isLoading = false;
        });
        return;
      }

      await Future.delayed(const Duration(milliseconds: 100));
    } catch (e) {
      setState(() {
        _error = 'Error loading PDF: $e';
        _isLoading = false;
        _hasLoadFailed = true;
      });
      return;
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _pdfViewerController.dispose();
    if (_blobUrl != null) {
      try {
        PlatformHelper.revokeBlobUrl(_blobUrl!);
      } catch (e) {
        debugPrint('Error revoking blob URL: $e');
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: ColorConsts.black),
            SizedBox(height: 16),
            CustomText(
              text: 'Loading PDF...',
              fontSize: 14,
              color: ColorConsts.black,
            ),
          ],
        ),
      );
    }

    if (_error != null || _hasLoadFailed) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              CustomText(
                text: _error ?? 'Failed to load PDF',
                fontSize: 14,
                color: ColorConsts.black,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              if (widget.isUrl && widget.filePath != null && kIsWeb)
                ElevatedButton.icon(
                  onPressed: () =>
                      PlatformHelper.openInNewTab(widget.filePath!),
                  icon: const Icon(Icons.open_in_new),
                  label: const Text('Open in New Tab'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorConsts.black,
                    foregroundColor: Colors.white,
                  ),
                ),
            ],
          ),
        ),
      );
    }

    if (kIsWeb && _useFallbackViewer) {
      if (_blobUrl != null) {
        return PlatformHelper.buildWebFallbackViewer(_blobUrl!);
      } else if (widget.filePath != null) {
        return PlatformHelper.buildWebFallbackViewer(widget.filePath!);
      }
    }

    final bytes = _localFileBytes ?? _downloadedBytes ?? widget.fileBytes;

    if (bytes == null && widget.filePath == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              CustomText(
                text: 'No PDF data available.',
                fontSize: 14,
                color: ColorConsts.black,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    Widget pdfViewer;

    try {
      if (bytes != null && bytes.isNotEmpty) {
        pdfViewer = SfPdfViewer.memory(
          bytes,
          controller: _pdfViewerController,
          onDocumentLoaded: (details) {},
          onDocumentLoadFailed: (details) {
            if (mounted) {
              setState(() {
                _hasLoadFailed = true;
              });
            }
          },
        );
      } else if (widget.filePath != null && !widget.isLocalFile) {
        if (widget.filePath!.startsWith('http')) {
          pdfViewer = SfPdfViewer.network(
            widget.filePath!,
            controller: _pdfViewerController,
            onDocumentLoaded: (details) {},
            onDocumentLoadFailed: (details) {
              if (mounted) {
                setState(() {
                  _hasLoadFailed = true;
                });
              }
            },
          );
        } else {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  CustomText(
                    text: 'Cannot load local file paths on web.',
                    fontSize: 14,
                    color: ColorConsts.black,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }
      } else {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 16),
                CustomText(
                  text: 'No PDF file provided or unable to read file data.',
                  fontSize: 14,
                  color: ColorConsts.black,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      }
    } catch (e) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              CustomText(
                text: 'Error initializing PDF viewer:\n$e',
                fontSize: 14,
                color: ColorConsts.black,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return pdfViewer;
  }
}

class _ImageViewer extends StatefulWidget {
  final String? filePath;
  final Uint8List? fileBytes;
  final bool isUrl;
  final bool isLocalFile;
  final dynamic originalFile;

  const _ImageViewer({
    this.filePath,
    this.fileBytes,
    this.isUrl = false,
    this.isLocalFile = false,
    this.originalFile,
  });

  @override
  State<_ImageViewer> createState() => _ImageViewerState();
}

class _ImageViewerState extends State<_ImageViewer> {
  Uint8List? _downloadedBytes;
  Uint8List? _localFileBytes;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    try {
      if (widget.isLocalFile) {
        if (widget.fileBytes != null && widget.fileBytes!.isNotEmpty) {
          _localFileBytes = widget.fileBytes;
        } else if (widget.originalFile is PlatformFile) {
          final platformFile = widget.originalFile as PlatformFile;
          if (platformFile.bytes != null) {
            _localFileBytes = platformFile.bytes;
          }
        } else if (!kIsWeb && PlatformHelper.isFile(widget.originalFile)) {
          try {
            _localFileBytes = await PlatformHelper.readFileBytes(
              widget.originalFile,
            );
          } catch (e) {
            debugPrint('🖼️ Error reading File bytes: $e');
          }
        }
      }

      // Handle URL files - download if needed
      if (widget.isUrl && widget.filePath != null && _localFileBytes == null) {
        try {
          final response = await http.get(Uri.parse(widget.filePath!));
          if (response.statusCode == 200) {
            _downloadedBytes = response.bodyBytes;
          } else {
            throw Exception('HTTP ${response.statusCode}');
          }
        } catch (e) {
          debugPrint('🖼️ Failed to download image: $e');
          _error = 'Failed to load image from URL';
        }
      }
    } catch (e) {
      _error = 'Error loading image';
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: Colors.white),
            SizedBox(height: 16),
            CustomText(
              text: 'Loading image...',
              fontSize: 14,
              color: Colors.white,
            ),
          ],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              CustomText(
                text: _error!,
                fontSize: 14,
                color: Colors.white,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              if (widget.filePath != null && widget.isUrl && kIsWeb)
                ElevatedButton.icon(
                  onPressed: () =>
                      PlatformHelper.openInNewTab(widget.filePath!),
                  icon: const Icon(Icons.open_in_new),
                  label: const Text('Open in New Tab'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                  ),
                ),
            ],
          ),
        ),
      );
    }

    final bytes = _localFileBytes ?? _downloadedBytes ?? widget.fileBytes;
    Widget? imageWidget;

    if (bytes != null && bytes.isNotEmpty) {
      imageWidget = Image.memory(
        bytes,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return _buildErrorWidget('Failed to load image from memory');
        },
      );
    } else if (widget.filePath != null) {
      if (widget.isUrl) {
        imageWidget = Image.network(
          widget.filePath!,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return _buildErrorWidget('Failed to load image from URL');
          },
        );
      } else if (!kIsWeb) {
        imageWidget = PlatformHelper.buildImageFile(
          widget.filePath!,
          onError: (context, error, stackTrace) {
            return _buildErrorWidget('Failed to load image from file');
          },
        );
      }
    }

    if (imageWidget == null) {
      return _buildErrorWidget('No image data available.');
    }

    return Center(
      child: InteractiveViewer(
        minScale: 0.1,
        maxScale: 5.0,
        child: imageWidget,
      ),
    );
  }

  Widget _buildErrorWidget(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            CustomText(
              text: message,
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
