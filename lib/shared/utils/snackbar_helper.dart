import 'package:empire_job/features/data/network/network_calls.dart';
import 'package:flutter/material.dart';

extension SnackbarExtension on BuildContext {
  void showErrorSnackbar(String message, {Duration? duration}) {
    const snackbarService = SnackbarService();
    snackbarService.showError(this, message, duration: duration);
  }

  /// Shows a success snackbar
  void showSuccessSnackbar(String message, {Duration? duration}) {
    const snackbarService = SnackbarService();
    snackbarService.showSuccess(this, message, duration: duration);
  }

  /// Shows an info snackbar
  void showInfoSnackbar(String message, {Duration? duration}) {
    const snackbarService = SnackbarService();
    snackbarService.showInfo(this, message, duration: duration);
  }

  /// Shows a warning snackbar
  void showWarningSnackbar(String message, {Duration? duration}) {
    const snackbarService = SnackbarService();
    snackbarService.showWarning(this, message, duration: duration);
  }
}

/// Helper class for showing snackbars without context (uses root messenger)
class SnackbarHelper {
  static void showError(String message, {Duration? duration}) {
    const snackbarService = SnackbarService();
    snackbarService.showError(null, message, duration: duration);
  }

  static void showSuccess(String message, {Duration? duration}) {
    const snackbarService = SnackbarService();
    snackbarService.showSuccess(null, message, duration: duration);
  }

  static void showInfo(String message, {Duration? duration}) {
    const snackbarService = SnackbarService();
    snackbarService.showInfo(null, message, duration: duration);
  }

  static void showWarning(String message, {Duration? duration}) {
    const snackbarService = SnackbarService();
    snackbarService.showWarning(null, message, duration: duration);
  }
}

