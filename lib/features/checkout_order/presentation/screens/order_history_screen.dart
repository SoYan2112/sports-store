import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/repositories/order_repository_impl.dart';
import '../../domain/entities/order_status.dart';
import '../bloc/order_bloc.dart';
import '../bloc/order_event.dart';
import '../bloc/order_state.dart';
import '../widgets/order_card_widget.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OrderBloc>(
      create: (context) => OrderBloc(
        orderRepository: OrderRepositoryImpl(),
      )..add(const FetchOrdersEvent()),
      child: const _OrderHistoryView(),
    );
  }
}

class _OrderHistoryView extends StatefulWidget {
  const _OrderHistoryView();

  @override
  State<_OrderHistoryView> createState() => _OrderHistoryViewState();
}

class _OrderHistoryViewState extends State<_OrderHistoryView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<OrderStatus> _tabs = [
    OrderStatus.all,
    OrderStatus.pending,
    OrderStatus.shipping,
    OrderStatus.delivered,
    OrderStatus.cancelled,
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(_onTabChanged);
  }

  void _onTabChanged() {
    if (!_tabController.indexIsChanging) {
      final selectedStatus = _tabs[_tabController.index];
      context.read<OrderBloc>().add(FilterOrdersByStatusEvent(selectedStatus));
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        elevation: 0,
        title: Text(
          'ĐƠN HÀNG CỦA TÔI',
          style: GoogleFonts.oswald(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            color: Colors.white,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: AppColors.neonVolt,
          indicatorWeight: 3,
          indicatorSize: TabBarIndicatorSize.label,
          labelColor: AppColors.neonVolt,
          unselectedLabelColor: AppColors.textGray,
          labelStyle: GoogleFonts.oswald(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
          unselectedLabelStyle: GoogleFonts.oswald(
            fontSize: 13,
            fontWeight: FontWeight.normal,
            letterSpacing: 1,
          ),
          tabs: _tabs.map((status) => Tab(text: status.label.toUpperCase())).toList(),
        ),
      ),
      body: BlocConsumer<OrderBloc, OrderState>(
        listener: (context, state) {
          if (state is OrderLoaded && state.successMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: AppColors.neonVolt,
                content: Text(
                  state.successMessage!,
                  style: GoogleFonts.montserrat(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                duration: const Duration(seconds: 2),
              ),
            );
          } else if (state is OrderError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: AppColors.error,
                content: Text(
                  state.message,
                  style: GoogleFonts.montserrat(color: Colors.white),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is OrderLoading || state is OrderInitial) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.neonVolt),
            );
          }

          if (state is OrderError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: AppColors.error),
                  const SizedBox(height: 16),
                  Text(
                    'ĐÃ XẢY RA LỖI',
                    style: GoogleFonts.oswald(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(color: AppColors.textGray),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.white,
                      foregroundColor: AppColors.black,
                      minimumSize: const Size(180, 46),
                    ),
                    onPressed: () {
                      context.read<OrderBloc>().add(const FetchOrdersEvent());
                    },
                    child: const Text('THỬ LẠI'),
                  ),
                ],
              ),
            );
          }

          if (state is OrderLoaded) {
            final orders = state.filteredOrders;

            if (orders.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.receipt_long_outlined,
                        size: 72,
                        color: AppColors.textGray,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'CHƯA CÓ ĐƠN HÀNG',
                        style: GoogleFonts.oswald(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Bạn chưa có đơn hàng nào trong mục "${state.currentStatus.label}".',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          color: AppColors.textGray,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 24),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white),
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'TIẾP TỤC KHÁM PHÁ',
                          style: GoogleFonts.oswald(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return RefreshIndicator(
              color: AppColors.black,
              backgroundColor: AppColors.neonVolt,
              onRefresh: () async {
                context.read<OrderBloc>().add(const FetchOrdersEvent());
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return OrderCardWidget(
                    order: order,
                    onCancel: () {
                      context.read<OrderBloc>().add(CancelOrderEvent(order.id));
                    },
                  );
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

