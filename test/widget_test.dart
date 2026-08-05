import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:prueba/main.dart';

void main() {
  testWidgets('application renders its startup shell', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: ServicesTectonicsApp()));

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(Scaffold), findsOneWidget);
  });
}
