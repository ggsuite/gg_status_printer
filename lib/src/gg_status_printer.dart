// @license
// Copyright (c) 2019 - 2024 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

/// A printer for displaying status messages
class GgStatusPrinter<T> {
  /// The constructor
  const GgStatusPrinter({
    required this.message,
    this.useCarriageReturn = true,
    this.printCallback = print,
  });

  // ...........................................................................
  /// Run the operation and display the status
  Future<T> run(Future<T> Function() task) async {
    try {
      _updateState(GgTaskStatus.running);
      final result = await task();
      _updateState(GgTaskStatus.success);
      return result;
    } catch (e) {
      _updateState(GgTaskStatus.error);
      rethrow;
    }
  }

  // ...........................................................................
  set status(GgTaskStatus status) => _updateState(status);

  // ...........................................................................
  /// The print callback used. Is print by default
  final void Function(String) printCallback;

  /// Replace messages using carriage return
  final bool useCarriageReturn;

  /// The message to be displayed
  final String message;

  // ...........................................................................
  /// Carriage return string
  static const String carriageReturn = '\x1b[1A\x1b[2K';

  // ...........................................................................
  /// Log the result of the command
  void _updateState(GgTaskStatus state) {
    // On GitHub we have no carriage return.
    // Thus we not logging the icon the first time
    var cr = useCarriageReturn ? carriageReturn : '';

    final msg = switch (state) {
      GgTaskStatus.success => '$cr✅ $message',
      GgTaskStatus.error => '$cr❌ $message',
      _ => '⌛️ $message',
    };

    printCallback(msg);
  }
}

// #############################################################################
/// The state of the log
enum GgTaskStatus {
  /// The command is running
  running,

  /// The command was successful
  success,

  /// The command failed
  error,
}
