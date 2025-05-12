import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'order_provider.dart';

//在单个页面中使用 ChangeNotifierProvider 是一个很好的做法，
// 这样可以实现页面级别的状态管理。这种方式的优点是：
//
// 1. 状态隔离
//    - 每个页面的状态都是独立的，不会相互影响
//    - 状态的生命周期与页面保持一致，页面销毁时状态也会被销毁

// 2. 代码组织清晰
//    - 状态管理逻辑与页面紧密关联
//    - 避免了全局状态管理的复杂性
//    - 便于维护和测试

// 3. 性能优化
//    - 状态变化只会影响当前页面
//    - 不会触发其他页面的重建
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
