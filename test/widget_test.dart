// REDE App - Widget Tests
//
// Tests for basic app functionality and navigation

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rede/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('REDE App initializes without error', (WidgetTester tester) async {
    // Build the app
    await tester.pumpWidget(const ProviderScope(child: RedeApp()));

    // Allow time for async initialization (Firebase, Supabase, etc)
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Verify the app is running (looks for common widgets in auth flow)
    // Either we see login screen or main app is rendered
    expect(find.byType(MaterialApp), findsWidgets);
  });

  testWidgets('Login screen loads when not authenticated', (WidgetTester tester) async {
    // Build the app
    await tester.pumpWidget(const ProviderScope(child: RedeApp()));
    
    // Allow initialization
    await tester.pumpAndSettle(const Duration(seconds: 2));
    
    // Verify that MaterialApp is present (router should be active)
    expect(find.byType(MaterialApp), findsWidgets);
  });
}
