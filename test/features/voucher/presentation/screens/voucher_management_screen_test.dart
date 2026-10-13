import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sports_store_mobile/core/theme/app_theme.dart';
import 'package:sports_store_mobile/features/voucher/presentation/screens/voucher_management_screen.dart';
import 'package:sports_store_mobile/features/voucher/presentation/widgets/voucher_card_widget.dart';

import 'package:sports_store_mobile/features/voucher/data/datasources/voucher_mock_data.dart';

void main() {
  testWidgets('VoucherCardWidget hiển thị thông tin voucher chính xác', (tester) async {
    final voucher = VoucherMockData.getAvailableVouchers().first;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: Scaffold(
          body: ListView(
            children: [
              VoucherCardWidget(voucher: voucher),
            ],
          ),
        ),
      ),
    );

    expect(find.byType(VoucherCardWidget), findsOneWidget);
    expect(find.text('ADICLUB15'), findsOneWidget);
  });

  testWidgets('VoucherManagementScreen hiển thị danh sách voucher và cho phép chuyển tab và trượt nhập mã', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: const VoucherManagementScreen(),
      ),
    );

    await tester.pumpAndSettle();

    // Verify AppBar & Action buttons
    expect(find.text('KHO VOUCHER'), findsOneWidget);
    expect(find.text('NHẬP MÃ VOUCHER'), findsOneWidget);
    expect(find.text('TÌM THÊM VOUCHER'), findsOneWidget);

    // Verify Tab headers
    expect(find.textContaining('VOUCHER CỦA TÔI'), findsOneWidget);
    expect(find.textContaining('ĐÃ DÙNG / HẾT HẠN'), findsOneWidget);

    // Verify Vouchers rendered in Ví của tôi
    expect(find.byType(VoucherCardWidget), findsWidgets);
    expect(find.text('ADICLUB15'), findsOneWidget);

    // Test trượt mở ô nhập mã
    await tester.tap(find.text('NHẬP MÃ VOUCHER'));
    await tester.pumpAndSettle();
    expect(find.text('ÁP DỤNG'), findsOneWidget);

    // Bấm nút TÌM THÊM VOUCHER để mở màn hình riêng
    await tester.tap(find.text('TÌM THÊM VOUCHER'));
    await tester.pumpAndSettle();

    // Verify đã điều hướng sang màn hình riêng DiscoverVouchersScreen
    expect(find.textContaining('ƯU ĐÃI THEO DÒNG SẢN PHẨM'), findsOneWidget);
    expect(find.text('RUNNING15'), findsOneWidget);
    expect(find.text('LƯU MÃ'), findsWidgets);

    // Nhấn Lưu mã RUNNING15 trong màn hình riêng
    await tester.tap(find.text('LƯU MÃ').first);
    await tester.pumpAndSettle();
    expect(find.text('ĐÃ LƯU ✓'), findsWidgets);

    // Quay lại màn hình Ví voucher
    await tester.pageBack();
    await tester.pumpAndSettle();

    // Chuyển sang Tab Hết hạn
    await tester.tap(find.textContaining('ĐÃ DÙNG / HẾT HẠN'));
    await tester.pumpAndSettle();
    expect(find.text('WELCOME50K'), findsOneWidget);
  });
}
