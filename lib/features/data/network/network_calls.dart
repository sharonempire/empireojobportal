import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' show ClientException;

final networkServiceProvider = Provider<NetworkService>((ref) {
  return NetworkService();
});

final snackbarServiceProvider = Provider<SnackbarService>((ref) {
  return const SnackbarService();
});

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class SnackbarService {
  const SnackbarService();
  void showError(BuildContext? context, String message, {Duration? duration}) {
    final messenger = _resolveMessenger(context);
    if (messenger == null) {
      debugPrint(
        'SnackbarService.showError skipped: no ScaffoldMessenger available. Message: $message',
      );
      return;
    }

    final userFriendlyMessage = _parseErrorMessage(message);

    messenger.showSnackBar(
      SnackBar(
        content: Text(userFriendlyMessage),
        backgroundColor: Colors.red,
        duration: duration ?? const Duration(seconds: 4),
      ),
    );
  }

  void showSuccess(BuildContext? context, String message, {Duration? duration}) {
    final messenger = _resolveMessenger(context);
    if (messenger == null) {
      debugPrint(
        'SnackbarService.showSuccess skipped: no ScaffoldMessenger available. Message: $message',
      );
      return;
    }

    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: duration ?? const Duration(seconds: 3),
      ),
    );
  }

  void showInfo(BuildContext? context, String message, {Duration? duration}) {
    final messenger = _resolveMessenger(context);
    if (messenger == null) {
      debugPrint(
        'SnackbarService.showInfo skipped: no ScaffoldMessenger available. Message: $message',
      );
      return;
    }

    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.blue,
        duration: duration ?? const Duration(seconds: 3),
      ),
    );
  }

  void showWarning(BuildContext? context, String message, {Duration? duration}) {
    final messenger = _resolveMessenger(context);
    if (messenger == null) {
      debugPrint(
        'SnackbarService.showWarning skipped: no ScaffoldMessenger available. Message: $message',
      );
      return;
    }

    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.orange,
        duration: duration ?? const Duration(seconds: 3),
      ),
    );
  }

  String _parseErrorMessage(String error) {
    final errorLower = error.toLowerCase();
    if (errorLower.contains('invalid login credentials') ||
        errorLower.contains('invalid email or password') ||
        errorLower.contains('email not confirmed') ||
        errorLower.contains('invalid_credentials')) {
      return 'Invalid email or password. Please check your credentials and try again.';
    }
    if (errorLower.contains('email already registered') ||
        errorLower.contains('user already registered') ||
        errorLower.contains('already registered') ||
        errorLower.contains('duplicate key') ||
        errorLower.contains('email already exists')) {
      // Return the original message if it's already user-friendly, otherwise return a generic one
      if (error.contains('already registered') && error.length < 100) {
        return error;
      }
      return 'This email is already registered. Please use a different email or try logging in.';
    }
    if (errorLower.contains('weak password') ||
        errorLower.contains('password too short') ||
        errorLower.contains('password should be at least')) {
      return 'Password is too weak. Please use at least 6 characters.';
    }
    if (errorLower.contains('invalid email') ||
        errorLower.contains('email format') ||
        errorLower.contains('malformed email')) {
      return 'Please enter a valid email address.';
    }
    if (errorLower.contains('session expired') ||
        errorLower.contains('session_not_found') ||
        errorLower.contains('not authenticated') ||
        errorLower.contains('jwt')) {
      return 'Your session has expired. Please log in again.';
    }

    if (errorLower.contains('network error') ||
        errorLower.contains('connection') ||
        errorLower.contains('timeout') ||
        errorLower.contains('failed host lookup') ||
        errorLower.contains('socket')) {
      return 'Network connection failed. Please check your internet connection and try again.';
    }

    if (errorLower.contains('rate_limit') ||
        errorLower.contains('too many requests') ||
        errorLower.contains('rate limit')) {
      return 'Too many requests. Please wait a moment and try again.';
    }

    if (errorLower.contains('file size') ||
        errorLower.contains('file too large') ||
        errorLower.contains('upload failed')) {
      return 'File upload failed. The file may be too large or in an unsupported format.';
    }
    if (errorLower.contains('foreign key constraint') ||
        errorLower.contains('violates foreign key')) {
      return 'Unable to complete this action. Some required information is missing.';
    }

    if (errorLower.contains('duplicate key value') ||
        errorLower.contains('already exists')) {
      return 'This item already exists. Please use a different value.';
    }
    if (errorLower.contains('password reset') ||
        errorLower.contains('reset link') ||
        errorLower.contains('recovery')) {
      return 'Password reset failed. Please request a new reset link.';
    }

    if (errorLower.contains('same_password') ||
        errorLower.contains('password must be different')) {
      return 'New password must be different from your current password.';
    }
    if (errorLower.contains('error:') || errorLower.contains('exception:')) {
      final parts = error.split(':');
      if (parts.length > 1) {
        final meaningfulPart = parts.last.trim();
        if (meaningfulPart.length < 100 && 
            !meaningfulPart.contains('stacktrace') &&
            !meaningfulPart.contains('at ')) {
          return meaningfulPart;
        }
      }
    }

    if (errorLower.contains('postgrest') ||
        errorLower.contains('supabase') ||
        errorLower.contains('http') ||
        errorLower.contains('status code') ||
        errorLower.contains('stacktrace') ||
        errorLower.contains('at ') ||
        errorLower.contains('exception')) {
      return 'Something went wrong. Please try again later.';
    }

    // If error is a clean, user-friendly message, return it as-is
    if (error.length < 150 && 
        !errorLower.contains('stacktrace') &&
        !errorLower.contains('at ') &&
        !errorLower.contains('exception:') &&
        !errorLower.contains('error:')) {
      return error;
    }
    
    // Last resort: return generic message
    return 'An error occurred. Please try again.';
  }

  ScaffoldMessengerState? _resolveMessenger(BuildContext? context) {
    if (context != null) {
      final element = context is Element ? context : null;
      final mounted = element?.mounted ?? false;

      if (mounted) {
        try {
          final messenger = ScaffoldMessenger.maybeOf(context);
          if (messenger != null) {
            return messenger;
          }
        } catch (error) {
          debugPrint('SnackbarService context lookup failed: $error');
        }
      }
    }

    return rootScaffoldMessengerKey.currentState;
  }
}

class NetworkService {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<bool> rowExists({required String table, required String id}) async {
    try {
      final response = await supabase
          .from(table)
          .select('id')
          .eq('id', id)
          .maybeSingle();

      return response != null;
    } on PostgrestException catch (e) {
      if (e.code == 'PGRST116') return false; 
      throw parseError(e.message, 'Failed to check row');
    } catch (e) {
      throw 'Failed to check row: ${e.toString()}';
    }
  }

  Future<bool> emailExists({
    required String table,
    required String email,
  }) async {
    try {
      final response = await supabase
          .from(table)
          .select('id')
          .eq('email', email)
          .maybeSingle();

      return response != null; 
    } on PostgrestException catch (e) {
      if (e.code == 'PGRST116') return false; 
      throw parseError(e.message, 'Failed to check row');
    } catch (e) {
      throw 'Failed to check row: ${e.toString()}';
    }
  }

  Future<bool> recordExists({
    required String table,
    required Map<String, dynamic> filters,
  }) async {
    try {
      // Start the query
      var query = supabase.from(table).select('id');

      // Apply all filters dynamically
      filters.forEach((key, value) {
        if (value != null) {
          query = query.eq(key, value);
        }
      });

      // maybeSingle → returns null if no matching row
      final response = await query.maybeSingle();

      return response != null; // ✅ True if record exists
    } on PostgrestException catch (e) {
      if (e.code == 'PGRST116') return false; // No row found
      throw parseError(e.message, 'Failed to check record');
    } catch (e) {
      throw 'Failed to check record: ${e.toString()}';
    }
  }

  Future<List<Map<String, dynamic>>> pull({
    required String table,
    Map<String, dynamic>?
    filters, // Supports operators like gte, lte, eq, neq, like, etc.
    int? limit,
    int? offset,
    String? orderBy,
    bool ascending = true,
    String? columns,
  }) async {
    const maxAttempts = 3;
    var attempt = 0;

    while (true) {
      attempt++;
      try {
        dynamic query = supabase.from(table).select(columns ?? '*');

        // ✅ Apply multiple filters with support for operators
        if (filters != null && filters.isNotEmpty) {
          filters.forEach((key, value) {
            if (value == null) return;

            // If value is a Map → supports operators like gte, lte, neq
            if (value is Map<String, dynamic>) {
              value.forEach((operator, val) {
                if (val == null) return;

                switch (operator) {
                  case 'eq':
                    query = query.eq(key, val);
                    break;
                  case 'neq':
                    query = query.neq(key, val);
                    break;
                  case 'gte':
                    query = query.gte(key, val);
                    break;
                  case 'lte':
                    query = query.lte(key, val);
                    break;
                  case 'gt':
                    query = query.gt(key, val);
                    break;
                  case 'lt':
                    query = query.lt(key, val);
                    break;
                  case 'like':
                    query = query.like(key, val);
                    break;
                  case 'ilike':
                    query = query.ilike(key, val);
                    break;
                  default:
                    throw 'Unsupported operator: $operator';
                }
              });
            } else {
              query = query.eq(key, value);
            }
          });
        }

        // ✅ Apply ordering if provided
        if (orderBy != null) {
          query = query.order(orderBy, ascending: ascending);
        }

        // ✅ Apply limit if provided
        if (limit != null) {
          if (offset != null && offset >= 0) {
            query = query.range(offset, offset + limit - 1);
          } else {
            query = query.limit(limit);
          }
        } else if (offset != null && offset > 0) {
          // If only offset is provided, fetch from offset with a sensible window
          query = query.range(offset, offset + 999);
        }

        final response = await query;
        return List<Map<String, dynamic>>.from(response);
      } on PostgrestException catch (e) {
        debugPrint('Postgrest error: ${e.code} ${e.message}');
        throw parseError(e.message, 'Failed to fetch data');
      } on ClientException catch (error) {
        if (attempt >= maxAttempts) {
          debugPrint(
            'NetworkService.pull network error for $table after $attempt attempts: $error',
          );
          throw 'Network unavailable. Please check your internet connection.';
        }
        await Future.delayed(Duration(milliseconds: 200 * attempt));
        continue;
      } catch (e) {
        throw 'Failed to fetch data: ${e.toString()}';
      }
    }
  }

  Future<Map<String, dynamic>?> pullById({
    required String table,
    required String id,
  }) async {
    try {
      final response = await supabase
          .from(table)
          .select()
          .eq('id', id)
          .single();

      return response as Map<String, dynamic>?;
    } on PostgrestException catch (e) {
      if (e.code == 'PGRST116') {
        return null;
      }
      throw parseError(e.message, 'Failed to fetch item');
    } catch (e) {
      throw 'Failed to fetch item: ${e.toString()}';
    }
  }

  Future<Map<String, dynamic>> push({
    required String table,
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await supabase
          .from(table)
          .insert(data)
          .select()
          .single();

      return response;
    } on PostgrestException catch (e) {
      throw parseError(e.message, 'Failed to create item');
    } catch (e) {
      throw 'Failed to create item: ${e.toString()}';
    }
  }

  Future<Map<String, dynamic>?> update({
    required String table,
    required String id,
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await supabase
          .from(table)
          .update(data)
          .eq('id', id)
          .select()
          .maybeSingle();
      return response;
    } on PostgrestException catch (e) {
      throw parseError(e.message, 'Failed to update item');
    } catch (e) {
      throw 'Failed to update item: ${e.toString()}';
    }
  }

  Future<Map<String, dynamic>?> updateWithEmail({
    required String table,
    required String email,
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await supabase
          .from(table)
          .update(data)
          .eq('email', email)
          .select()
          .maybeSingle();
      return response;
    } on PostgrestException catch (e) {
      throw parseError(e.message, 'Failed to update item');
    } catch (e) {
      throw 'Failed to update item: ${e.toString()}';
    }
  }

  Future<bool> delete({required String table, required String id}) async {
    try {
      final bool deleted = await supabase.from(table).delete().eq('id', id);

      return deleted;
    } on PostgrestException catch (e) {
      throw parseError(e.message, 'Failed to delete item');
    } catch (e) {
      throw 'Failed to delete item: ${e.toString()}';
    }
  }

  Stream<List<Map<String, dynamic>>> subscribeToTable({
    required String table,
    String? filterColumn,
    dynamic filterValue,
  }) {
    try {
      final baseStream = supabase.from(table).stream(primaryKey: ['id']);

      // Apply filter if provided
      if (filterColumn != null && filterValue != null) {
        return baseStream.map(
          (list) => list
              .where((item) => item[filterColumn] == filterValue)
              .map((item) => item)
              .toList(),
        );
      }

      return baseStream.map((list) => list.map((item) => item).toList());
    } catch (e) {
      return Stream.error(e);
    }
  }

  RealtimeChannel subscribeToRealtime({
    required String table,
    String schema = 'public',
    PostgresChangeFilter? filter,
    void Function(PostgresChangePayload payload)? onInsert,
    void Function(PostgresChangePayload payload)? onUpdate,
    void Function(PostgresChangePayload payload)? onDelete,
  }) {
    final channel = supabase.channel('realtime:$schema:$table');

    void register(
      PostgresChangeEvent event,
      void Function(PostgresChangePayload payload)? handler,
    ) {
      if (handler == null) return;
      channel.onPostgresChanges(
        event: event,
        schema: schema,
        table: table,
        filter: filter,
        callback: handler,
      );
    }

    register(PostgresChangeEvent.insert, onInsert);
    register(PostgresChangeEvent.update, onUpdate);
    register(PostgresChangeEvent.delete, onDelete);

    channel.subscribe();
    return channel;
  }

  Future<String> uploadFile({
    required String bucketName,
    required String filePath,
    required Uint8List? fileBytes,
  }) async {
    if (fileBytes == null) return '';
    try {
      await supabase.storage.from(bucketName).uploadBinary(filePath, fileBytes);

      return supabase.storage.from(bucketName).getPublicUrl(filePath);
    } on StorageException catch (e) {
      throw parseError(e.message, 'Failed to upload file');
    } catch (e) {
      throw 'Failed to upload file: ${e.toString()}';
    }
  }

  Future<Uint8List> downloadFile({
    required String bucketName,
    required String filePath,
  }) async {
    try {
      return await supabase.storage.from(bucketName).download(filePath);
    } on StorageException catch (e) {
      throw parseError(e.message, 'Failed to download file');
    } catch (e) {
      throw 'Failed to download file: ${e.toString()}';
    }
  }

  String parseError(String error, String defaultMessage) {
    if (error.contains('violates foreign key constraint')) {
      return 'Related item not found';
    } else if (error.contains('duplicate key value')) {
      return 'Item already exists';
    } else if (error.contains('network error')) {
      return 'Network connection failed';
    } else if (error.contains('JWT')) {
      return 'Authentication failed. Please login again.';
    }
    return '$defaultMessage: ${error.split(']').last.trim()}';
  }

  Future<bool> checkConnection() async {
    try {
      await supabase
          .from('_dummy')
          .select()
          .limit(1)
          .timeout(const Duration(seconds: 5));
      return true;
    } catch (e) {
      return false;
    }
  }

  String? get currentUserId {
    return supabase.auth.currentUser?.id;
  }

  bool get isAuthenticated {
    return supabase.auth.currentUser != null;
  }



  GoTrueClient get auth => supabase.auth;
}
