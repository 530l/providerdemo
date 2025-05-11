import 'package:flutter/material.dart';
import '../routes/routes_config.dart';

/// 首页 - 展示不同Provider示例的导航菜单
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Provider示例'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildNavCard(
            context,
            title: 'ChangeNotifier Provider',
            subtitle: '基础的状态管理，用于监听整个对象的变化',
            route: ROUTE_CHANGE_NOTIFIER,
          ),
          _buildNavCard(
            context,
            title: 'Selector',
            subtitle: '细粒度的状态监听，只监听特定属性的变化',
            route: ROUTE_SELECTOR,
          ),
          _buildNavCard(
            context,
            title: 'FutureProvider',
            subtitle: '处理异步数据，适用于一次性的异步操作',
            route: ROUTE_FUTURE_PROVIDER,
          ),
          _buildNavCard(
            context,
            title: 'StreamProvider',
            subtitle: '处理流式数据，适用于持续的数据更新',
            route: ROUTE_STREAM_PROVIDER,
          ),
          _buildNavCard(
            context,
            title: 'ProxyProvider',
            subtitle: '组合多个Provider，创建依赖于其他Provider的数据',
            route: ROUTE_PROXY_PROVIDER,
          ),
          _buildNavCard(
            context,
            title: '单页面使用ChangeNotifierProvider',
            subtitle: '单页面使用ChangeNotifierProvider，就在当前 element 节点获取。不对外',
            route: ROUTE_USER_CENTER,
          ),
        ],
      ),
    );
  }

  /// 构建导航卡片
  Widget _buildNavCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String route,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () => Navigator.pushNamed(context, route),
      ),
    );
  }
}
