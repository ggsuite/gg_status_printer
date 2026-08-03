// @license
// Copyright (c) 2019 - 2024 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'package:gg_console_colors/gg_console_colors.dart';
import 'package:gg_is_github/gg_is_github.dart';
import 'package:gg_log/gg_log.dart';

/// A printer for displaying status messages
class GgStatusPrinter<T> {
  /// The constructor
  GgStatusPrinter({
    required this.message,
    this.ggLog = print,
    bool? useCarriageReturn,
    this.colorize = true,
    this.dark = false,
  }) : useCarriageReturn = useCarriageReturn ?? !isGitHub;

  // ...........................................................................
  /// Run the operation and display the status
  ///
  /// - [task] to be executed.
  ///   - If the task throws an exception, an error state will be printed.
  ///   - If the task completes successfully, a success state will be printed.
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
  ///
  /// - [task] The task to be executed
  /// - [success] A function that takes the result and decides if the task was
  ///   successful.
  ///   - If the function returns true, a success state will be printed.
  ///   - If the function returns false, an error state will be printed.
  Future<T> logTask({
    required Future<T> Function() task,
    required bool Function(T result) success,
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
  /// Just print a status
  void logStatus(GgStatusPrinterStatus status) {
    _updateState(status);
  }

  // ...........................................................................
  set status(GgStatusPrinterStatus status) => _updateState(status);

  // ...........................................................................
  /// The print callback used. Is print by default
  final GgLog ggLog;

  /// Replace messages using carriage return
  final bool useCarriageReturn;

  /// Whether the status mark carries its semantic color.
  ///
  /// `✓` is wrapped in [cSuccess], `✗` in [cError]. The message itself stays
  /// neutral either way. Set to false when the caller renders the mark on its
  /// own.
  final bool colorize;

  /// Whether the default text is dimmed using [darkGray].
  ///
  /// The status mark is dimmed as well instead of carrying its semantic
  /// color. Ignored when [colorize] is false.
  final bool dark;

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
      GgStatusPrinterStatus.success =>
        '$cr${_mark(cSuccess, '✓')} ${_text(message)}',
      GgStatusPrinterStatus.error =>
        '$cr${_mark(cError, '✗')} ${_text(message)}',
      _ => '⌛️ ${_text(message)}',
    };

    ggLog(msg);
  }

  // ...........................................................................
  /// Returns [mark] wrapped in [color], dimmed when [dark] is set, or plain
  /// when [colorize] is false.
  ///
  /// Only the mark is colored — the message stays neutral so it does not
  /// compete with the lines the user actually has to read, and the caller
  /// stays free to color it. The carriage return sequence is added outside,
  /// so the escape codes never wrap the cursor movement. A dark line is meant
  /// to recede as a whole, so the mark is dimmed together with the message
  /// instead of carrying its semantic color.
  String _mark(String Function(Object) color, String mark) =>
      colorize ? (dark ? darkGray(mark) : color(mark)) : mark;

  // ...........................................................................
  /// Returns [text] dimmed when [dark] is set, or plain otherwise.
  ///
  /// [dark] is ignored when [colorize] is false, i.e. a caller that opted out
  /// of colors never gets escape sequences.
  String _text(String text) => colorize && dark ? darkGray(text) : text;
}

/// Deletes the carriage and colors return from strings
String rmControls(String str) {
  var result = str.replaceAll(GgStatusPrinter.carriageReturn, '');
  result = rmConsoleColors(result);
  return result;
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
