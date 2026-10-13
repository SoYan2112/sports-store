import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sports_store_mobile/core/theme/app_theme.dart';
import 'package:sports_store_mobile/features/review_rating/presentation/screens/review_list_screen.dart';
import 'package:sports_store_mobile/features/review_rating/presentation/widgets/review_card_widget.dart';

void main() {
  testWidgets('ReviewListScreen hiển thị tổng quan rating, filter chips và danh sách đánh giá', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: const ReviewListScreen(),
      ),
    );

    await tester.pumpAndSettle();

    // Verify AppBar & Title
    expect(find.text('ĐÁNH GIÁ SẢN PHẨM'), findsOneWidget);
    expect(find.text('ULTRABOOST LIGHT 23'), findsOneWidget);

    // Verify Rating overview
    expect(find.text('4.8'), findsOneWidget);
    expect(find.text('128 đánh giá'), findsOneWidget);

    // Verify Filter chips
    expect(find.textContaining('Tất cả'), findsOneWidget);
    expect(find.textContaining('5 sao'), findsOneWidget);

    // Verify Review cards
    expect(find.byType(ReviewCardWidget), findsWidgets);
    expect(find.text('Trần Hoàng Nhật'), findsOneWidget);

    // Verify Bottom CTA
    expect(find.text('VIẾT ĐÁNH GIÁ SẢN PHẨM'), findsOneWidget);
  });
}
