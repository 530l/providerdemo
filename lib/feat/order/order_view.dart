import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'order_provider.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => OrderProvider(),
      builder: (context, child) => _buildPage(context),
    );
  }

  Widget _buildPage(BuildContext context) {
    final provider = context.read<OrderProvider>();
    final state = provider.state;

    return Container();
  }
}