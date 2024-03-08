# gg_status_printer

## Description

`GgStatusPrinter` is a Dart package designed to enhance user feedback during the execution of asynchronous operations, commonly represented as "promises" in many programming languages. Although Dart uses Future instead of Promise, the concept remains similar. This package aims to simplify the process of notifying users about the status of these asynchronous operations.

Upon initiating an asynchronous operation, it's often beneficial to provide immediate feedback to the user, indicating that the process has begun. `GgStatusPrinter` tackles this by automatically displaying a temporary message prefixed with a "⌛️" (hourglass) emoji, signifying that the operation is in progress.

Once the operation completes, the package updates the feedback based on the outcome of the operation. If the operation succeeds, it displays a message prefixed with "✅" (check mark), indicating success. Conversely, if the operation encounters an error or fails, the package shows a message prefixed with "❌" (cross mark), signaling failure.

This package streamlines the process of providing real-time, user-friendly feedback for asynchronous operations, enhancing the overall user experience by keeping users informed about the status of background tasks.

## Features

- **Automatic Feedback on Start**: Automatically prints a message with "⌛️" to indicate the beginning of an operation.
- **Success Notification**: On successful completion of the asynchronous operation, it prints the original message prefixed with "✅".
- **Error Notification**: In case of failure, it prints the original message prefixed with "❌".
- **Customizable Messages**: Allows customization of the initial, success, and error messages to fit the needs of different applications.
- **Easy Integration**: Designed to be easily integrated into existing Dart projects with minimal configuration.

## How It Works

- **Initialization**: Import the `GgStatusPrinter` package into your Dart project.
- **Wrap Asynchronous Operations**: Use to wrap any asynchronous operation, providing a message that describes the operation.
- **Automatic Notifications**: The package automatically handles the printing of the appropriate message based on the status of the operation without requiring manual intervention.

## Example Usage

```dart
import 'package:gg_status_printer/gg_status_printer.dart';

void main() async {
  print('\nPrint all states one the same line');
  // ⌛️✅ Loading data
  await const GgStatusPrinter<void>(
    message: 'Loading data',
    useCarriageReturn: true,
  ).run(() => Future<void>.delayed(const Duration(seconds: 1)));

  print('\nPrint all states on different lines');
  // ⌛️ Loading data
  // ✅ Loading data
  await const GgStatusPrinter<void>(
    message: 'Loading data',
    useCarriageReturn: false,
  ).run(() => Future<void>.delayed(const Duration(seconds: 1)));

  print('\nPrint fail states');
  // ⌛️ Loading data
  // ❌ Loading data

  try {
    await const GgStatusPrinter<void>(
      message: 'Loading data',
      useCarriageReturn: false,
    ).run(
      () => Future<void>.delayed(const Duration(seconds: 1))
          .then((_) => throw Exception('Failed')),
    );
  } catch (_) {}
}

```
