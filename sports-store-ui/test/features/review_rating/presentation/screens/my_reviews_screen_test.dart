import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sports_store_mobile/core/theme/app_theme.dart';
import 'package:sports_store_mobile/features/review_rating/presentation/screens/my_reviews_screen.dart';

void main() {
  testWidgets('MyReviewsScreen hiển thị hồ sơ đánh giá và 2 tabs trạng thái', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: const MyReviewsScreen(),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Verify AppBar
    expect(find.text('ĐÁNH GIÁ CỦA TÔI'), findsOneWidget);

    // Verify Avatar & User Profile
    expect(find.text('Trần Hoàng Nhật'), findsOneWidget);
    expect(find.text('ADICLUB VIP'), findsOneWidget);

    // Verify Thống kê số ở trên & chữ ĐÁNH GIÁ ở dưới
    expect(find.text('ĐÁNH GIÁ'), findsWidgets);

    // Verify 2 Tabs
    expect(find.textContaining('CHƯA ĐÁNH GIÁ'), findsOneWidget);
    expect(find.textContaining('ĐÃ ĐÁNH GIÁ'), findsOneWidget);

    // Verify các sản phẩm chờ đánh giá
    expect(find.textContaining('ULTRABOOST LIGHT'), findsOneWidget);
    expect(find.text('ĐÁNH GIÁ').first, findsWidgets);

    // Chuyển sang Tab Đã đánh giá
    await tester.tap(find.textContaining('ĐÃ ĐÁNH GIÁ'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Verify các đánh giá cá nhân đã viết
    expect(find.textContaining('ADIZERO ADIOS PRO 3'), findsOneWidget);
    expect(find.textContaining('Lightstrike Pro siêu nảy'), findsOneWidget);
  });
}
