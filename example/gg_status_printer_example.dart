#!/usr/bin/env dart
// @license
// Copyright (c) 2019 - 2024 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

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
