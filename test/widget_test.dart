// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

import 'package:planify/main.dart';
import 'package:planify/src/features/theme/cubit/theme_cubit.dart';

class MockThemeCubit extends Mock implements ThemeCubit {}

void main() {
  late final ThemeCubit themeCubit;

  testWidgets('App builds without error', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const App());

    // Verify that the app builds successfully
    expect(find.byType(App), findsOneWidget);
  });
}
