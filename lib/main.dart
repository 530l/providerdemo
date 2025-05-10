import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/counter_model.dart';
import 'models/login_status_model.dart';
import 'models/user_model.dart';

import 'pages/home_page.dart';
import 'pages/change_notifier_page.dart';
import 'pages/selector_page.dart';
import 'pages/future_provider_page.dart';
import 'pages/stream_provider_page.dart';
import 'pages/proxy_provider_page.dart';

void main() {
  runApp(
    // 使用MultiProvider提供多个状态模型
    MultiProvider(
      providers: [
        // 基本的ChangeNotifier Provider
        ChangeNotifierProvider(create: (context) => CounterModel()),
        // 登录状态Provider
        ChangeNotifierProvider(create: (context) => LoginStatusModel()),
        // 用户信息Provider
        ChangeNotifierProvider(create: (context) => UserModel()),
        // 其他Provider将在各自的示例页面中演示
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Provider Demo',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      // 设置路由
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/change_notifier': (context) => const ChangeNotifierPage(),
        '/selector': (context) => const SelectorPage(),
        '/future_provider': (context) => const FutureProviderPage(),
        '/stream_provider': (context) => const StreamProviderPage(),
        '/proxy_provider': (context) => const ProxyProviderPage(),
      },
    );
  }
}
