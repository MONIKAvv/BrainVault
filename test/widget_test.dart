import 'package:flutter_test/flutter_test.dart';
import 'package:brainvault/app/app.dart';
import 'package:brainvault/core/constants/app_strings.dart';

void main() {
  testWidgets('Onboarding screen loads title and skip button',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const BrainVaultApp());

    // Verify that the first onboarding title and skip button are present
    expect(find.text(AppStrings.onboardingTitle1), findsOneWidget);
    expect(find.text(AppStrings.skip), findsOneWidget);
  });
}
