import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sports_store_mobile/core/theme/app_theme.dart';
import 'package:sports_store_mobile/features/voucher/presentation/widgets/apply_voucher_bottom_sheet.dart';

void main() {
  testWidgets('ApplyVoucherBottomSheet hiển thị đúng và không lỗi layout', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  ApplyVoucherBottomSheet.show(
                    context: context,
                    orderTotal: 1500000,
                  );
                },
                child: const Text('MỞ VOUCHER'),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('MỞ VOUCHER'));
    await tester.pumpAndSettle();

    // Verify modal rendered without layout errors
    expect(find.text('ÁP DỤNG MÃ GIẢM GIÁ'), findsOneWidget);
    expect(find.text('MÃ GIẢM GIÁ KHẢ DỤNG'), findsOneWidget);
    expect(find.text('ADICLUB15'), findsOneWidget);
    expect(find.text('ÁP DỤNG'), findsOneWidget);
  });
}
