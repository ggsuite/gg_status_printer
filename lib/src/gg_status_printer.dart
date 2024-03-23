// @license
// Copyright (c) 2019 - 2024 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'package:gg_is_github/gg_is_github.dart';
import 'package:gg_log/gg_log.dart';

/// A printer for displaying status messages
class GgStatusPrinter<T> {
  /// The constructor
  GgStatusPrinter({
    required this.message,
    this.ggLog = print,
    bool? useCarriageReturn,
  }) : useCarriageReturn = useCarriageReturn ?? !isGitHub;

  // ...........................................................................
  /// Run the operation and display the status
  Future<T> run(Future<T> Function() task) async {
    try {
      _updateState(GgStatusPrinterStatus.running);
      final result = await task();
      _updateState(GgStatusPrinterStatus.success);
      return result;
    } catch (e) {
      _updateState(GgStatusPrinterStatus.error);
      rethrow;
    }
  }

  // ...........................................................................
  /// Run the operation and display the status.
  Future<T> logTask({
    required Future<T> Function() task,
    required bool Function(T) success,
  }) async {
    try {
      _updateState(GgStatusPrinterStatus.running);
      final result = await task();
      _updateState(
        success(result)
            ? GgStatusPrinterStatus.success
            : GgStatusPrinterStatus.error,
      );
      return result;
    } catch (e) {
      _updateState(GgStatusPrinterStatus.error);
      rethrow;
    }
  }

  // ...........................................................................
  set status(GgStatusPrinterStatus status) => _updateState(status);

  // ...........................................................................
  /// The print callback used. Is print by default
  final GgLog ggLog;

  /// Replace messages using carriage return
  final bool useCarriageReturn;

  /// The message to be displayed
  final String message;

  // ...........................................................................
  /// Carriage return string
  static const String carriageReturn = '\x1b[1A\x1b[2K';

  // ...........................................................................
  /// Log the result of the command
  void _updateState(GgStatusPrinterStatus state) {
    // On GitHub we have no carriage return.
    // Thus we not logging the icon the first time
    var cr = useCarriageReturn ? carriageReturn : '';

    final msg = switch (state) {
      GgStatusPrinterStatus.success => '$cr✅ $message',
      GgStatusPrinterStatus.error => '$cr❌ $message',
      _ => '⌛️ $message',
    };

    ggLog(msg);
  }
}

// #############################################################################
/// The state of the log
enum GgStatusPrinterStatus {
  /// The command is running
  running,

  /// The command was successful
  success,

  /// The command failed
  error,
}
